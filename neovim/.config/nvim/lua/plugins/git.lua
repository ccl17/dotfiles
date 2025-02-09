local icons = require('icons')

return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = icons.misc.dashed_bar },
          change = { text = icons.misc.dashed_bar },
          delete = { text = icons.misc.dashed_bar },
          topdelete = { text = icons.misc.dashed_bar },
          changedelete = { text = icons.misc.dashed_bar },
          untracked = { text = icons.misc.dashed_bar },
        },
        signs_staged = {
          add = { text = icons.misc.vertical_bar },
          change = { text = icons.misc.vertical_bar },
          delete = { text = icons.misc.vertical_bar },
          topdelete = { text = icons.misc.vertical_bar },
          changedelete = { text = icons.misc.vertical_bar },
          untracked = { text = icons.misc.vertical_bar },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 500,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        status_formatter = nil,
        update_debounce = 200,
        max_file_length = 40000,
        preview_config = {
          border = 'rounded',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')
          vim.keymap.set('n', ']g', gitsigns.next_hunk, { desc = 'Next Git hunk', buffer = bufnr })
          vim.keymap.set('n', '[g', gitsigns.prev_hunk, { desc = 'Previous Git hunk', buffer = bufnr })
          vim.keymap.set('n', '<leader>gh', gitsigns.preview_hunk, { desc = 'Preview Git hunk', buffer = bufnr })
          vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Git hunk', buffer = bufnr })
          vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Git hunk', buffer = bufnr })
        end,
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'diffview open', mode = 'n' },
    },
    opts = {
      keymaps = {
        view = { q = '<cmd>DiffviewClose<cr>' },
        file_panel = { q = '<cmd>DiffviewClose<cr>' },
        file_history_panel = { q = '<cmd>DiffviewClose<cr>' },
      },
    },
  },
}
