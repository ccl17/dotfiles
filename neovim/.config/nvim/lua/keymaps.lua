-- buffers
vim.keymap.set('n', '<leader>bd', '<cmd>%bd!<cr>', { desc = 'Close all buffers' })
vim.keymap.set('n', '<leader>fy', '<cmd>Cppath<cr>', { desc = 'Yank current buffer relative path' })

-- remove highlighting
vim.keymap.set({ 'i', 's', 'n' }, '<esc>', function()
  vim.cmd('noh')
  vim.snippet.stop()
  return '<esc>'
end, { desc = 'Clear hlsearch', silent = true, expr = true })

-- move blocks
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visual block up' })
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visual block down' })

-- focus cursor
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev result' })

-- paste without yanking
vim.keymap.set('x', 'p', 'P')

-- indent visual block
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

-- window
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', { desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>w=', '<cmd>wincmd =<cr>', { desc = 'Equalize size' })
vim.keymap.set('n', '<c-q>', '<cmd>:close<cr>', { desc = 'Close current window' })

-- quickfix
vim.keymap.set('n', '[q', '<cmd>cprev<cr>zvzz', { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>zvzz', { desc = 'Next quickfix item' })

-- save file
vim.keymap.set({ 'n', 'i', 'v' }, '<c-s>', '<esc><cmd>w<cr><esc>', { desc = 'Save File' })

-- plugin manager
vim.keymap.set('n', '<leader>pm', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- autoformat
vim.keymap.set('n', '<leader>xf', '<cmd>ToggleFormat<cr>', { desc = 'Toggle buffer autoformat' })
vim.keymap.set('n', '<leader>xF', '<cmd>ToggleFormat!<cr>', { desc = 'Toggle global autoformat' })

-- inlay hints
vim.keymap.set('n', '<leader>xi', '<cmd>ToggleInlayHints<cr>', { desc = 'Toggle inlay hints' })

-- disable vim command history
vim.keymap.set('n', 'q:', '<nop>', { desc = 'Disable cmd history', noremap = true })

-- neovim
-- vim.keymap.set('n', '<space><space>x', '<cmd>source %<cr>')
-- vim.keymap.set('n', '<space>x', ':.lua<cr>')
-- vim.keymap.set('v', '<space>x', ':lua<cr>')
