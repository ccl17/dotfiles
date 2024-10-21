local M = {}

M.indent = {
  indent1 = '|',
  indent2 = '¦',
  indent3 = '┆',
  indent4 = '┊',
}

M.autoformat = {
  enabled = '󱪚',
  disabled = '󱪘',
}

M.diagnostics = {
  HINT = '󰋼',
  INFO = '󰌶',
  WARN = '',
  ERROR = '',
}

M.misc = {
  ellipsis = '…',
  search = '🔍',
  vertical_bar = '│',
  lsp_icon = '󰆧',
}

M.dap = {
  breakpoint = '',
  log = '◆',
  bug = '',
}

return M
