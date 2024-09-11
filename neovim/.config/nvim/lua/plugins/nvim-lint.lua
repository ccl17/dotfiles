local debounce = function(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

local try_lint = function() require('lint').try_lint() end

return {
  'mfussenegger/nvim-lint',
  event = 'BufReadPre',
  config = function()
    require('lint').linters_by_ft = {
      go = { 'golangcilint' },
      javascript = { 'eslint_d' },
      vue = { 'eslint_d' },
      dockerfile = { 'hadolint' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged', 'TextChangedI' }, {
      group = vim.api.nvim_create_augroup('NvimLint', { clear = true }),
      callback = debounce(100, try_lint),
    })
  end,
}
