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
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run File' },
    { '<leader>tF', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run All Test Files' },
    { '<leader>tc', function() require('neotest').run.run() end, desc = 'Run test at Cursor' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Stop' },
    { '<leader>to', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output' },
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
      summary = {
        enabled = false,
      },
    }
  end,
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, vim.api.nvim_create_namespace('neotest'))
    require('neotest').setup(opts)
  end,
}
