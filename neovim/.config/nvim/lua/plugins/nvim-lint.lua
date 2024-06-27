local f = require('util.functions')
local api = vim.api

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPre',
  config = function()
    local rubocop = require('lint').linters.rubocop
    require('lint').linters.rubocop = vim.tbl_extend('force', rubocop, {
      cmd = 'bundle',
      stdin = true,
      args = {
        'exec',
        'rubocop',
        '--format',
        'json',
        '--force-exclusion',
        '--stdin',
        function() return api.nvim_buf_get_name(0) end,
      },
    })
    require('lint').linters_by_ft = {
      go = { 'golangcilint' },
      javascript = { 'eslintd' },
      ruby = { 'rubocop' },
      vue = { 'eslint_d' },
    }
    f.augroup('Linter', {
      event = { 'BufEnter', 'TextChanged', 'TextChangedI' },
      command = function() require('lint').try_lint() end,
    })
  end,
}
