local fzf = require("fzf-lua")
fzf.setup({
	files = {
		cwd_prompt = false,
	},
	grep = {
		hidden = true,
	},
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
})
fzf.register_ui_select()
require("fzf-lua-frecency").setup({})

vim.keymap.set("n", "<leader>\\", "<cmd>FzfLua frecency cwd_only=true display_score=false<cr>", { desc = "Files" })
vim.keymap.set(
	"n",
	"<leader>ff",
	"<cmd>FzfLua combine pickers=buffers,files cwd_only=true<cr>",
	{ desc = "Files and Buffers" }
)
vim.api.nvim_create_autocmd("FileType", {
	desc = "Register search in buffer",
	callback = function(args)
		if vim.bo[args.buf].filetype == "oil" then
			return
		end

		vim.keymap.set({ "n", "x" }, "/", function()
			local mode = vim.api.nvim_get_mode().mode
			if vim.startswith(mode, "n") then
				require("fzf-lua").lgrep_curbuf()
			else
				require("fzf-lua").blines()
			end
		end, { buffer = args.buf, desc = "Search current buffer" })
	end,
	group = vim.api.nvim_create_augroup("Buffer search", { clear = true }),
	pattern = "*",
})
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "Grep" })
vim.keymap.set("x", "<leader>fg", function()
	require("fzf-lua").grep_visual()
end, { desc = "Grep visual" })
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>fz", "<cmd>FzfLua resume<cr>", { desc = "Resume last fzf command" })
