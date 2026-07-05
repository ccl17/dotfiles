-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

require("oil").setup({
	columns = {
		"icons",
		"permissions",
		"size",
		"mtime",
	},
	keymaps = {
		["?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["<C-g>"] = "actions.open_external",
		["q"] = { "actions.close", mode = "n" },
		["-"] = { "actions.parent", mode = "n" },
	},
	use_default_keymaps = false,
	view_options = {
		is_always_hidden = function(name, _)
			return name == ".."
		end,
		show_hidden = true,
	},
	win_options = {
		winbar = "%!v:lua.get_oil_winbar()",
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("oil").open(vim.fs.root(0, { ".git" }))
end, { desc = "Opens Oil" })
