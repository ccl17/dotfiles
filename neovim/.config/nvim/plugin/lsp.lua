vim.g.inlay_hints = false

local function on_attach(client, bufnr)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

	vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { buf = bufnr, desc = "Line diagnostic" })

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, { buf = bufnr, desc = "Previous error" })

	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, { buf = bufnr, desc = "Next error" })

	vim.keymap.set("n", "[e", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, { buf = bufnr, desc = "Previous error" })

	vim.keymap.set("n", "]e", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
	end, { buf = bufnr, desc = "Next error" })

	if client:supports_method("textDocument/references") then
		vim.keymap.set(
			"n",
			"gr",
			"<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>",
			{ buf = bufnr, desc = "LSP references" }
		)
	end

	if client:supports_method("textDocument/definition") then
		vim.keymap.set("n", "gd", function()
			require("fzf-lua").lsp_definitions({ jump1 = true })
		end, { buf = bufnr, desc = "Go to definition" })

		vim.keymap.set("n", "gD", function()
			require("fzf-lua").lsp_definitions({ jump1 = false })
		end, { buf = bufnr, desc = "Peek definition" })
	end

	if client:supports_method("textDocument/typeDefinition") then
		vim.keymap.set(
			"n",
			"gt",
			"<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>",
			{ buf = bufnr, desc = "Go to type definition" }
		)
	end

	if client:supports_method("textDocument/implementation") then
		vim.keymap.set(
			"n",
			"gi",
			"<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>",
			{ buf = bufnr, desc = "Go to implementations" }
		)
	end

	if client:supports_method("textDocument/signatureHelp") then
		vim.keymap.set("i", "<C-k>", function()
			-- Close the completion menu first (if open).
			if require("blink.cmp.completion.windows.menu").win:is_open() then
				require("blink.cmp").hide()
			end

			vim.lsp.buf.signature_help()
		end, { buf = bufnr, desc = "Signature help" })
	end

	if client:supports_method("textDocument/documentHighlight") then
		local under_cursor_highlights_group = vim.api.nvim_create_augroup("cursor_highlights", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Highlight references under the cursor",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
			group = under_cursor_highlights_group,
			desc = "Clear highlight references",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	vim.keymap.set("n", "gra", "<cmd>FzfLua lsp_code_actions<cr>", { buf = bufnr, desc = "Code action" })

	if client:supports_method("textDocument/codeLens") then
		local code_lens_group = vim.api.nvim_create_augroup("code_lens", { clear = false })
		vim.api.nvim_create_autocmd("LspProgress", {
			group = code_lens_group,
			callback = function(ev)
				if ev.buf == bufnr then
					vim.lsp.codelens.enable(true, { bufnr = bufnr })
				end
			end,
		})
		vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
			group = code_lens_group,
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.enable(true, { bufnr = bufnr })
			end,
		})
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end

	if client:supports_method("textDocument/foldingRange") then
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
	end

	if client:supports_method("textDocument/inlayHint") then
		local inlay_hints_group = vim.api.nvim_create_augroup("toggle_inlay_hints", { clear = false })
		if vim.g.inlay_hints then
			vim.defer_fn(function()
				local mode = vim.api.nvim_get_mode().mode
				vim.lsp.inlay_hint.enable(mode == "n" or mode == "v", { bufnr = bufnr })
			end, 500)
		end

		vim.api.nvim_create_autocmd("InsertEnter", {
			group = inlay_hints_group,
			desc = "Enable inlay hints",
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
				end
			end,
		})

		vim.api.nvim_create_autocmd("InsertLeave", {
			group = inlay_hints_group,
			desc = "Disable inlay hints",
			buffer = bufnr,
			callback = function()
				if vim.g.inlay_hints then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end,
		})
	end
end

vim.diagnostic.config({
	severity_sort = true,
	signs = false,
	underline = true,
	update_in_insert = true,
	virtual_text = false,
})

local register_capability = vim.lsp.handlers["client/registerCapability"]
vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	if not client then
		return
	end
	on_attach(client, vim.api.nvim_get_current_buf())
	return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Configure LSP",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		on_attach(client, args.buf)
	end,
})

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
	:map(function(file)
		return vim.fn.fnamemodify(file, ":t:r")
	end)
	:totable()
vim.lsp.enable(servers)
