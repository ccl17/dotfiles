return {
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
      opts = {
        ensure_installed = {
          'bashls',
          'dockerls',
          'gopls',
          'jsonls',
          'lua_ls',
          'terraformls',
          'tsserver',
          'vuels',
          'yamlls',
        },
        handlers = {
          function(name)
            local config = require('plugins.lsp.servers')(name)
            if config then require('lspconfig')[name].setup(config) end
          end,
        },
      },
    },
  },
  config = function()
    require('plugins.lsp.lsp').setup()
    require('lspconfig').solargraph.setup(require('plugins.lsp.servers')('solargraph'))
  end,
}
