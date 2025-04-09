return {
  'LintaoAmons/scratch.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'ibhagwan/fzf-lua' },
  },
  opts = function()
    -- does not work for existing scratch files
    vim.api.nvim_create_user_command('RmScratchFile', function()
      if not vim.b.scratch then
        vim.notify('RmScratchFile can only be used on Scratch buffers!', vim.log.levels.ERROR)
        return
      end
      local file_path = vim.fn.expand('%')
      os.remove(file_path)
      vim.api.nvim_buf_delete(0, { force = true })
      vim.notify('"' .. file_path .. '" deleted!', vim.log.levels.INFO)
    end, { desc = 'Delete current Scratch file', nargs = 0 })

    return {
      window_cmd = 'rightbelow vsplit',
      use_telescope = false,
      file_picker = 'fzflua',
      filetypes = { 'json', 'markdown' },
      filetype_details = {
        json = {},
      },
      localKeys = {
        {
          filenameContains = { 'json' },
          LocalKeys = {
            {
              cmd = '<cmd>RmScratchFile<cr>',
              key = '<c-x>',
              modes = { 'n', 'i', 'v' },
            },
          },
        },
      },
      hooks = {
        {
          callback = function() vim.b.scratch = 1 end,
        },
      },
    }
  end,
  config = function(_, opts)
    require('scratch').setup(opts)
    vim.keymap.set('n', '<leader>Sn', '<cmd>Scratch<cr>', { desc = 'New Scratch buffer' })
    vim.keymap.set('n', '<leader>SN', '<cmd>ScratchWithName<cr>', { desc = 'New Scratch buffer with name' })
    vim.keymap.set('n', '<leader>Se', '<cmd>ScratchOpen<cr>', { desc = 'Open existing Scratch buffer' })
  end,
}
