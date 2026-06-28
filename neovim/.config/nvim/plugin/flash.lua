vim.pack.add({
	{ src = "https://github.com/folke/flash.nvim" },
})

require("flash").setup({
	jump = { nohlsearch = true },
	prompt = {
		win_config = {
			border = "none",
			-- Place the prompt above the statusline.
			row = -3,
		},
	},
	search = {
		exclude = {
			"flash_prompt",
			"qf",
			function(win)
				-- Non-focusable windows.
				return not vim.api.nvim_win_get_config(win).focusable
			end,
		},
	},
	modes = {
		-- Enable flash when searching with ? or /
		search = { enabled = false },
	},
})

local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", function()
	flash.jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
	flash.remote()
end, { desc = "Remote Flash" })

vim.keymap.set("o", "R", function()
	flash.treesitter_search()
end, { desc = "Flash Treesitter Search" })
