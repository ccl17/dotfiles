vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/Wansmer/treesj" },
})

local langs = {
	"bash",
	"go",
	"javascript",
	"json",
	"json5",
	"lua",
	"markdown",
	"markdown_inline",
	"vim",
	"vimdoc",
	"yaml",
}

local ignored_fts = {}

local treesitter = require("nvim-treesitter")

treesitter.install(langs)

vim.api.nvim_create_autocmd("FileType", {
	desc = "Automatically install treesitter parser",
	pattern = "*",
	group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
	callback = function(args)
		if not treesitter then
			return
		end

		if vim.tbl_contains(ignored_fts, args.match) then
			return
		end

		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if require("nvim-treesitter.parsers")[lang] ~= nil then
			require("nvim-treesitter").install(lang):await(function()
				local ts_supported = pcall(vim.treesitter.start, args.buf)
				if not ts_supported then
					return
				end
			end)
		end
	end,
})

require("nvim-treesitter-textobjects").setup({})
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		if args.data.spec.name == "nvim-treesitter" and (args.data.kind == "install" or args.data.kind == "update") then
			treesitter.install(langs):wait(300000)
			treesitter.update():wait(300000)
		end
	end,
})

vim.keymap.set("n", "<leader>cj", function()
	require("treesj").toggle()
end, { desc = "Toggle split/join" })
