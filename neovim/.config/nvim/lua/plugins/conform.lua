local f = require('util.functions')

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        go = { 'goimports' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        lua = { 'stylua' },
        ruby = { 'rubocop' },
        vue = { 'prettier' },
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
      format_on_save = function(bufnr)
        if f.enabled(bufnr) then return { timeout_ms = 1000, lsp_format = 'fallback' } end
      end,
    })

    vim.keymap.set('n', '<leader>uf', function() f.toggle(true) end, { desc = 'toggle buffer autoformat' })
    vim.keymap.set('n', '<leader>uF', function() f.toggle() end, { desc = 'toggle global autoformat' })
  end,
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
}
