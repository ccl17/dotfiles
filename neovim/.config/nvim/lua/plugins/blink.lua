return {
	'saghen/blink.cmp',
	dependencies = 'rafamadriz/friendly-snippets',
	version = '*',
	event = 'InsertEnter',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			['<C-c>'] = { 'show' },
			['<C-d>'] = { 'show_documentation', 'hide_documentation' },
			['<CR>'] = { 'accept', 'fallback' },
			['<C-e>'] = { 'hide', 'fallback' },
			['<tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
			['<S-tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
			['<C-p>'] = { 'select_prev', 'fallback' },
			['<C-n>'] = { 'select_next', 'fallback' },
			['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
			['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
		},
		sources = {
			default = function()
				local sources = { 'lsp', 'buffer' }
				local ok, node = pcall(vim.treesitter.get_node)

				if
					ok
					and node
					and not vim.tbl_contains(
						{ 'string', 'comment', 'line_comment', 'block_comment' },
						node:type()
					)
				then
					table.insert(sources, 'snippets')
					table.insert(sources, 'path')
				end

				return sources
			end,
		},
		completion = {
			documentation = {
				window = {
					border = 'single',
					draw = { gap = 2 },
					scrollbar = false,
					winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
				},
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				border = 'single',
				draw = { gap = 2 },
				scrollbar = false,
				winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
			},
		},
		cmdline = { completion = { menu = { auto_show = false } } },
	},
}
