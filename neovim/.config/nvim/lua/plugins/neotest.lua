local function neotest() return require('neotest') end
local function output() neotest().output.open() end
local function output_panel() neotest().output_panel.toggle({ enter = true }) end
local function run_file() neotest().run.run(vim.fn.expand('%')) end
local function nearest() neotest().run.run() end
local function next_failed() neotest().jump.prev({ status = 'failed' }) end
local function prev_failed() neotest().jump.next({ status = 'failed' }) end
local function toggle_summary() neotest().summary.toggle() end
local function cancel() neotest().run.stop({ interactive = true }) end
local function watch_nearest() neotest().watch.toggle() end
local function watch_file() neotest().watch.toggle({ vim.fn.expand('%') }) end
local function watch_stop() neotest().watch.stop() end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- adapters
    'olimorris/neotest-rspec',
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-jest',
  },
  keys = {
    { '<leader>ts', toggle_summary, desc = 'neotest: toggle summary' },
    { '<leader>to', output, desc = 'neotest: output' },
    { '<leader>tO', output_panel, desc = 'neotest: output panel' },
    { '<leader>tn', nearest, desc = 'neotest: run' },
    { '<leader>tf', run_file, desc = 'neotest: run file' },
    { '<leader>tc', cancel, desc = 'neotest: cancel' },
    { '<leader>twn', watch_nearest, desc = 'neotest: watch nearest test' },
    { '<leader>twf', watch_file, desc = 'neotest: watch file' },
    { '<leader>tws', watch_stop, desc = 'neotest: stop watching' },
    { ']t', next_failed, desc = 'jump to next failed test' },
    { '[t', prev_failed, desc = 'jump to previous failed test' },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-rspec'),
        require('neotest-go'),
        require('neotest-jest')({
          jestCommand = 'npm test',
        }),
      },
    })
  end,
}
