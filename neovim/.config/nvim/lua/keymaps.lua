-- buffers
vim.keymap.set('n', '<tab>', ':bn<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<s-tab>', ':bp<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>%bd!<cr>', { desc = 'Close all buffers' })

-- remove highlighting
vim.keymap.set('n', '<esc>', ':nohlsearch<cr>', { desc = 'Clear hlsearch', silent = true })

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
