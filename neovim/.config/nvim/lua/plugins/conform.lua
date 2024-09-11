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
        vue = { 'prettier' },
        yaml = { 'yamlfmt' },
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
