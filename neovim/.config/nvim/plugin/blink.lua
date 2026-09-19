require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require("luasnip")
local types = require("luasnip.util.types")
luasnip.setup({
	history = true,
	update_events = { "TextChanged", "TextChangedI" },
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "<-", "Error" } },
			},
		},
	},
})

local blink = require("blink.cmp")
blink.build():pwait()
blink.setup({
	cmdline = { enabled = false },
	completion = {
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
					{ "source_name", gap = 1 },
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
	fuzzy = { implementation = "rust" },
	keymap = {
		["<cr>"] = { "accept", "fallback" },
		["<c-n>"] = { "snippet_forward", "fallback" },
		["<c-p>"] = { "snippet_backward", "fallback" },
		["<c-c>"] = { "show" },
		["<c-d>"] = { "show_documentation", "hide_documentation" },
		["<c-e>"] = { "hide", "fallback" },
		["<c-b>"] = { "scroll_documentation_up", "fallback" },
		["<c-f>"] = { "scroll_documentation_down", "fallback" },
	},
	snippets = { preset = "luasnip" },
	signature = { enabled = true },
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
