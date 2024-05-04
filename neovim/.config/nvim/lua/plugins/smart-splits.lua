local f = require('util/functions')
local noremap = f.noremap

return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  config = function()
    -- noremap("n", "<a-h>", require("smart-splits").resize_left, "resize left")
    -- noremap("n", "<a-j>", require("smart-splits").resize_down, "resize down")
    -- noremap("n", "<a-k>", require("smart-splits").resize_up, "resize up")
    -- noremap("n", "<a-l>", require("smart-splits").resize_right, "resize right")

    -- resize windows
    noremap('n', '<leader>wR', require('smart-splits').start_resize_mode, 'window resize mode')
    -- moving between splits
    noremap('n', '<c-h>', require('smart-splits').move_cursor_left, 'move cursor left')
    noremap('n', '<c-j>', require('smart-splits').move_cursor_down, 'move cursor down')
    noremap('n', '<c-k>', require('smart-splits').move_cursor_up, 'move cursor up')
    noremap('n', '<c-l>', require('smart-splits').move_cursor_right, 'move cursor right')
    -- swapping buffers between windows
    noremap('n', '<leader><leader>h', require('smart-splits').swap_buf_left, 'swap buffer left')
    noremap('n', '<leader><leader>j', require('smart-splits').swap_buf_down, 'swap buffer down')
    noremap('n', '<leader><leader>k', require('smart-splits').swap_buf_up, 'swap buffer up')
    noremap('n', '<leader><leader>l', require('smart-splits').swap_buf_right, 'swap buffer right')
  end,
}
