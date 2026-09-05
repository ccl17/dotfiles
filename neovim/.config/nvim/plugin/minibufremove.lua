vim.keymap.set("n", "<c-x>", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete current buffer" })
