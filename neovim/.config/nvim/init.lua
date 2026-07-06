vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.cursorline = true
vim.o.exrc = true
vim.o.foldlevelstart = 99
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.linebreak = true
vim.o.mouse = ""
vim.o.mousescroll = "ver:0,hor:0"
vim.o.number = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 5
vim.o.smoothscroll = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ttimeoutlen = 10
vim.o.timeoutlen = 500
vim.o.undofile = true
vim.o.updatetime = 250

vim.opt.mouse = ""
vim.opt.title = true
vim.opt.wildignore:append({ ".DS_Store" })

vim.wo.signcolumn = "yes"

if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --smart-case"
end

vim.keymap.set({ "", "i" }, "<Up>", "<Nop>")
vim.keymap.set({ "", "i" }, "<Down>", "<Nop>")

-- Movement by visual lines when wrapped using j/k
vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

-- Paste without yanking
vim.keymap.set("x", "p", "P")

-- Move blocks
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual block up" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual block down" })

-- Keeps cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll downwards" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll upwards" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous result" })

-- Indent while remaining in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Navigate between windows.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the bottom window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the top window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right window", remap = true })

-- Jump to end of line in insert mode
vim.keymap.set({ "i", "c" }, "<C-l>", "<C-o>A", { desc = "Jump to the end of the line" })

-- line
vim.keymap.set(
	{ "n", "x", "o" },
	"<s-h>",
	"^",
	{ noremap = true, silent = true, desc = "Move to first non-whitespace in line" }
)
vim.keymap.set(
	{ "n", "x", "o" },
	"<s-l>",
	"g_",
	{ noremap = true, silent = true, desc = "Move to first non-whitespace in line" }
)

-- Window
vim.keymap.set("n", "<leader>wh", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>w=", "<cmd>wincmd =<cr>", { desc = "Equalize size" })
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<A-j>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-k>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<c-q>", "<cmd>:close<cr>", { desc = "Close current window" })

-- Tabs
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab page" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab page" })

-- Buffers
vim.keymap.set("n", "<leader>bD", "<cmd>%bd<cr>", { desc = "Delete all open buffers" })

-- Save file
vim.keymap.set({ "n", "i", "v" }, "<c-s>", "<esc><cmd>w<cr><esc>", { desc = "Save File" })

-- Visual Selection Search Lock Mapping
vim.keymap.set("c", "/", function()
	if vim.fn.getcmdtype():match("[/?]") and vim.fn.getcmdline() == "" then
		return "<C-C><Esc>/\\%V" -- Pressing // inside visual selection restricts upcoming search to that selection
	else
		return "/"
	end
end, { expr = true })

-- Esc key
vim.keymap.set({ "i", "s", "n" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { desc = "Escape", expr = true })

-- Copy relative file path
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

-- Formatting.
vim.keymap.set("n", "gq", "mzgggqG`z<cmd>delmarks z<cr>zz", { desc = "Format buffer" })

-- init autocmd
local init_group = vim.api.nvim_create_augroup("init", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = init_group,
	callback = function()
		if vim.wo.previewwindow then
			vim.keymap.set("n", "q", "<C-W>q", { buffer = true }) -- Tap 'q' to instantly dismiss preview panes
		end
	end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
	group = init_group,
	callback = function()
		vim.keymap.set("n", "q", "<C-W>q", { buffer = true }) -- Tap 'q' to instantly drop out of history command window panes
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = init_group,
	desc = "Highlight on yank",
	callback = function()
		vim.hl.on_yank({ higroup = "Visual" })
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	group = init_group,
	desc = "Auto resize windows",
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = init_group,
	desc = "Clear cmdline on leave",
	callback = function()
		vim.fn.timer_start(3000, function()
			vim.cmd("echon ''")
		end)
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = init_group,
	desc = "Go to the last location when opening a buffer",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.cmd('normal! g`"zz')
		end
	end,
})

local cursorline = vim.api.nvim_create_augroup("cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
	group = cursorline,
	pattern = { "*" },
	callback = function(args)
		vim.wo.cursorline = vim.bo[args.buf].buftype ~= "terminal"
			and not vim.wo.previewwindow
			and vim.wo.winhighlight == ""
			and vim.bo[args.buf].filetype ~= ""
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	group = cursorline,
	pattern = { "*" },
	callback = function()
		vim.wo.cursorline = false
	end,
})

vim.pack.add({
	-- dependencies
	{ src = "https://github.com/b0o/schemastore.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- completion
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
		module_name = "luasnip",
	},
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	-- formatting
	{ src = "https://github.com/stevearc/conform.nvim" },
	-- fzf
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/elanmed/fzf-lua-frecency.nvim" },
	-- treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/Wansmer/treesj" },
	-- lsp
	{ src = "https://github.com/j-hui/fidget.nvim" },
	-- lualine
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- flash
	{ src = "https://github.com/folke/flash.nvim" },
	-- git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	-- theme
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	-- indent
	{
		src = "https://github.com/lukas-reineke/indent-blankline.nvim",
		module_name = "ibl",
	},
	-- buffers
	{ src = "https://github.com/nvim-mini/mini.bufremove" },
	{
		src = "https://github.com/stevearc/oil.nvim",
	},
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
	-- brackets
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{
		src = "https://github.com/kylechui/nvim-surround",
		version = vim.version.range("4.x"),
	},
	-- sessions
	{ src = "https://github.com/folke/persistence.nvim" },
})
