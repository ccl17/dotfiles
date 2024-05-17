local f = require('util/functions')
local icons = require('util/icons')

return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
      require('gitsigns').setup({
        signs = {
          add = {
            hl = 'GitSignsAdd',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn',
          },
          change = {
            hl = 'GitSignsChange',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
          },
          delete = {
            hl = 'GitSignsDelete',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn',
          },
          topdelete = {
            hl = 'GitSignsDelete',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn',
          },
          changedelete = {
            hl = 'GitSignsChange',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
          },
          untracked = {
            hl = 'GitSignsChange',
            text = icons.separators.right_thin_block,
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
          },
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
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
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
        yadm = { enable = false },

        on_attach = function(bufnr)
          f.noremap('n', '<leader>H', require('gitsigns').preview_hunk, 'Preview git hunk', { buffer = bufnr })
          f.noremap('n', ']h', require('gitsigns').next_hunk, 'Next git hunk', { buffer = bufnr })
          f.noremap('n', '[h', require('gitsigns').prev_hunk, 'Previous git hunk', { buffer = bufnr })
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
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
  },
}
