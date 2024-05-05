return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-live-grep-args.nvim', version = '^1.0.0' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      -- files
      { '<leader>ff', '<cmd>Telescope find_files<cr>' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>' },
      { '<leader>fe', '<cmd>Telescope file_browser<cr>' },
      -- search
      { '<leader>sf', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>" },
      {
        '<leader>sF',
        ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<cr>",
      },
      { '<leader>sg', '<cmd>Telescope live_grep<cr>' },
      { '<leader>sG', '<cmd>Telescope grep_string<cr>' },
    },
    config = function()
      local telescope, config, actions = require('telescope'), require('telescope.config'), require('telescope.actions')
      local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, '--hidden')
      table.insert(vimgrep_arguments, '--trim') -- trim the indentation at the beginning of presented line

      telescope.setup({
        pickers = {
          find_files = {
            hidden = true,
          },
          oldfiles = {
            cwd_only = true,
          },
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
          },
          live_grep = {
            only_sort_text = true, -- grep for content and not file name/path
            mappings = {
              i = { ['<c-f>'] = actions.to_fuzzy_refine },
            },
          },
        },
        defaults = {
          file_ignore_patterns = {
            '%.7z',
            '%.avi',
            '%.JPEG',
            '%.JPG',
            '%.V',
            '%.RAF',
            '%.burp',
            '%.bz2',
            '%.cache',
            '%.class',
            '%.dll',
            '%.docx',
            '%.dylib',
            '%.epub',
            '%.exe',
            '%.flac',
            '%.ico',
            '%.ipynb',
            '%.jar',
            '%.jpeg',
            '%.jpg',
            '%.lock',
            '%.mkv',
            '%.mov',
            '%.mp4',
            '%.otf',
            '%.pdb',
            '%.pdf',
            '%.png',
            '%.rar',
            '%.sqlite3',
            '%.svg',
            '%.tar',
            '%.tar.gz',
            '%.ttf',
            '%.webp',
            '%.zip',
            '.git/',
            '.gradle/',
            '.idea/',
            '.settings/',
            '.vale/',
            '.vscode/',
            '__pycache__/*',
            'build/',
            'env/',
            'gradle/',
            'node_modules/',
            'smalljre_*/*',
            'target/',
            'vendor/*',
          },
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            i = {
              -- Close on first esc instead of going to normal mode
              -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
              ['<esc>'] = actions.close,
              ['<PageUp>'] = actions.results_scrolling_up,
              ['<PageDown>'] = actions.results_scrolling_down,
              ['<c-u>'] = actions.preview_scrolling_up,
              ['<c-d>'] = actions.preview_scrolling_down,
              ['<c-h'] = actions.results_scrolling_left,
              ['<c-l'] = actions.results_scrolling_right,
              ['<c-k>'] = actions.move_selection_previous,
              ['<c-j>'] = actions.move_selection_next,
              ['<cr>'] = actions.select_default,
              ['<c-v>'] = actions.select_vertical,
              ['<c-s>'] = actions.select_horizontal,
              ['<c-t>'] = actions.select_tab,
              ['<c-x>'] = actions.delete_buffer,
            },
          },
          entry_prefix = '  ',
          initial_mode = 'insert',
          scroll_strategy = 'cycle',
          selection_strategy = 'reset',
          sorting_strategy = 'descending',
          layout_strategy = 'horizontal',
          color_devicons = true,
          use_less = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
          get_selection_window = function()
            local window_id = require('window-picker').pick_window({
              filter_rules = {
                include_current_win = true,
              },
            })
            -- find a way to cancel without throwing error
            return window_id or 0
          end,
          path_display = {
            'filename_first',
          },
        },
        extensions = {
          file_browser = {
            hidden = { file_browser = true, folder_browser = true },
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('live_grep_args')
      telescope.load_extension('file_browser')
    end,
  },
}
