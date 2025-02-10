return {
  'dgagn/diagflow.nvim',
  event = 'LspAttach',
  config = function()
    local diagnostic_icons = require('icons').diagnostics
    for sev, icon in pairs(diagnostic_icons) do
      local hl = 'DiagnosticSign' .. sev:sub(1, 1) .. sev:sub(2):lower()
      vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end
    require('diagflow').setup({ show_sign = true })
  end,
}
