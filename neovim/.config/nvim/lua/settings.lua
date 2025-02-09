-- security
vim.opt.modelines = 0

-- set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- hide buffers, not close them
-- vim.opt.hidden = true

-- maintain undo history between sessions
vim.opt.swapfile = false
vim.opt.undofile = true

-- scroll bounds
vim.opt.scrolloff = 13
vim.opt.sidescroll = 8

-- scrolling
vim.opt.mouse = 'a'

-- fuzzy find
vim.opt.path:append('**')
-- lazy file name tab completion
vim.opt.wildmode = 'list:longest,list:full'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
-- ignore files vim doesnt use
vim.opt.wildignore:append('.git,.hg,.svn')
vim.opt.wildignore:append('.aux,*.out,*.toc')
vim.opt.wildignore:append('.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class')
vim.opt.wildignore:append('.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp')
vim.opt.wildignore:append('.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg')
vim.opt.wildignore:append('.mp3,*.oga,*.ogg,*.wav,*.flac')
vim.opt.wildignore:append('.eot,*.otf,*.ttf,*.woff')
vim.opt.wildignore:append('.doc,*.pdf,*.cbr,*.cbz')
vim.opt.wildignore:append('.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb')
vim.opt.wildignore:append('.swp,.lock,.DS_Store,._*')
vim.opt.wildignore:append('.,..')

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

vim.opt.grepprg = 'rg --vimgrep'
vim.opt.virtualedit = 'block'
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300

-- make backspace behave in a sane manner
vim.opt.backspace = 'indent,eol,start'

-- searching
vim.opt.hlsearch = true
vim.opt.incsearch = false
vim.opt.inccommand = 'split'

-- enable auto indentation
vim.opt.autoindent = true

-- UI

-- show matching brackets/parenthesis
vim.opt.showmatch = true

-- disable startup message
vim.opt.shortmess:append('sI')

-- cmd display (set to zero to autohide)
vim.opt.cmdheight = 1

-- pop up menu
-- vim.opt.pumblend = 0

-- gutter sizing
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true

-- syntax highlighting
vim.opt.termguicolors = true
vim.opt.synmaxcol = 512

-- show line numbers
vim.opt.number = true

-- default no line wrapping
vim.opt.wrap = false

-- set indents when wrapped
vim.opt.breakindent = true

-- cursorline
vim.opt.cursorline = true

-- show invisibles
vim.opt.listchars = { tab = '▸ ', trail = '·', extends = '»', precedes = '«', nbsp = '░' }
vim.opt.list = true

-- split style
vim.opt.fillchars = { eob = ' ' }
vim.opt.splitbelow = true
vim.opt.splitright = true

-- clipboard
vim.opt.clipboard = 'unnamedplus'

-- don't announce modes
vim.opt.showmode = false
