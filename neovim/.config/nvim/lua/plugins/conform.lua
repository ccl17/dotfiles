local util = require('util')

return {
  'stevearc/conform.nvim',
  event = { 'LspAttach', 'BufWritePre' },
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  config = function()
    require('conform').setup({
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        go = { 'goimports', 'gofumpt', lsp_format = 'never' },
        lua = { 'stylua' },
      },
      format_on_save = function(bufnr)
        if not util.autoformat_enabled(bufnr) then return end
        return { timeout_ms = 500 }
      end,
    })

    vim.keymap.set(
      'n',
      '<leader>xf',
      function() util.toggle_autoformat(true) end,
      { desc = 'Toggle buffer autoformat' }
    )
    vim.keymap.set('n', '<leader>xF', function() util.toggle_autoformat() end, { desc = 'Toggle global autoformat' })
  end,
}
