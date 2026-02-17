return {
	'Wansmer/treesj',
	keys = {
		{
			'<leader>cj',
			function() require('treesj').toggle() end,
			desc = 'Toggle split/join',
			mode = 'n',
		},
	},
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
