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
    vim.lsp.buf.definition,
    { desc = 'goto definition', has = 'definition' },
  },
  {
    'n',
    'gr',
    vim.lsp.buf.references,
    { desc = 'goto references' },
  },
  {
    'n',
    'gt',
    vim.lsp.buf.type_definition,
    { desc = 'goto type definition' },
  },
  {
    'n',
    'gi',
    vim.lsp.buf.implementation,
    { desc = 'goto implementations' },
  },
  {
    'n',
    'gD',
    vim.lsp.buf.declaration,
    { desc = 'goto declaration' },
  },
  { 'n', 'K', vim.lsp.buf.hover, { desc = 'hover' } },
  { 'n', 'gs', vim.lsp.buf.signature_help, { desc = 'signature help' } },
  { 'n', 'ga', vim.lsp.buf.code_action, { desc = 'code action', has = 'codeAction' } },
  { 'n', '<leader>rn', vim.lsp.buf.rename, { desc = 'rename', has = 'rename' } },
}

---@param method string
function Lsp.has(buffer, method)
  method = method:find('/') and method or 'textDocument/' .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then return true end
  end
end

function Lsp.setup_keymaps(_, buffer)
  for _, keys in ipairs(Lsp._keys) do
    if not keys.has or Lsp.has(buffer, keys.has) then
      local opts = keys[4]
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
      for buffer in ipairs(client.attached_buffers) do
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
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
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
    opts = function()
      return {
        -- diagnostics
        ---@type vim.diagnostic.Opts
        diagnostics = {
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.information,
            },
          },
          update_in_insert = true,
        },
        -- inlay hints
        inlay_hints = {
          enabled = true,
          exclude = {},
        },
        -- codelens
        -- cursor word highlighting
        document_highlight = { enabled = true },
        -- global capabilities
        capabilities = {},
        -- formatting
        -- lsp servers
        servers = {
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
          tsserver = {},
          vuels = {
            filetypes = { 'javascript', 'vue' },
          },
          yamlls = {},
        },

        -- override lsp servers
        setup = {
          gopls = function(server, server_opts)
            Lsp.on_attach(function(client, _)
              if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
                  range = true,
                }
              end
            end)
          end,
        },
      }
    end,
    config = function(_, opts)
      Lsp.setup()

      -- diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- inlay hints
      if opts.inlay_hints.enabled then
        Lsp.on_supports_method('textDocument/inlayHint', function(client, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ''
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
            if type(ih) == 'function' then
              ih(buffer, true)
            elseif type(ih) == 'table' and ih.enable then
              ih.enable(true, { bufnr = buffer })
            end
          end
        end)
      end

      -- codelens

      -- cursor word highlighting
      if opts.document_highlight.enabled then
        Lsp.on_supports_method('textDocument/documentHighlight', Lsp.document_highlight)
      end

      -- global capabilities

      -- formatting

      -- lsp servers
      local servers = opts.servers
      local cmp_nvim_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts =
          vim.tbl_deep_extend('force', { capabilities = vim.deepcopy(capabilities) }, servers[server] or {})
        require('lspconfig')[server].setup(server_opts)
      end

      local mlsp = require('mason-lspconfig')
      local all_mlsp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        -- if setup function returns true, skip mason-lspconfig setup
        if opts.setup[server] and opts.setup[server](server, server_opts) then return end

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
  },
}
