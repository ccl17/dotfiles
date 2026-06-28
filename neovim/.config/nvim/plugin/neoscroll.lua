vim.pack.add({
	{ src = "https://github.com/karb94/neoscroll.nvim" },
})

require("neoscroll").setup({ mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" } })
