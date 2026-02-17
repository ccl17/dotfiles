---@type vim.lsp.Config
return {
	cmd = { 'gopls' },
	root_markers = { 'go.mod' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	settings = {
		gopls = {
			completeUnimported = true,
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				nilness = true,
			},
			semanticTokens = true,
			staticcheck = true,
		},
	},
}
