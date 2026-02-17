return {
	{
		'lewis6991/gitsigns.nvim',
		lazy = false,
		config = function()
			require('gitsigns').setup({
				signs = {
					add = { text = '┊' },
					change = { text = '┊' },
					delete = { text = '┊' },
					topdelete = { text = '┊' },
					changedelete = { text = '┊' },
					untracked = { text = '┊' },
				},
				signs_staged = {
					add = { text = '▏' },
					change = { text = '▏' },
					delete = { text = '▏' },
					topdelete = { text = '▏' },
					changedelete = { text = '▏' },
					untracked = { text = '▏' },
				},
				signcolumn = true,
				numhl = false,
				linehl = false,
				word_diff = false,
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				sign_priority = 6,
				status_formatter = nil,
				update_debounce = 200,
				max_file_length = 40000,
				preview_config = {
					border = 'rounded',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gitsigns = require('gitsigns')
					vim.keymap.set(
						'n',
						']g',
						gitsigns.next_hunk,
						{ desc = 'Next Git hunk', buffer = bufnr }
					)
					vim.keymap.set(
						'n',
						'[g',
						gitsigns.prev_hunk,
						{ desc = 'Previous Git hunk', buffer = bufnr }
					)
					vim.keymap.set(
						'n',
						'<leader>gh',
						gitsigns.preview_hunk,
						{ desc = 'Preview Git hunk', buffer = bufnr }
					)
					vim.keymap.set(
						'n',
						'<leader>gr',
						gitsigns.reset_hunk,
						{ desc = 'Reset Git hunk', buffer = bufnr }
					)
					vim.keymap.set(
						'n',
						'<leader>gs',
						gitsigns.stage_hunk,
						{ desc = 'Stage Git hunk', buffer = bufnr }
					)
				end,
			})
		end,
	},
	{
		'sindrets/diffview.nvim',
		event = 'VeryLazy',
		cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
		keys = {
			{ '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'diffview open', mode = 'n' },
		},
		opts = {
			keymaps = {
				view = { q = '<cmd>DiffviewClose<cr>' },
				file_panel = { q = '<cmd>DiffviewClose<cr>' },
				file_history_panel = { q = '<cmd>DiffviewClose<cr>' },
			},
		},
	},
	{
		'ruifm/gitlinker.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = { mappings = '<leader>gc' },
		config = function(_, opts)
			require('gitlinker').setup(opts)
			vim.api.nvim_set_keymap(
				'n',
				'<leader>gY',
				'<cmd>lua require"gitlinker".get_repo_url()<cr>',
				{ silent = true, desc = 'copy git repository URL' }
			)
			vim.api.nvim_set_keymap(
				'n',
				'<leader>gB',
				'<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
				{ silent = true, desc = 'open git repository URL in browser' }
			)
		end,
	},
}
