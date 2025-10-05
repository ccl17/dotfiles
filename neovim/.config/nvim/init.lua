vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = false

vim.o.showmode = false

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.wo.foldtext = ''
vim.opt.wrap = false
vim.o.winborder = 'rounded'
vim.o.termguicolors = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

vim.o.splitright = true
vim.o.splitbelow = true

vim.opt.swapfile = false
vim.opt.undofile = true

vim.o.list = true
vim.opt.listchars = { trail = '·', nbsp = '␣', tab = '  ▸' }

vim.o.inccommand = 'split'
vim.opt.incsearch = false

vim.o.cursorline = true

vim.o.scrolloff = 10

-- raise dialog asking if you wish to save the current file(s)
-- :help 'confirm'
vim.o.confirm = true

-- keymaps
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
-- save file
vim.keymap.set({ 'n', 'i', 'v' }, '<c-s>', '<esc><cmd>w<cr><esc>', { desc = 'Save File' })
-- center cursor
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })
-- move blocks
vim.keymap.set('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visual block up' })
vim.keymap.set('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visual block down' })
-- paste without yanking
vim.keymap.set('x', 'p', 'P')
-- indent visual block
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
-- window
vim.keymap.set('n', '<leader>wh', '<cmd>split<cr>', { desc = 'Horizontal Split' })
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>w=', '<cmd>wincmd =<cr>', { desc = 'Equalize size' })
vim.keymap.set('n', '<c-q>', '<cmd>:close<cr>', { desc = 'Close current window' })
vim.keymap.set('n', '<c-h>', '<c-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<c-j>', '<c-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { noremap = true, silent = true })
vim.keymap.set({ 'i', 'c' }, '<c-l>', '<c-o>A', { desc = 'Go to the end of the line' })
-- disable vim command history
vim.keymap.set('n', 'q:', '<nop>', { desc = 'Disable cmd history', noremap = true })

-- autocmds
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last-location', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

local cursorline = vim.api.nvim_create_augroup('cursorline', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained', 'InsertLeave' }, {
  group = cursorline,
  pattern = { '*' },
  callback = function(args)
    vim.wo.cursorline = vim.bo[args.buf].buftype ~= 'terminal'
      and not vim.wo.previewwindow
      and vim.wo.winhighlight == ''
      and vim.bo[args.buf].filetype ~= ''
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost', 'InsertEnter' }, {
  group = cursorline,
  pattern = { '*' },
  callback = function() vim.wo.cursorline = false end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  change_detection = { notify = false },
  rocks = { enabled = false },
  spec = {

    -- colortheme
    {
      'sainnhe/gruvbox-material',
      lazy = false,
      priority = 1000,
      config = function()
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_background = 'soft'
        vim.cmd.colorscheme('gruvbox-material')
      end,
    },

    -- indentation
    {
      'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
      dependencies = {
        'tpope/vim-sleuth',
        {
          'echasnovski/mini.indentscope',
          version = '*',
          init = function()
            vim.api.nvim_create_autocmd('FileType', {
              pattern = { 'checkhealth', 'fzf', 'help', 'lazy', 'lspinfo', 'man', 'mason', 'notify', '' },
              callback = function() vim.b.miniindentscope_disable = true end,
            })
          end,
        },
      },
      opts = {
        indent = {
          char = { '|', '¦', '┆', '┊', '┊', '┊', '┊', '┊', '┊' },
          tab_char = { '|', '¦', '┆', '┊', '┊', '┊', '┊', '┊', '┊' },
        },
        scope = { show_start = false, show_end = false },
      },
      config = function(_, opts)
        require('ibl').setup(opts)
        require('mini.indentscope').setup({
          draw = { delay = 50 },
          options = { try_as_border = true },
          symbol = '▏',
        })
      end,
    },

    -- save window layout
    {
      'nvim-mini/mini.bufremove',
      opts = {},
      keys = {
        {
          '<leader>bd',
          function() require('mini.bufremove').delete(0, false) end,
          desc = 'Delete current buffer',
        },
      },
    },

    -- statusline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {
        options = {
          globalstatus = true,
          theme = 'gruvbox-material',
        },
      },
    },

    -- files management
    {
      'stevearc/oil.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      keys = {
        { '<leader>fe', function() require('oil').open() end, desc = 'open parent directory' },
        { '<leader>fE', function() require('oil').open(vim.fn.getcwd()) end, desc = 'open project root directory' },
      },
      opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
          ['?'] = 'actions.show_help',
          ['q'] = 'actions.close',
          ['<cr>'] = 'actions.select',
          ['<c-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'open vertical split' },
          ['<c-x>'] = { 'actions.select', opts = { horizontal = true }, desc = 'open horizontal split' },
          ['-'] = 'actions.parent',
        },
        use_default_keymaps = false,
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _) return name == '..' end,
        },
      },
    },

    -- fuzzy finder
    {
      'ibhagwan/fzf-lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      cmd = 'FzfLua',
      keys = {
        -- files
        { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'buffers' },
        { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'find files' },
        { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'grep' },
        { '<leader>fg', '<cmd>FzfLua grep_visual<cr>', desc = 'grep', mode = 'x' },
        -- search
        { '<leader>sd', function() require('fzf-lua').diagnostics_document() end, desc = 'lsp document diagnostics' },
        { '<leader>sD', function() require('fzf-lua').diagnostics_workspace() end, desc = 'lsp workspace diagnostics' },
        { '<leader>sk', function() require('fzf-lua').keymaps() end, desc = 'Keymaps' },
      },
      opts = {
        debug = true,
        files = {
          cwd_prompt = false,
          winopts = {
            preview = { hidden = true },
          },
        },
        grep = {
          RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
        },
        keymap = {
          builtin = {
            ['<c-p>'] = 'toggle-preview',
          },
        },
        winopts = {
          preview = {
            scrollbar = false,
          },
        },
      },
    },

    -- brackets
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      opts = {},
    },
    {
      'kylechui/nvim-surround',
      version = '^3.0.0',
      event = 'VeryLazy',
      opts = {
        keymaps = {
          insert = false,
          insert_line = false,
          visual_line = false,
        },
      },
    },

    -- treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      branch = 'master',
      build = ':TSUpdate',
      dependencies = {
        {
          'nvim-treesitter/nvim-treesitter-context',
          opts = {
            multiline_threshold = 1,
          },
        },
      },
      opts = {
        auto_install = true,
        highlight = { enable = true },
        incremental_selection = { enable = false },
        indent = { enable = true },
      },
      config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
    },

    -- flash
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      ---@type Flash.Config
      opts = {
        modes = {
          char = {
            jump_labels = true,
          },
          search = {
            enabled = false,
          },
        },
      },
      keys = {
        { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'flash' },
        { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'treesitter flash' },
        { 'r', mode = 'o', function() require('flash').remote() end, desc = 'remote flash' },
        {
          'R',
          mode = { 'o', 'x' },
          function() require('flash').treesitter_search() end,
          desc = 'treesitter search flash',
        },
      },
    },

    -- git
    {
      {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        config = function()
          require('gitsigns').setup({
            signs = {
              add = { text = '┊' },
              change = { text = '┊' },
              delete = { text = '┊' },
              topdelete = { text = '┊' },
              changedelete = { text = '┊' },
              untracked = { text = '┊' },
            },
            signs_staged = {
              add = { text = '▏' },
              change = { text = '▏' },
              delete = { text = '▏' },
              topdelete = { text = '▏' },
              changedelete = { text = '▏' },
              untracked = { text = '▏' },
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
      {
        'ruifm/gitlinker.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { mappings = '<leader>gc' },
        config = function()
          require('gitlinker').setup()
          vim.api.nvim_set_keymap(
            'n',
            '<leader>gY',
            '<cmd>lua require"gitlinker".get_repo_url()<cr>',
            { silent = true, desc = 'copy git repository URL' }
          )
          vim.api.nvim_set_keymap(
            'n',
            '<leader>gB',
            '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            { silent = true, desc = 'open git repository URL in browser' }
          )
        end,
      },
    },

    -- autocomplete
    {
      'saghen/blink.cmp',
      version = '1.*',
      dependencies = {
        'folke/lazydev.nvim',
        -- snippet engine
        {
          'L3MON4D3/LuaSnip',
          version = 'v2.*',
          build = 'make install_jsregexp',
          dependencies = {
            {
              'rafamadriz/friendly-snippets',
              config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
            },
          },
        },
      },
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        snippets = { preset = 'luasnip' },
        keymap = {
          ['<c-c>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<cr>'] = { 'accept', 'fallback' },
          ['<c-e>'] = { 'cancel', 'fallback' },
          ['<tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
          ['<s-tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
          ['<c-p>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<c-n>'] = { 'select_next', 'fallback_to_mappings' },
          ['<c-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<c-f>'] = { 'scroll_documentation_down', 'fallback' },
          -- ['<c-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        completion = {
          menu = {
            border = 'rounded',
            scrollbar = false,
          },
          documentation = {
            auto_show = true,
            window = {
              border = 'rounded',
            },
          },
          list = { selection = { preselect = true, auto_insert = true } },
          ghost_text = { enabled = true },
        },
        cmdline = { enabled = false },
      },
      config = function(_, opts)
        require('blink.cmp').setup(opts)

        vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })
      end,
    },

    -- formatting
    {
      'stevearc/conform.nvim',
      event = 'BufWritePre',
      dependencies = {},
      opts = {
        notify_on_error = false,
        formatters_by_ft = {
          go = { name = 'gopls', timeout_ms = 500, lsp_format = 'prefer' },
          json = { 'jq' },
          lua = { 'stylua' },
          ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
        format_on_save = function()
          if not vim.g.autoformat then return nil end

          if vim.g.skip_formatting then
            vim.g.skip_formatting = false
            return nil
          end

          return {}
        end,
      },
      init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        vim.g.autoformat = true

        vim.keymap.set('n', '<leader>xf', function()
          vim.g.autoformat = not vim.g.autoformat
          vim.notify(
            string.format('%s formatting...', vim.g.autoformat and 'Enabled' or 'Disabled'),
            vim.log.levels.INFO
          )
        end)

        vim.keymap.set({ 's', 'i', 'n', 'v' }, '<c-m-s>', function() -- ctrl + cmd + s
          vim.g.skip_formatting = true
          return '<esc>:w<cr>'
        end, { desc = 'Exit insert mode and save changes (without formatting)', expr = true })
      end,
    },

    -- linting
    {
      'mfussenegger/nvim-lint',
      event = 'BufReadPre',
      config = function()
        local lint = require('lint')
        lint.linters_by_ft = {
          dockerfile = { 'hadolint' },
          -- go = { 'golangcilint' },
          -- sh = { 'shellcheck' },
          -- terraform = { 'terraform_validate', 'tflint', 'tfsec' },
          -- tf = { 'terraform_validate', 'tflint', 'tfsec' },
          -- yaml = { 'yamllint' },
          -- zsh = { 'shellcheck' },
        }
        -- local golangcilint = lint.linters.golangcilint
        -- golangcilint.ignore_exitcode = true

        local debounce = function(ms, fn)
          local timer = vim.uv.new_timer()
          return function(...)
            local argv = { ... }
            timer:start(ms, 0, function()
              timer:stop()
              vim.schedule_wrap(fn)(unpack(argv))
            end)
          end
        end
        local try_lint = debounce(100, function() lint.try_lint() end)
        vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
          group = vim.api.nvim_create_augroup('lint-with-debounce', { clear = true }),
          callback = try_lint,
        })
      end,
    },

    -- Split/join blocks of code.
    {
      'Wansmer/treesj',
      dependencies = 'nvim-treesitter',
      keys = {
        { '<leader>cj', '<cmd>TSJToggle<cr>', desc = 'Join/split code block' },
      },
      opts = { use_default_keymaps = false },
    },

    -- lsp
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            normal_hl = 'FidgetWindow',
            winblend = 0,
          },
        },
      },
    },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    { 'b0o/SchemaStore.nvim', lazy = true },
    {
      'dgagn/diagflow.nvim',
      -- event = 'LspAttach', This is what I use personnally and it works great
      opts = {
        show_sign = true,
        placement = 'inline',
      },
    },
    {
      'folke/trouble.nvim',
      opts = {
        auto_preview = false,
        preview = {
          type = 'float',
        },
      }, -- for default options, refer to the configuration section for custom setup.
      cmd = 'Trouble',
      keys = {
        {
          '<leader>T',
          '<cmd>Trouble diagnostics toggle<cr>',
          desc = 'Diagnostics (Trouble)',
        },
        {
          '<leader>t',
          '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
          desc = 'Buffer Diagnostics (Trouble)',
        },
      },
    },
  },
  checker = { enabled = false },
})
