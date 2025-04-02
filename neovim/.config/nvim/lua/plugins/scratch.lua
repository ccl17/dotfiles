return {
  'LintaoAmons/scratch.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'ibhagwan/fzf-lua' },
  },
  opts = {
    window_cmd = 'rightbelow vsplit',
    use_telescope = false,
    file_picker = 'fzflua',
    filetypes = { 'json', 'markdown' },
    filetype_details = {
      json = {},
    },
  },
}
