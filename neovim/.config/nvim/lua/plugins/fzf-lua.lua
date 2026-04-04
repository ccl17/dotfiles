return {
	'ibhagwan/fzf-lua',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	cmd = 'FzfLua',
	keys = {
		{
			'<leader>fb',
			function()
				local mode = vim.api.nvim_get_mode().mode
				if vim.startswith(mode, 'n') then
					require('fzf-lua').lgrep_curbuf()
				else
					require('fzf-lua').blines()
				end
			end,
			desc = 'Search current buffer',
			mode = { 'n', 'x' },
		},
		{ '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
		{ '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
		{ '<leader>fg', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep', mode = 'x' },
		{ '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document diagnostics' },
		{ '<leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace diagnostics' },
		{ '<leader>fo', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
		{ '<leader>fz', '<cmd>FzfLua resume<cr>', desc = 'Resume last fzf command' },
		{ '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
	},
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {
		files = {
			cwd_prompt = false,
		},
		grep = {
			hidden = true,
		},
		keymap = {
			builtin = {
				['<C-q>'] = 'select-all+accept',
			},
			fzf = {
				['ctrl-q'] = 'select-all+accept',
			},
		},
		winopts = {
			preview = {
				wrap = 'wrap',
			},
		},
	},
	---@diagnostic enable: missing-fields
	config = function(_, opts)
		local fzf = require('fzf-lua')
		fzf.setup(opts)
		fzf.register_ui_select()
	end,
}
