return {
	'folke/trouble.nvim',
	cmd = 'Trouble',
	event = 'VeryLazy',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	opts = {},
	keys = {
		{
			'<leader>tt',
			'<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>',
			desc = 'Trouble diagnostics',
		},
		{
			'<leader>tT',
			'<cmd>Trouble diagnostics toggle focus=true<cr>',
			desc = 'Project diagnostics',
		},
		{
			'<leader>ts',
			'<cmd>Trouble symbols toggle focus=true<cr>',
			desc = 'symbols',
		},
	},
}
