return {
	{
		'folke/sidekick.nvim',
		opts = {
			nes = { enabled = false },
			cli = {
				mux = { enabled = false },
				picker = 'fzf-lua',
			},
			mux = { create = 'split' },
		},
		keys = {
			{
				'<c-.>',
				function() require('sidekick.cli').toggle({ name = 'claude' }) end,
				desc = 'Sidekick Toggle',
				mode = { 'n', 't', 'i', 'x' },
			},
			{
				'<leader>av',
				function() require('sidekick.cli').send({ msg = '{selection}' }) end,
				mode = { 'x' },
				desc = 'Send visual selection to Sidekick',
			},
			{
				'<leader>af',
				function() require('sidekick.cli').send({ msg = '{file}' }) end,
				desc = 'Send File',
			},
			{
				'<leader>ad',
				function() require('sidekick.cli').close() end,
				desc = 'Detach a CLI Session',
			},
		},
	},
}
