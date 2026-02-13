return {
  "ibhagwan/fzf-lua",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  keys = {
    {
      '<leader>fb',
      function()
        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(mode, 'n') then
          require('fzf-lua').lgrep_curbuf()
        else
          require('fzf-lua').blines()
        end
      end,
      desc = 'Search current buffer',
      mode = { 'n', 'x' },
    },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
    { '<leader>fg', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep', mode = 'x' },
-- -- files
--     { '<leader>fg', function() require('fzf-lua').live_grep_glob() end, desc = 'grep' },
--     { '<leader>fg', function() require('fzf-lua').grep_visual() end, mode = 'x', desc = 'grep visual selection' },
--     { '<leader>ff', function() require('fzf-lua').files() end, desc = 'find files' },
--     { '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'buffers' },
--     { '<leader>fo', function() require('fzf-lua').oldfiles() end, desc = 'live grep' },
--     -- git
--     { '<leader>gc', function() require('fzf-lua').git_commits() end, desc = 'git commits' },
--     { '<leader>gs', function() require('fzf-lua').git_status() end, desc = 'git status' },
--     -- search
--     { '<leader>sb', function() require('fzf-lua').lgrep_curbuf() end, desc = 'grep current buffer' },
--     { '<leader>ss', function() require('fzf-lua').lsp_document_symbols() end, desc = 'lsp document symbols' },
--     { '<leader>sS', function() require('fzf-lua').lsp_live_workspace_symbols() end, desc = 'lsp workspace symbols' },
--     { '<leader>sd', function() require('fzf-lua').diagnostics_document() end, desc = 'lsp document diagnostics' },
--     { '<leader>sD', function() require('fzf-lua').diagnostics_workspace() end, desc = 'lsp workspace diagnostics' },
--     { '<leader>sk', function() require('fzf-lua').keymaps() end, desc = 'Keymaps' },
--     { '<leader>sh', function() require('fzf-lua').highlights() end, desc = 'search highlights' },
--     { '<leader>sB', function() require('fzf-lua').dap_breakpoints() end, desc = 'search breakpoints' },
  },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {
winopts = {
preview = {
wrap = 'wrap',
},
},
grep = {
  hidden = true,
},
  }
  ---@diagnostic enable: missing-fields
}
