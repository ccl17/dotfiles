require("gitsigns").setup({
	current_line_blame = true,
	gh = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		vim.keymap.set("n", "[g", gs.prev_hunk, { desc = "Previous hunk", buf = bufnr })
		vim.keymap.set("n", "]g", gs.next_hunk, { desc = "Next hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer", buf = bufnr })
		vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Blame line", buf = bufnr })
		vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk", buf = bufnr })
		vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk", buf = bufnr })
	end,
	preview_config = { border = "rounded" },
})

require("diffview").setup({
	default_args = { DiffviewFileHistory = { "%" } },
})

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview" })
