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
				function()
					local bufremove = require('mini.bufremove')
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.bo[buf].buftype ~= 'terminal' then bufremove.delete(buf, false) end
					end
				end,
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
