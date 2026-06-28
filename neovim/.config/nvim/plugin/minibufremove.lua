vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.bufremove" },
})

vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete current buffer" })
