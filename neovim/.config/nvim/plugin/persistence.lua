vim.pack.add({
	{ src = "https://github.com/folke/persistence.nvim" },
})

require("persistence").setup({ need = 1, branch = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("load_session", { clear = true }),
	callback = function()
		if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
			require("persistence").load()
		end
	end,
	nested = true,
})
