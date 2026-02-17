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
		{ '<leader>p', '<cmd>FzfLua global<cr>', desc = 'Global' },
	},
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {
		winopts = {
			preview = {
				wrap = 'wrap',
			},
		},
		grep = {
			hidden = true,
		},
	},
	---@diagnostic enable: missing-fields
	config = function(_, opts)
		local fzf = require('fzf-lua')
		fzf.setup(opts)
		fzf.register_ui_select()
	end,
}
