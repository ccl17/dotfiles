-- general autocommands

local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('TextYankHighlight'),
  callback = function() vim.highlight.on_yank() end,
})

-- CursorLine
local CursorLine = augroup('CursorLine')

vim.api.nvim_create_autocmd('BufEnter', {
  group = CursorLine,
  pattern = { '*' },
  callback = function(args)
    vim.wo.cursorline = vim.bo[args.buf].buftype ~= 'terminal'
      and not vim.wo.previewwindow
      and vim.wo.winhighlight == ''
      and vim.bo[args.buf].filetype ~= ''
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = CursorLine,
  pattern = { '*' },
  callback = function() vim.wo.cursorline = false end,
})

-- Cursor location
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('CursorLocation'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('ResizeSplitWindows'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('CloseWithQ'),
  pattern = {
    'checkhealth',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})
