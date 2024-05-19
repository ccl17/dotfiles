local fn = vim.fn
local f = require('util/functions')
local noremap, toggle_autoformat = f.noremap, f.toggle_autoformat

-- buffers
noremap('n', '<tab>', ':bn<cr>', 'next buffer')
noremap('n', '<s-tab>', ':bp<cr>', 'prev buffer')
noremap('n', '<leader>bD', '<cmd>%bd|e#|bd#<cr>', 'close all but the current buffer')
-- noremap('n', '<leader>rp', "<cmd>:let @+ = expand('%')<cr>", 'copy buffer file path')
noremap('n', '<leader>rp', function() fn.setreg('+', fn.expand('%')) end, 'copy buffer file path')

-- json pretty print
noremap('n', '<leader>j', ':%!jq .<cr>', 'jq format')

-- remove highlighting
noremap('n', '<esc><esc>', ':nohlsearch<cr>', 'remove highlighting', { silent = true })

-- the worst place in the universe
noremap('n', 'Q', '<nop>', '')

-- move blocks
noremap('v', 'J', ":m '>+1<CR>gv=gv", 'move block up')
noremap('v', 'K', ":m '<-2<CR>gv=gv", 'move block down')

-- focus scrolling
noremap('n', '<C-d>', '<C-d>zz', 'scroll down')
noremap('n', '<C-u>', '<C-u>zz', 'scroll up')

-- focus highlight searches
noremap('n', 'n', 'nzzzv', 'next match')
noremap('n', 'N', 'Nzzzv', 'prev match')

-- Paste without yanking
noremap('v', 'p', '"_dP')

-- Indent visual blocks
noremap('v', '<', '<gv')
noremap('v', '>', '>gv')

-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
-- see: https://github.com/yuki-yang/zero.nvim/blob/main/lua/zero.lua
noremap('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", '', { expr = true })

-- window
noremap('n', '<leader>wh', '<cmd>split<cr>', 'Horizontal Split')
noremap('n', '<leader>wv', '<cmd>vsplit<cr>', 'Vertical split')
noremap('n', '<leader>w=', '<cmd>wincmd =<cr>', 'Equalize size')
noremap('n', '<c-q>', '<cmd>:close<cr>', 'close current window')

-- save file
noremap({ 'n', 'i', 'v' }, '<c-s>', '<cmd>w<cr><esc>', 'Save File')

-- toggles
noremap('n', '<leader>uf', function() toggle_autoformat() end, 'Toggle Auto Format (Global)')
noremap('n', '<leader>uF', function() toggle_autoformat(true) end, 'Toggle Auto Format (Buffer)')

-- restore session
noremap('n', '<leader>rr', function() require('persistence').load() end, 'restore previous session')
