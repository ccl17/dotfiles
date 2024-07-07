local f, icons = require('util.functions'), require('util.icons')

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

function Lsp.setup_keymaps(_, buffer)
  local mappings = {
    {
      'n',
      'gr',
      vim.lsp.buf.references,
      'goto references',
      { silent = true },
    },
    {
      'n',
      'gd',
      vim.lsp.buf.definition,
      'goto definition',
      { silent = true },
    },
    {
      'n',
      'gt',
      vim.lsp.buf.type_definition,
      'goto type definition',
      { silent = true },
    },
    {
      'n',
      'gi',
      vim.lsp.buf.implementation,
      'goto implementations',
      { silent = true },
    },
    { 'n', 'K', vim.lsp.buf.hover, 'hover', { silent = true } },
    { 'n', 'ga', vim.lsp.buf.code_action, 'code action', { silent = true } },
    { 'n', 'gs', vim.lsp.buf.signature_help, 'signature help', { silent = true } },
    { 'n', '<leader>rn', ':IncRename', 'rename' },
  }

  for _, m in ipairs(mappings) do
    -- migrate away from built-in
    f.noremap(m[1], m[2], m[3], m[4], vim.tbl_deep_extend('force', { buffer = buffer }, m[5] or {}))
  end
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
        {
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.information,
            },
          },
        },
        -- inlay hints
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
      }
    end,
    config = function(_, opts)
      -- keymaps
      Lsp.on_attach(Lsp.setup_keymaps)

      -- diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- inlay hints

      -- codelens

      -- cursor word highlighting
      if opts.document_highlight.enabled then Lsp.on_attach(Lsp.document_highlight) end

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
