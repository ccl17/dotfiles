local fn, loop, opt = vim.fn, vim.loop, vim.opt
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not loop.fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
opt.runtimepath:prepend(lazypath)

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = { 'netrw', 'netrwPlugin' },
    },
  },
})

vim.keymap.set('n', '<leader>pm', '<Cmd>Lazy<CR>', { desc = 'manage' })
