local f = require('util.functions')
local autoformat_enabled = f.autoformat_enabled
local slow_formatters_filetypes = {}

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>F',
      function() require('conform').format({ async = true, lsp_fallback = true }) end,
      mode = 'n',
      desc = 'Format buffer',
    },
  },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        go = { 'goimports' },
        json = { 'prettier' },
        lua = { 'stylua' },
        ruby = { 'rubocop' },
        yaml = { 'yamlfmt' },
      },
      formatters = {
        rubocop = {
          inherit = false,
          command = 'bundle',
          args = {
            'exec',
            'rubocop',
            '-f',
            'quiet',
            '--auto-correct',
            '--fix-layout',
            '--stderr',
            '--stdin',
            '$FILENAME',
          },
          cwd = require('conform.util').root_file({ '.rubocop.yml' }),
          require_cwd = true,
        },
      },
      format_on_save = function(bufnr)
        if slow_formatters_filetypes[vim.bo[bufnr].filetype] then return end
        local function on_format(err)
          if err and err:match('timeout$') then slow_formatters_filetypes[vim.bo[bufnr].filetype] = true end
        end
        if autoformat_enabled(bufnr) then return { timeout_ms = 1000, lsp_fallback = true }, on_format end
      end,
      format_after_save = function(bufnr)
        if slow_formatters_filetypes[vim.bo[bufnr].filetype] then return { lsp_fallback = true } end
      end,
      init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    })
  end,
}
