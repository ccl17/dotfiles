local g, opt = vim.g, vim.opt

-- security
opt.modelines = 0

-- set leader key
g.mapleader = ' '
g.maplocalleader = ' '

-- hide buffers, not close them
opt.hidden = true

-- maintain undo history between sessions
opt.swapfile = false
opt.undofile = true

-- scroll bounds
opt.scrolloff = 13
opt.sidescroll = 8

-- scrolling
opt.mouse = 'a'

-- fuzzy find
opt.path:append('**')
-- lazy file name tab completion
opt.wildmode = 'list:longest,list:full'
opt.wildmenu = true
opt.wildignorecase = true
-- ignore files vim doesnt use
opt.wildignore:append('.git,.hg,.svn')
opt.wildignore:append('.aux,*.out,*.toc')
opt.wildignore:append('.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class')
opt.wildignore:append('.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp')
opt.wildignore:append('.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg')
opt.wildignore:append('.mp3,*.oga,*.ogg,*.wav,*.flac')
opt.wildignore:append('.eot,*.otf,*.ttf,*.woff')
opt.wildignore:append('.doc,*.pdf,*.cbr,*.cbz')
opt.wildignore:append('.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb')
opt.wildignore:append('.swp,.lock,.DS_Store,._*')
opt.wildignore:append('.,..')

-- case insensitive search
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true

opt.grepprg = 'rg --vimgrep'
opt.virtualedit = 'block'
opt.updatetime = 200
opt.timeoutlen = 300

-- make backspace behave in a sane manner
opt.backspace = 'indent,eol,start'

-- searching
opt.hlsearch = true
opt.incsearch = false
opt.inccommand = 'split'

-- use indents of 2
opt.shiftwidth = 2

-- tabs are tabs
opt.expandtab = true

-- an indentation every 2 columns
opt.tabstop = 2

-- let backspace delete indent
opt.softtabstop = 2

-- enable auto indentation
opt.autoindent = true

-- UI

-- show matching brackets/parenthesis
opt.showmatch = true

-- disable startup message
opt.shortmess:append('sI')

-- cmd display (set to zero to autohide)
opt.cmdheight = 1

-- gutter sizing
opt.signcolumn = 'yes'
opt.relativenumber = true

-- syntax highlighting
opt.termguicolors = true
opt.synmaxcol = 512

-- show line numbers
opt.number = true

-- default no line wrapping
opt.wrap = false

-- set indents when wrapped
opt.breakindent = true

-- show invisibles
opt.listchars = { tab = '  ', trail = '·', extends = '»', precedes = '«', nbsp = '░' }
opt.list = true

-- split style
opt.fillchars = { eob = ' ' }
opt.splitbelow = true
opt.splitright = true

-- clipboard
opt.clipboard = 'unnamedplus'

-- don't announce modes
opt.showmode = false
