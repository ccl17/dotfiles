return {
  'lukas-reineke/indent-blankline.nvim',
  version = 'v3.5.4',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    indent = {
      char = { '|', '¦', '┆', '┊' },
    },
    scope = { enabled = false },
  },
}
