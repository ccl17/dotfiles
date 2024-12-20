local methods = vim.lsp.protocol.Methods

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
          parameterNames = true,
        },
      },
    },
  },
  jsonls = {},
  lua_ls = {},
  terraformls = {},
  yamlls = {},
}

-- LSP keymaps, autocommands
---@param client vim.lsp.Client
---@param buffer integer
local on_attach = function(client, buffer)
  -- keymaps
  vim.keymap.set(
    'n',
    'gd',
    '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto definition' }
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto references' }
  )
  vim.keymap.set(
    'n',
    'gt',
    '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto type definition' }
  )
  vim.keymap.set(
    'n',
    'gi',
    '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto implementations' }
  )
  vim.keymap.set(
    'n',
    'gD',
    '<cmd>FzfLua lsp_declarations jump_to_single_result=true ignore_current_line=true<cr>',
    { desc = 'Goto declaration' }
  )
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Signature help' })
  vim.keymap.set('n', 'ga', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'Code action' })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

  -- cursor highlight
  if client.supports_method(methods.textDocument_documentHighlight) then
    local highlight_group = vim.api.nvim_create_augroup('sc/cursor_highlight_attach', { clear = true })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buffer,
      group = highlight_group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buffer,
      group = highlight_group,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('sc/cursor_highlight_detach', { clear = true }),
      callback = function()
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'sc/cursor_highlight_attach', buffer = buffer })
      end,
    })
  end

  -- inlay hint
  if client.supports_method(methods.textDocument_inlayHint) then
    if not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }) then
      vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
    end
    vim.keymap.set(
      'n',
      '<leader>xi',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })) end,
      { desc = 'Toggle inlay hint' }
    )
  end
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'williamboman/mason.nvim',
      cmd = 'Mason',
      build = ':MasonUpdate',
      config = true,
    },
    { 'williamboman/mason-lspconfig.nvim' },
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'dgagn/diagflow.nvim', lazy = true },
  },
  config = function()
    local on_dynamic_capability = function(fn, opts)
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

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'Configure LSP',
      group = vim.api.nvim_create_augroup('sc/lsp_attach', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local register_capability = vim.lsp.handlers['client/registerCapability']
        vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
          local ret = register_capability(err, res, ctx)

          vim.api.nvim_exec_autocmds('User', {
            pattern = 'LspDynamicCapability',
            data = { client_id = client.id, buffer = args.buf },
          })
          return ret
        end

        on_attach(client, args.buf)
        on_dynamic_capability(on_attach)
      end,
    })

    -- LSP servers
    require('mason').setup()
    local mlsp, lspconfig = require('mason-lspconfig'), require('lspconfig')
    local ensure_installed = vim.tbl_keys(servers or {})

    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local capabilities =
      vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())

    mlsp.setup({
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    })

    -- diagnostics
    local diagnostic_icons = require('icons').diagnostics
    for sev, icon in pairs(diagnostic_icons) do
      local hl = 'DiagnosticSign' .. sev:sub(1, 1) .. sev:sub(2):lower()
      vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end
    require('diagflow').setup({ show_sign = true })
  end,
}
