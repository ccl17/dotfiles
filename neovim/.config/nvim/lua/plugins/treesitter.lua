return {
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		{
			'nvim-treesitter/nvim-treesitter-context',
			keys = {
				{
					'[c',
					function()
						if vim.wo.diff then
							return '[c'
						else
							vim.schedule(
								function() require('treesitter-context').go_to_context() end
							)
							return '<Ignore>'
						end
					end,
					desc = 'Jump to context',
					expr = true,
				},
			},
			opts = {
				max_lines = 3,
				min_window_height = 20,
				trim_scope = 'inner',
			},
		},
	},
	lazy = false,
	branch = 'master',
	build = ':TSUpdate',
	opts = {
		ensure_installed = {
			'bash',
			'go',
			'javascript',
			'json',
			'json5',
			'jsonc',
			'lua',
			'markdown',
			'markdown_inline',
			'typescript',
			'vim',
			'vimdoc',
			'yaml',
		},
		auto_install = false,
		sync_install = false,
		highlight = { enable = true },
		incremental_selection = { enable = false },
		indent = { enable = true },
	},
	config = function(_, opts) require('nvim-treesitter.configs').setup(opts) end,
}
