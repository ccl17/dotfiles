local function clear_output_and_run(fn)
  local neotest = require('neotest')
  neotest.output_panel.clear()
  neotest.output_panel.open()
  fn()
end

local function run_file()
  clear_output_and_run(function() require('neotest').run.run(vim.fn.expand('%')) end)
end

local function run_all_files()
  clear_output_and_run(function() require('neotest').run.run(vim.uv.cwd()) end)
end

local function run_cursor()
  clear_output_and_run(function() require('neotest').run.run() end)
end

local function run_last()
  clear_output_and_run(function() require('neotest').run.run_last() end)
end

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- adapters
    'nvim-neotest/neotest-go',
  },
  keys = {
    { '<leader>tf', run_file, desc = 'Run File' },
    { '<leader>tF', run_all_files, desc = 'Run All Test Files' },
    { '<leader>tc', run_cursor, desc = 'Run test at Cursor' },
    { '<leader>tl', run_last, desc = 'Run Last' },
    { '<leader>to', function() require('neotest').output_panel.toggle() end, desc = 'Toggle Output Panel' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Toggle Watch' },
    { ']t', function() require('neotest').jump.prev({ status = 'failed' }) end, desc = 'jump to next failed test' },
    { '[t', function() require('neotest').jump.next({ status = 'failed' }) end, desc = 'jump to previous failed test' },
  },
  opts = function()
    return {
      adapters = {
        require('neotest-go'),
      },
      discovery = {
        enabled = false,
        concurrent = 1,
      },
      running = {
        concurrent = false,
      },
      output_panel = {
        open = string.format('botright split | resize %d', math.floor(vim.o.lines * 0.4)),
      },
      summary = {
        enabled = false,
      },
    }
  end,
}
