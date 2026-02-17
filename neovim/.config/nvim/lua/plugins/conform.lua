return {
	'stevearc/conform.nvim',
	event = 'BufWritePre',
	opts = {
		notify_on_error = false,
		formatters_by_ft = {
			go = { 'goimports' },
			lua = { 'stylua' },
		},
		format_on_save = function(bufnr)
			if not vim.g.autoformat then return end

			return { timeout_ms = 500, lsp_format = 'fallback' }
		end,
	},
	init = function()
		vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
		vim.g.autoformat = true
	end,
}
