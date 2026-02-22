local function debounce(ms, fn)
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

return {
	'mfussenegger/nvim-lint',
	event = 'BufReadPre',
	config = function()
		local lint = require('lint')
		lint.linters_by_ft = {
			dockerfile = { 'hadolint' },
			go = { 'golangcilint' },
			sh = { 'shellcheck' },
			terraform = { 'terraform_validate', 'tflint', 'tfsec' },
			tf = { 'terraform_validate', 'tflint', 'tfsec' },
			yaml = { 'yamllint' },
			zsh = { 'shellcheck' },
		}

		local try_lint = debounce(100, function() lint.try_lint() end)
		vim.api.nvim_create_autocmd(
			{ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' },
			{
				group = vim.api.nvim_create_augroup('sc/lint', { clear = true }),
				callback = try_lint,
			}
		)
	end,
}
