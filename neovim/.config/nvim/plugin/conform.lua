require("conform").setup({
	formatters_by_ft = {
		go = { "goimports" },
		javascript = { "prettierd" },
		json = { "prettierd" },
		lua = { "stylua" },
		yaml = { "prettierd" },
	},
	format_on_save = function(bufnr)
		if not vim.g.autoformat then
			return nil
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	notify_on_error = false,
	notify_no_formatters = false,
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.g.autoformat = true
