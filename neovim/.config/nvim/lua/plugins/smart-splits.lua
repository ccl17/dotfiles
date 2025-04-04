return {
  'mrjones2014/smart-splits.nvim',
  config = function()
    require('smart-splits').setup({
      ignored_buftypes = {
        'nofile',
        'quickfix',
        'prompt',
      },
      default_amount = 5,
      at_edge = 'stop',
      float_win_behavior = 'previous',
      move_cursor_same_row = false,
      cursor_follows_swapped_bufs = false,
      resize_mode = {
        quit_key = '<ESC>',
        resize_keys = { 'h', 'j', 'k', 'l' },
        silent = false,
        hooks = {
          on_enter = nil,
          on_leave = nil,
        },
      },
      ignored_events = {
        'BufEnter',
        'WinEnter',
      },
      disable_multiplexer_nav_when_zoomed = true,
      log_level = 'info',
    })
    vim.keymap.set('n', '<m-h>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<m-j>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<m-k>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<m-l>', require('smart-splits').resize_right)
    -- moving between splits
    vim.keymap.set('n', '<c-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<c-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<c-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<c-l>', require('smart-splits').move_cursor_right)
    -- swapping buffers between windows
    vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
    vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
    vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
    vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
  end,
}
