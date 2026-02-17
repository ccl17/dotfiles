-- Save the window layout when closing a buffer.
return {
	{
		'nvim-mini/mini.bufremove',
		opts = {},
		keys = {
			{
				'<leader>bd',
				function() require('mini.bufremove').delete(0, false) end,
				desc = 'Delete current buffer',
			},
			{
				'<leader>bD',
				'<cmd>%bd<cr>',
				desc = 'Delete all buffers',
			},
			{
				'<leader>bo',
				'<cmd>%bd|e#|bd#<cr>',
				desc = 'Delete other buffers',
			},
		},
	},
}
