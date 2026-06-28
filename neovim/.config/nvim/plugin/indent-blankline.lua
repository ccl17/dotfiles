vim.pack.add({
	{
		src = "https://github.com/lukas-reineke/indent-blankline.nvim",
		module_name = "ibl",
	},
})

require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = {
		enabled = true,
		show_start = false,
		show_end = false,
		char = "│",
	},
})
