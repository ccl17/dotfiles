require("oil").setup({
	columns = {
		"icons",
		"mtime",
	},
	default_file_explorer = true,
	keymaps = {
		["?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["<C-g>"] = "actions.open_external",
		["q"] = { "actions.close", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
	},
	use_default_keymaps = false,
	view_options = {
		is_always_hidden = function(name, _)
			return name == ".."
		end,
		show_hidden = true,
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float(vim.fs.root(0, { ".git" }))
end, { desc = "Opens Oil" })

vim.keymap.set("n", "<leader>E", function()
	require("oil").toggle_float()
end, { desc = "Opens Oil" })
