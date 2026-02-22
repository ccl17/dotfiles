return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local lualine = require('lualine')
		local opts = lualine.get_config()
		opts.theme = 'gruvbox-material'
		opts.options.globalstatus = true
		table.insert(opts.sections.lualine_x, 2, {
			function()
				local status = require('sidekick.status').cli()
				return ' ' .. (#status > 1 and #status or '')
			end,
			cond = function() return #require('sidekick.status').cli() > 0 end,
			color = function() return 'Special' end,
		})

		lualine.setup(opts)
	end,
}
