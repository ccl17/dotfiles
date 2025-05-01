local methods = vim.lsp.protocol.Methods

-- LSP keymaps, autocommands
---@param client vim.lsp.Client
---@param buffer integer
local on_attach = function(client, buffer)
  -- keymaps
  vim.keymap.set(
    'n',
    'gd',
    '<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>',
    { desc = 'Goto definition' }
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>',
    { desc = 'Goto references' }
  )
  vim.keymap.set(
    'n',
    'gt',
    '<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>',
    { desc = 'Goto type definition' }
  )
  vim.keymap.set(
    'n',
    'gi',
    '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>',
    { desc = 'Goto implementations' }
  )
  vim.keymap.set(
    'n',
    'gD',
    '<cmd>FzfLua lsp_declarations jump1=true ignore_current_line=true<cr>',
    { desc = 'Goto declaration' }
  )
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Signature help' })
  vim.keymap.set('n', 'ga', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'Code action' })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

  -- document highlight
  if client:supports_method(methods.textDocument_documentHighlight) then
    local document_highlight_group = vim.api.nvim_create_augroup('sc/document_highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'FocusGained' }, {
      group = document_highlight_group,
      desc = 'Highlight document references under the cursor',
      buffer = buffer,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave', 'FocusLost' }, {
      group = document_highlight_group,
      desc = 'Clear highlight references',
      buffer = buffer,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- signature help
  if client:supports_method(methods.textDocument_signatureHelp) then
    local blink_window = require('blink.cmp.completion.windows.menu')
    local blink = require('blink.cmp')

    vim.keymap.set('i', '<c-k>', function()
      -- Close the completion menu first (if open).
      if blink_window.win:is_open() then blink.hide() end

      vim.lsp.buf.signature_help()
    end, { desc = 'Signature help' })
  end

  -- inlay hint
  if client:supports_method(methods.textDocument_inlayHint) and vim.g.inlay_hints then
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

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = {
        {
          'williamboman/mason.nvim',
          cmd = 'Mason',
          config = function(_, opts)
            require('mason').setup(opts)
            local registry = require('mason-registry')
            registry.refresh(function()
              if opts.ensure_installed == nil then return end

              for _, ensure_install in ipairs(opts.ensure_installed) do
                local parts = {}
                for part in string.gmatch(ensure_install, '([^@]+)') do
                  table.insert(parts, part)
                end

                local pkg_name = parts[1]
                local pkg_opts = parts[2] and { version = parts[2] } or nil

                local pkg = registry.get_package(pkg_name)
                local installed = pkg:is_installed()

                if pkg_opts and pkg_opts.version then
                  for _, p in ipairs(registry.get_installed_packages()) do
                    if p.name == pkg_name then
                      p:get_installed_version(function(success, version_or_err)
                        if not success then return end
                        installed = installed and success and version_or_err == pkg_opts.version
                      end)
                    end
                  end
                end

                if not installed then pkg:install(pkg_opts) end
              end
            end)
          end,
        },
      },
    },
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
    { 'b0o/schemastore.nvim', version = false },
  },
  opts = function(_, opts)
    return vim.tbl_deep_extend('force', {}, opts.servers or {}, {
      servers = {
        bashls = {},
        dockerls = {},
        gopls = {
          settings = {
            gopls = {
              directoryFilters = { '-.git', '-node_modules', '-vendor' },
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
        jsonls = {
          init_options = {
            provideFormatter = false,
          },
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = false },
              hint = { enable = true, arrayIndex = 'Disable' },
            },
          },
        },
        terraformls = {},
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
              validate = true,
              format = {
                enable = false,
              },
            },
          },
        },
      },
    })
  end,
  config = function(_, opts)
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

    local mlsp, lspconfig = require('mason-lspconfig'), require('lspconfig')
    local ensure_installed = vim.tbl_keys(opts.servers or {})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

    mlsp.setup({
      ensure_installed = ensure_installed,
      handlers = {
        function(server_name)
          local server = opts.servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    })
  end,
}
