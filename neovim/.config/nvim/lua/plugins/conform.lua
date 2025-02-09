local util = require('util')

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.autoformat = true
  end,
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        -- fix imports, then format using lsp (organize import groups)
        go = { 'goimports', lsp_format = 'last' },
        javascript = { 'prettier' },
        json = { 'jq' },
        lua = { 'stylua' },
      },
      format_on_save = function(bufnr)
        if not util.autoformat_enabled(bufnr) then return end
        return { timeout_ms = 3000 }
      end,
    })
  end,
}
