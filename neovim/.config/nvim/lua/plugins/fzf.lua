return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  cmd = 'FzfLua',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    { 'onsails/lspkind.nvim' },
  },
  keys = {
    -- find
    { '<leader>fg', function() require('fzf-lua').live_grep_glob() end, desc = 'grep' },
    { '<leader>fg', function() require('fzf-lua').grep_visual() end, mode = 'x', desc = 'grep visual selection' },
    { '<leader>ff', function() require('fzf-lua').files() end, desc = 'find files' },
    { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'buffers' },
    { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'live grep' },
    -- git
    { '<leader>gc', function() require('fzf-lua').git_commits() end, desc = 'git commits' },
    { '<leader>gs', function() require('fzf-lua').git_status() end, desc = 'git status' },
    -- search
    { '<leader>sb', function() require('fzf-lua').lgrep_curbuf() end, desc = 'grep current buffer' },
    { '<leader>ss', function() require('fzf-lua').lsp_document_symbols() end, desc = 'lsp document symbols' },
    { '<leader>sS', function() require('fzf-lua').lsp_live_workspace_symbols() end, desc = 'lsp workspace symbols' },
    { '<leader>sc', function() require('fzf-lua').lsp_code_actions() end, desc = 'lsp code actions' },
    { '<leader>sd', function() require('fzf-lua').diagnostics_document() end, desc = 'lsp document diagnostics' },
    { '<leader>sD', function() require('fzf-lua').diagnostics_workspace() end, desc = 'lsp workspace diagnostics' },
    { '<leader>sk', function() require('fzf-lua').keymaps() end, desc = 'Keymaps' },
    { '<leader>sh', function() require('fzf-lua').highlights() end, desc = 'search highlights' },
  },
  config = function()
    local fzf = require('fzf-lua')
    local icons = require('icons')
    local lspkind = require('lspkind')

    local prompt = ' ' .. icons.misc.search .. ' '

    fzf.setup({
      winopts = {
        preview = {
          wrap = 'wrap',
          scrollbar = false,
        },
      },
      keymap = {
        builtin = {
          ['<c-\\>'] = 'toggle-help',
          ['<c-f>'] = 'preview-page-down',
          ['<c-b>'] = 'preview-page-up',
        },
        fzf = {
          ['esc'] = 'abort',
          ['ctrl-q'] = 'select-all+accept',
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
          ['ctrl-u'] = 'half-page-up',
          ['ctrl-d'] = 'half-page-down',
        },
      },
      fzf_opts = {
        ['--layout'] = 'default',
      },
      fzf_colors = {
        ['gutter'] = '-1',
      },
      files = {
        prompt = prompt,
        cwd_prompt = false,
      },
      grep = {
        prompt = prompt,
        rg_opts = '--column --line-number --no-heading --color=never --smart-case --max-columns=4096 -e',
      },
      oldfiles = {
        prompt = prompt,
        cwd_only = true,
      },
      buffers = {
        prompt = prompt,
      },
      lsp = {
        symbols = {
          symbol_icons = lspkind.symbol_map,
        },
        finder = {
          prompt = prompt,
        },
      },
    })

    fzf.register_ui_select()
  end,
}
