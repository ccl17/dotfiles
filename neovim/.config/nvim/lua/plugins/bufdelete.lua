return {
  'famiu/bufdelete.nvim',
  keys = {
    {
      '<c-w>',
      function() require('bufdelete').bufdelete() end,
      desc = 'close current buffer',
      nowait = true,
      remap = false,
    },
  },
}
