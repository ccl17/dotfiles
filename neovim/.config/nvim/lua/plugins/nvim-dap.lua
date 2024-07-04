return {
  'mfussenegger/nvim-dap',
  lazy = false,
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
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'suketa/nvim-dap-ruby',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap, ui = require('dap'), require('dapui')
    require('dap-ruby').setup()
    require('dap-go').setup()

    ui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = ui.open
    dap.listeners.before.event_terminated['dapui_config'] = ui.close
    dap.listeners.before.event_exited['dapui_config'] = ui.close
  end,
}