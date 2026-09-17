local splits = require("smart-splits")

splits.setup({
	at_edge = "stop",
})
require("ghostty-smart-splits").setup({
	key_table = "nvim",
	transport = "persistent",
})

vim.keymap.set("n", "<C-h>", splits.move_cursor_left)
vim.keymap.set("n", "<C-j>", splits.move_cursor_down)
vim.keymap.set("n", "<C-k>", splits.move_cursor_up)
vim.keymap.set("n", "<C-l>", splits.move_cursor_right)

vim.keymap.set("n", "<M-h>", splits.resize_left)
vim.keymap.set("n", "<M-j>", splits.resize_down)
vim.keymap.set("n", "<M-k>", splits.resize_up)
vim.keymap.set("n", "<M-l>", splits.resize_right)
