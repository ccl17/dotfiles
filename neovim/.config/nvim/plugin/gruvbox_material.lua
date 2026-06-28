vim.o.termguicolors = true

vim.pack.add({
	{ src = 'https://github.com/sainnhe/gruvbox-material' }
})

vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbot_material_better_performance = 1
vim.cmd.colorscheme('gruvbox-material')
