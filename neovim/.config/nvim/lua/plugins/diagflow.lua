local icons = require('util.icons')

return {
  'dgagn/diagflow.nvim',
  event = 'LspAttach',
  opts = {
    scope = 'line',
    show_sign = true,
    icons = {
      Hint = icons.diagnostics.hint,
      Info = icons.diagnostics.info,
      Warn = icons.diagnostics.warning,
      Error = icons.diagnostics.error,
    },
  },
  config = function(_, opts)
    for sev, text in pairs(opts.icons) do
      local level = 'DiagnosticSign' .. sev
      vim.fn.sign_define(level, { text = text, texthl = level })
    end

    require('diagflow').setup(opts)
  end,
}
