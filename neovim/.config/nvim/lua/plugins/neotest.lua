local function neotest() return require('neotest') end
local function output() neotest().output_panel.toggle() end
local function run_file() neotest().run.run(vim.fn.expand('%')) end
local function run_file_sync() neotest().run.run({ vim.fn.expand('%'), concurrent = false }) end
local function nearest() neotest().run.run() end
local function next_failed() neotest().jump.prev({ status = 'failed' }) end
local function prev_failed() neotest().jump.next({ status = 'failed' }) end
local function toggle_summary() neotest().summary.toggle() end
local function cancel() neotest().run.stop({ interactive = true }) end

return {
  {
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
      { '<leader>tn', nearest, desc = 'neotest: run' },
      { '<leader>tf', run_file, desc = 'neotest: run file' },
      { '<leader>tF', run_file_sync, desc = 'neotest: run file synchronously' },
      { '<leader>tc', cancel, desc = 'neotest: cancel' },
      { ']n', next_failed, desc = 'jump to next failed test' },
      { '[n', prev_failed, desc = 'jump to previous failed test' },
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
  },
}
