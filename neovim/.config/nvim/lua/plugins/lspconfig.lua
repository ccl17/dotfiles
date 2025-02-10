local methods = vim.lsp.protocol.Methods

local servers = {
  bashls = {},
  dockerls = {},
  gopls = {
    settings = {
      gopls = {
        directoryFilters = { '-.git', '-node_modules', '-vendor' },
        gofumpt = false,
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
  lua_ls = {
    settings = {
      Lua = {
        format = { enable = false },
        hint = { enable = true, arrayIndex = 'Disable' },
      },
    },
  },
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
    vim.g.inlay_hints = true
    local inlay_hints_group = vim.api.nvim_create_augroup('sc/inlay_hints', { clear = false })

    vim.defer_fn(function()
      local mode = vim.api.nvim_get_mode().mode
      vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v', { bufnr = buffer })
    end, 500)

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = inlay_hints_group,
      desc = 'Enable inlay hints',
      buffer = buffer,
      callback = function()
        if vim.g.inlay_hints then vim.lsp.inlay_hint.enable(false, { bufnr = buffer }) end
      end,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = inlay_hints_group,
      desc = 'Disable inlay hints',
      buffer = buffer,
      callback = function()
        if vim.g.inlay_hints then vim.lsp.inlay_hint.enable(true, { bufnr = buffer }) end
      end,
    })
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
    { 'saghen/blink.cmp' },
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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

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
  end,
}
