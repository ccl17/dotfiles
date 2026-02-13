return {
  'nvim-mini/mini.files',
  version = '*',
  keys = {
    { '<leader>e', function()
      require('mini.files').open()
    end, desc = 'File explorer' },
  },
  opts = {
    content = {
      filter = function(entry)
        return entry.name ~= '.DS_Store'
      end
    },
  },
  config = function (_, opts)
    require('mini.files').setup(opts)
     -- test: need to notify lsp file renamed?
     -- keymaps open split right and bottom
  end
}
