return {
	'MagicDuck/grug-far.nvim',
	cmd = 'GrugFar',
	keys = {
		{
			'<leader>cg',
			function()
				local grug = require('grug-far')
				grug.open({ transient = true, prefills = { paths = vim.fn.expand('%') } })
			end,
			desc = 'GrugFar current buffer',
			mode = { 'n', 'v' },
		},
		{
			'<leader>cG',
			function()
				local grug = require('grug-far')
				grug.open({
					transient = true,
				})
			end,
			desc = 'GrugFar',
			mode = { 'n', 'v' },
		},
	},
	opts = {},
}
