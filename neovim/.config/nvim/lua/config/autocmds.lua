local f = require('util/functions')
local augroup = f.augroup

augroup('TextYankHighlight', {
  event = { 'TextYankPost' },
  command = function() vim.highlight.on_yank() end,
  desc = 'Highlight on Yank',
})

augroup('Cursorline', {
  event = { 'BufEnter' },
  pattern = { '*' },
  command = function(args)
    vim.wo.cursorline = vim.bo[args.buf].buftype ~= 'terminal'
      and not vim.wo.previewwindow
      and vim.wo.winhighlight == ''
      and vim.bo[args.buf].filetype ~= ''
  end,
}, {
  event = { 'BufLeave' },
  pattern = { '*' },
  command = function() vim.wo.cursorline = false end,
})

augroup('CursorLocation', {
  event = { 'BufReadPost' },
  command = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- resize splits if window got resized
augroup('ResizeSplitWindows', {
  event = { 'VimResized' },
  command = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})
