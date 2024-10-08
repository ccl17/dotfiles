local icons = require('util.icons')

local Lsp = {}

---@param on_attach fun(client:vim.lsp.Client, buffer:number)
function Lsp.on_attach(on_attach)
  return vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then return on_attach(client, buffer) end
    end,
  })
end

-- Hook to allow custom callbacks on dynamic capabilities
---@param fn fun(client:vim.lsp.Client, buffer):boolean?
---@param opts? {group?: integer}
function Lsp.on_dynamic_capability(fn, opts)
  return vim.api.nvim_create_autocmd('User', {
    pattern = 'LspDynamicCapability',
    group = opts and opts.group or nil,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer
      if client then return fn(client, buffer) end
    end,
  })
end

-- Hook to allow custom callbacks on support method
function Lsp.on_supports_method(method, fn)
  Lsp._supports_method[method] = Lsp._supports_method[method] or setmetatable({}, { __mode = 'k' })
  return vim.api.nvim_create_autocmd('User', {
    pattern = 'LspSupportsMethod',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer
      if client and method == args.data.method then return fn(client, buffer) end
    end,
  })
end

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
Lsp._supports_method = {}

-- executes LspSupportsMethod callback for all attached buffers of a client when a new method is supported
function Lsp._check_methods(client, buffer)
  -- don't trigger on invalid buffers
  if not vim.api.nvim_buf_is_valid(buffer) then return end
  -- don't trigger on non-listed buffers
  if not vim.bo[buffer].buflisted then return end
  -- don't trigger on nofile buffers
  if vim.bo[buffer].buftype == 'nofile' then return end
  for method, clients in pairs(Lsp._supports_method) do
    clients[client] = clients[client] or {}
    if not clients[client][buffer] then
      if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
        clients[client][buffer] = true
        vim.api.nvim_exec_autocmds('User', {
          pattern = 'LspSupportsMethod',
          data = { client_id = client.id, buffer = buffer, method = method },
        })
      end
    end
  end
end

function Lsp.document_highlight(_, buffer)
  local augroup = vim.api.nvim_create_augroup(('LspReferences%d'):format(buffer), { clear = true })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = augroup,
    buffer = buffer,
    callback = function() vim.lsp.buf.document_highlight() end,
  })
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = augroup,
    buffer = buffer,
    callback = function() vim.lsp.buf.clear_references() end,
  })
end

Lsp._keys = {
  {
    'n',
    'gd',
    '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'goto definition', has = 'definition' },
  },
  {
    'n',
    'gr',
    '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'goto references', has = 'references' },
  },
  {
    'n',
    'gt',
    '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'goto type definition', has = 'typeDefinition' },
  },
  {
    'n',
    'gi',
    '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'goto implementations', has = 'implementation' },
  },
  {
    'n',
    'gD',
    '<cmd>FzfLua lsp_declarations jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'goto declaration', has = 'declaration' },
  },
  { 'n', 'K', vim.lsp.buf.hover, { desc = 'hover', has = 'hover' } },
  { 'n', 'gs', vim.lsp.buf.signature_help, { desc = 'signature help', has = 'signatureHelp' } },
  { 'n', 'ga', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'code action', has = 'codeAction' } },
  { 'n', '<leader>rn', vim.lsp.buf.rename, { desc = 'rename', has = 'rename' } },
}

---@param method string|string[]
function Lsp.has(buffer, method)
  if type(method) == 'table' then
    for _, m in ipairs(method) do
      if not Lsp.has(buffer, m) then return false end
    end
    return true
  end
  method = method:find('/') and method or 'textDocument/' .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then return true end
  end
end

function Lsp.setup_keymaps(_, buffer)
  for _, keys in ipairs(Lsp._keys) do
    local opts = keys[4]
    if not opts.has or Lsp.has(buffer, opts.has) then
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys[1], keys[2], keys[3], opts)
    end
  end
end

function Lsp.setup()
  -- keymaps
  Lsp.on_attach(Lsp.setup_keymaps)

  -- handle dynamic capability with user event
  local register_capability = vim.lsp.handlers['client/registerCapability']
  vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buffer in pairs(client.attached_buffers) do
        vim.api.nvim_exec_autocmds('User', {
          pattern = 'LspDynamicCapability',
          data = { client_id = client.id, buffer = buffer },
        })
      end
    end
    return ret
  end
  Lsp.on_attach(Lsp._check_methods)
  Lsp.on_dynamic_capability(Lsp._check_methods)
  Lsp.on_dynamic_capability(Lsp.setup_keymaps)
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'dgagn/diagflow.nvim',
    {
      'folke/neodev.nvim',
      ft = 'lua',
      opts = { library = { plugins = { 'nvim-dap-ui' } } },
    },
    {
      'folke/neoconf.nvim',
      cmd = { 'Neoconf' },
      opts = { local_settings = '.nvim.json', global_settings = 'nvim.json' },
    },
    {
      'williamboman/mason.nvim',
      cmd = 'Mason',
      build = ':MasonUpdate',
      opts = {},
    },
    {
      'williamboman/mason-lspconfig.nvim',
      config = function() end,
    },
  },
  config = function()
    Lsp.setup()

    -- diagnostics
    local signs = {
      Hint = icons.diagnostics.hint,
      Info = icons.diagnostics.information,
      Warn = icons.diagnostics.warning,
      Error = icons.diagnostics.error,
    }
    for sev, text in pairs(signs) do
      local level = 'DiagnosticSign' .. sev
      vim.fn.sign_define(level, { text = text, texthl = level })
    end

    require('diagflow').setup({ scope = 'line', show_sign = true })

    -- inlay hints
    Lsp.on_supports_method('textDocument/inlayHint', function(_, buffer)
      if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == '' then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end)

    -- codeactions
    -- codelens

    -- cursor word highlighting
    Lsp.on_supports_method('textDocument/documentHighlight', Lsp.document_highlight)

    -- lsp servers
    local servers = {
      bashls = {},
      dockerls = {},
      gopls = {
        settings = {
          gopls = {
            directoryFilters = { '-node_modules', '-vendor' },
            gofumpt = true,
            semanticTokens = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            staticcheck = true,
            hints = {
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
            },
          },
        },
      },
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            codeLens = { enable = true },
            hint = {
              enable = true,
              arrayIndex = 'Disable',
              setType = false,
              paramName = 'Disable',
              paramType = true,
            },
            format = { enable = false },
            diagnostics = {
              globals = { 'vim', 'P', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins', 'pending' },
            },
            completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
      rubocop = {
        cmd = { os.getenv('HOME') .. '/.rbenv/shims/rubocop', '--lsp' },
        -- using rbenv managed rubocop
        mason = false,
      },
      solargraph = {
        cmd = { os.getenv('HOME') .. '/.rbenv/shims/solargraph', 'stdio' },
        init_options = {
          formatting = false,
        },
        settings = {
          solargraph = {
            diagnostics = false,
          },
        },
        -- using rbenv managed solargraph
        mason = false,
      },
      terraformls = {},
      ts_ls = {},
      vuels = {
        filetypes = { 'javascript', 'vue' },
      },
      yamlls = {},
    }
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local capabilities =
      vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())

    local function setup(server)
      local server_opts =
        vim.tbl_deep_extend('force', { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
      require('lspconfig')[server].setup(server_opts)
    end

    local mlsp = require('mason-lspconfig')
    local all_mlsp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)

    local ensure_installed = {}
    for server, server_opts in pairs(servers) do
      if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
        -- run manual setup if server is not installed via mason-lspconfig
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end

    mlsp.setup({
      ensure_installed = ensure_installed,
      handlers = { setup },
    })
  end,
}
