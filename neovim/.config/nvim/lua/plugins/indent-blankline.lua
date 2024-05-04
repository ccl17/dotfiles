return {
  'lukas-reineke/indent-blankline.nvim',
  version = '2.20.8',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    char_list = { '|', '¦', '┆', '┊' },
    scope = { enabled = false },
  },
}
