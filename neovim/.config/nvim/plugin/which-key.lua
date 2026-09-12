require("which-key").setup()

local wk = require("which-key")

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Hints" })

wk.add({
	{ "<leader>b", group = "Buffer" },
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "Git" },
	{ "<leader>t", group = "Tab" },
	{ "<leader>w", group = "Window" },
})
