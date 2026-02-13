vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('sc/last_location', { clear = true }),
    desc = 'Go to the last location when opening a buffer',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd 'normal! g`"zz'
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('sc/yank_highlight', { clear = true }),
    desc = 'Highlight on yank',
    callback = function()
        vim.hl.on_yank({ higroup = 'Visual' })
    end,
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
