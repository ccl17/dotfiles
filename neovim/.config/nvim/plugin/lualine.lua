require("lualine").setup({
	options = {
		globalstatus = true,
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = {
					modified = "",
					readonly = "[-]",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			},
		},
	},
})
