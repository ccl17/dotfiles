local fzf = require("fzf-lua")
fzf.setup({
	files = {
		cwd_prompt = false,
	},
	grep = {
		hidden = true,
		rg_glob = true,
		rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
})
fzf.register_ui_select()
require("fzf-lua-frecency").setup({})

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua frecency cwd_only=true display_score=false<cr>", { desc = "Files" })

vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })

vim.keymap.set({ "n", "x" }, "<leader>fb", function()
	local mode = vim.api.nvim_get_mode().mode
	if vim.startswith(mode, "n") then
		require("fzf-lua").lgrep_curbuf()
	else
		require("fzf-lua").blines()
	end
end, { desc = "Search current buffer" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "Grep" })

vim.keymap.set("x", "<leader>fg", function()
	require("fzf-lua").grep_visual()
end, { desc = "Grep visual" })

vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua resume<cr>", { desc = "Resume last fzf command" })
