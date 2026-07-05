require("luasnip.loaders.from_vscode").lazy_load()

local blink = require("blink.cmp")
blink.setup({
	cmdline = { enabled = false },
	completion = {
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
				},
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = {
				border = "single",
				scrollbar = false,
			},
		},
		list = {
			max_items = 10,
			selection = {
				auto_insert = true,
				preselect = true,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	keymap = {
		["<cr>"] = { "accept", "fallback" },
		["<tab>"] = { "snippet_forward", "fallback" },
		["<s-tab>"] = { "snippet_backward", "fallback" },
		["<C-c>"] = { "show" },
		["<C-d>"] = { "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
	},
	-- snippets = { preset = "luasnip" },
	sources = {
		-- Disable some sources in comments and strings.
		default = function()
			local sources = { "lsp" }
			local ok, node = pcall(vim.treesitter.get_node)

			if ok and node then
				if not vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
					table.insert(sources, "path")
				end
				if node:type() ~= "string" then
					table.insert(sources, "snippets")
				end
			end

			return sources
		end,
	},
})
