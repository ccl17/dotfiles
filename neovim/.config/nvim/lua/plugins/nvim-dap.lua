local icons = require('icons')

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  keys = {
    {
      '<leader>db',
      function() require('dap').toggle_breakpoint() end,
      desc = 'toggle breakpoint',
    },
    {
      '<leader>dB',
      function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
      desc = 'conditional breakpoint',
    },
    {
      '<leader>dc',
      function() require('dap').continue() end,
      desc = 'continue or start debugger',
    },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to Cursor' },
    {
      '<leader>de',
      function() require('dap').step_out() end,
      desc = 'debugger step out',
    },
    {
      '<leader>di',
      function() require('dap').step_into() end,
      desc = 'debugger step into',
    },
    {
      '<leader>do',
      function() require('dap').step_over() end,
      desc = 'debugger step over',
    },
    {
      '<leader>dx',
      function() require('dap').terminate() end,
      desc = 'terminate debugger',
    },
    {
      '<leader>duc',
      function() require('dapui').close() end,
      desc = 'close debugger ui',
    },
    {
      '<leader>dut',
      function() require('dapui').toggle() end,
      desc = 'toggle debugger ui',
    },
  },
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'leoluz/nvim-dap-go' },
  },
  config = function()
    local dap, ui = require('dap'), require('dapui')
    require('dap-go').setup()

    ui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = ui.open
    dap.listeners.before.event_terminated['dapui_config'] = ui.close
    dap.listeners.before.event_exited['dapui_config'] = ui.close

    local dap_signs = {
      { 'DapBreakpoint', text = icons.dap.breakpoint, texthl = 'DapBreakpoint', linehl = '', numhl = '' },
      {
        'DapBreakpointCondition',
        text = icons.dap.breakpoint,
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = '',
      },
      { 'DapLogPoint', text = icons.dap.log, texthl = 'DapLogPoint', linehl = '', numhl = '' },
      { 'DapStopped', text = icons.dap.point, texthl = 'DapStopped', linehl = '', numhl = '' },
    }

    for _, signs in pairs(dap_signs) do
      vim.fn.sign_define(
        signs[1],
        { text = signs.text or '', texthl = signs.texthl or '', linehl = signs.linehl or '', numhl = signs.numhl or '' }
      )
    end
  end,
}
