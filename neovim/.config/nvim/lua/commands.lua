local util = require('util')

-- yank relative path
vim.api.nvim_create_user_command('Cppath', function()
  local path = vim.fn.expand('%:~:.')
  vim.fn.setreg('+', path)
  vim.notify('"' .. path .. '" copied to the clipboard')
end, { nargs = 0 })

-- toggle autoformat
vim.api.nvim_create_user_command(
  'ToggleFormat',
  function(opts) util.toggle_autoformat(opts.bang) end,
  { desc = 'Toggle autoformat', bang = true, nargs = 0 }
)

-- toggle inlay hint
vim.api.nvim_create_user_command(
  'ToggleInlayHints',
  function() util.toggle_inlayhint() end,
  { desc = 'Toggle inlay hints', nargs = 0 }
)
