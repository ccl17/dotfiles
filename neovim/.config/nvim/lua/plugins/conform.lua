return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>F',
      function() require('conform').format({ async = true, lsp_fallback = true }) end,
      mode = 'n',
      desc = 'Format buffer',
    },
  },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        go = { 'goimports' },
        json = { 'prettier' },
        lua = { 'stylua' },
        ruby = { 'rubocop' },
        yaml = { 'yamlfmt' },
      },
      formatters = {
        rubocop = {
          inherit = false,
          command = 'bundle',
          args = {
            'exec',
            'rubocop',
            '-f',
            'quiet',
            '--auto-correct',
            '--fix-layout',
            '--stderr',
            '--stdin',
            '$FILENAME',
          },
          cwd = require('conform.util').root_file({ '.rubocop.yml' }),
          require_cwd = true,
        },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      },
      init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    })
  end,
}
