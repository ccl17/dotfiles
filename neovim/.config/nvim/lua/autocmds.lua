vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = vim.api.nvim_create_augroup('sc/yank_highlight', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- cursorline
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor location when opening buffer',
  group = vim.api.nvim_create_augroup('sc/cursor_location', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

local cursorline = vim.api.nvim_create_augroup('sc/cursorline', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = cursorline,
  pattern = { '*' },
  callback = function(args)
    vim.wo.cursorline = vim.bo[args.buf].buftype ~= 'terminal'
      and not vim.wo.previewwindow
      and vim.wo.winhighlight == ''
      and vim.bo[args.buf].filetype ~= ''
  end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = cursorline,
  pattern = { '*' },
  callback = function() vim.wo.cursorline = false end,
})

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Auto resize windows',
  group = vim.api.nvim_create_augroup('sc/window_resize', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- close some filetypes with q
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('sc/quit_with_q', { clear = true }),
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

-- sessions
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('sc/load_session', { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then require('persistence').load() end
  end,
  nested = true,
})

-- yank relative path
vim.api.nvim_create_user_command('Cppath', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  vim.notify('"' .. path .. '" copied to the clipboard')
end, {})

vim.keymap.set('n', '<leader>fy', '<cmd>Cppath<cr>', { desc = 'Yank current file path' })
