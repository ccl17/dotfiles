local util = require('util')

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPre',
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      dockerfile = { 'hadolint' },
      go = { 'golangcilint' },
      sh = { 'shellcheck' },
      yaml = { 'yamllint' },
      zsh = { 'shellcheck', 'zsh' },
    }
    -- go
    local golangcilint = require('lint').linters.golangcilint
    golangcilint.args = { '--out-format=json' }
    local try_lint = util.debounce(100, function() lint.try_lint() end)

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
      group = vim.api.nvim_create_augroup('sc/lint', { clear = true }),
      callback = try_lint,
    })
  end,
}
