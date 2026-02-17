-- Movement by visual lines when wrapped using j/k
vim.keymap.set('n', 'j', [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

-- Paste without yanking
vim.keymap.set('x', 'p', 'P')

-- Move blocks
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visual block up' })
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visual block down' })

-- Keeps cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

-- Indent while remaining in visual mode
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Navigate between windows.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window', remap = true })

-- Jump to end of line in insert mode
vim.keymap.set({ 'i', 'c' }, '<C-l>', '<C-o>A', { desc = 'Jump to the end of the line' })

-- window
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', { desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>w=', '<cmd>wincmd =<cr>', { desc = 'Equalize size' })
vim.keymap.set('n', '<c-q>', '<cmd>:close<cr>', { desc = 'Close current window' })

-- Save file
vim.keymap.set({ 'n', 'i', 'v' }, '<c-s>', '<esc><cmd>w<cr><esc>', { desc = 'Save File' })

-- Tab jump to correct indentation level from beginning of line
vim.keymap.set('i', '<tab>', function()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	-- this assume that "!^F" is in the "indentkeys" option
	if vim.o.indentexpr ~= '' and col == 0 and line:match('^%s*$') then
		local ctrl_f = vim.api.nvim_replace_termcodes('<C-f>', true, false, true)
		vim.api.nvim_feedkeys(ctrl_f, 'n', false)
	else
		local tab = vim.api.nvim_replace_termcodes('<tab>', true, false, true)
		vim.api.nvim_feedkeys(tab, 'n', false)
	end
end)

vim.keymap.set('n', '<leader>yp', function()
	local path = vim.fn.expand('%')
	vim.fn.setreg('+', path)
	vim.notify('Copied: ' .. path)
end, { desc = 'Copy relative path' })

-- Disable vim command history
vim.keymap.set('n', 'q:', '<nop>', { desc = 'Disable cmd history', noremap = true })

-- Jump list navigation
vim.keymap.set('n', '[[', '<C-o>', { desc = 'Jump to previous location' })
vim.keymap.set('n', ']]', '<C-i>', { desc = 'Jump to next location' })
