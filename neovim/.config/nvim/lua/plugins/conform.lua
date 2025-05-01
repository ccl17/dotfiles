local util = require('util')

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.g.autoformat = true
  end,
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { 'goimports', 'jq', 'prettier', 'stylua', 'yamlfmt' })
      end,
    },
  },
  config = function()
    require('conform').setup({
      formatters = {
        jq = {
          args = { '--indent', '4' },
        },
      },
      formatters_by_ft = {
        go = { 'goimports', lsp_format = 'first' },
        javascript = { 'prettier' },
        json = { 'jq' },
        lua = { 'stylua' },
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        yaml = { 'yamlfmt' },
      },
      format_on_save = function(bufnr)
        if not util.autoformat_enabled(bufnr) then return end
        return { timeout_ms = 3000 }
      end,
    })
  end,
}
