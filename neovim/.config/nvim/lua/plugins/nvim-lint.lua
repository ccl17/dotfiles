local util = require('util')

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPre',
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(
          opts.ensure_installed,
          { 'golangci-lint', 'hadolint', 'shellcheck', 'tflint', 'tfsec', 'yamllint' }
        )
      end,
    },
  },
  config = function()
    local lint = require('lint')
    lint.linters_by_ft = {
      dockerfile = { 'hadolint' },
      go = { 'golangcilint' },
      sh = { 'shellcheck' },
      terraform = { 'terraform_validate', 'tflint', 'tfsec' },
      tf = { 'terraform_validate', 'tflint', 'tfsec' },
      yaml = { 'yamllint' },
      zsh = { 'shellcheck' },
    }
    local try_lint = util.debounce(100, function() lint.try_lint() end)
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
      group = vim.api.nvim_create_augroup('sc/lint', { clear = true }),
      callback = try_lint,
    })
  end,
}
