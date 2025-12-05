" =============================================================================
" vim-plug Plugin Manager Setup
" =============================================================================
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')


" =============================================================================
" Plugin Declarations
" =============================================================================
" List of plugins managed by vim-plug

" --- UI Enhancements ---
Plug 'vim-airline/vim-airline'             " Fancy status/tabline
" Colorscheme
Plug 'ayu-theme/ayu-vim' " or other package manager


Plug 'myusuf3/numbers.vim'                 " Better line numbers (relative/hybrid)
Plug 'yggdroot/indentline'                 " Display vertical indentation lines

" Auto-close brackets
Plug 'jiangmiao/auto-pairs'


" --- Snippets ---
Plug 'SirVer/ultisnips'                    " Snippet engine (needs Python 3)
Plug 'honza/vim-snippets'                  " Collection of snippets for various languages

" --- Language Support & Linting/Completion ---
Plug 'vhda/verilog_systemverilog.vim'      " Syntax highlighting and indent for Verilog/SystemVerilog
Plug 'dense-analysis/ale'                  " Asynchronous Lint Engine (syntax checking, linting)
Plug 'lervag/vimtex'                       " For Latex
Plug 'lervag/vimtex', { 'tag': 'v2.15' }

" --- Utility ---
Plug 'thaerkh/vim-workspace'               " Automatic session saving/loading (includes autosave)
Plug 'mg979/vim-visual-multi', {'branch': 'master'}  " magic cursor
" The Floating Terminal Plugin
Plug 'voldikss/vim-floaterm'
" (Optional) Theme - matches your Emacs
Plug 'romgrk/doom-one.vim'


" --- Example/Commented-Out Plugins ---
" Plug 'preservim/nerdtree'                " File explorer tree
" Plug 'tpope/vim-fugitive'                " Git integration
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder (requires external install)
" Plug 'junegunn/fzf.vim'                  " Vim integration for fzf
" Plug 'morhetz/gruvbox'                   " Another popular colorscheme
 
 
" Initialize plugin system
call plug#end()
 
 
" =============================================================================
" Plugin Configurations
" =============================================================================
 
" ===================== For Latex ===========================
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note: Most plugin managers will do this automatically!
filetype plugin indent on
 
" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'general'
 
" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
 
" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexmk'
 
" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","

" Don't pop up every compile, just refresh existing viewer
let g:vimtex_view_automatic = 0
let g:vimtex_view_automatic_focus = 0

" Compile with latexmk on save
autocmd BufWritePost *.tex silent! VimtexCompile

" ============================================================

" --- UltiSnips (Snippet Engine) ---
" Set <Tab> to trigger snippet expansion
let g:UltiSnipsExpandTrigger="<tab>"
" Set <Ctrl-b> to jump forward within a snippet
let g:UltiSnipsJumpForwardTrigger="<c-b>"
" Set <Ctrl-z> to jump backward within a snippet
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


let ayucolor="mirage" " for mirage version of theme

" --- indentLine (Vertical Indentation Lines) ---
" Set the color for the indentation lines in terminals
let g:indentLine_color_term = 239

" --- vim-workspace (Autosave) ---
" Enable autosaving whenever a buffer is modified
let g:workspace_autosave_always = 1

" 2. BASIC SETTINGS
set number relativenumber  " Relative line numbers
set termguicolors          " Enable true colors
syntax on                  " Syntax highlighting

" 3. LEADER KEY (Space)
let mapleader = " "

" 4. TERMINAL CONFIGURATION (Make it look like Emacs/VSCode)
" Set it to open at the bottom, take up 30% height
let g:floaterm_width = 1.0
let g:floaterm_height = 0.3
let g:floaterm_position = 'bottom'
let g:floaterm_wintype = 'float'

" Hide the borders for a cleaner look (optional)
let g:floaterm_borderchars = '─│─│╭╮╯╰'

" 5. KEY BINDINGS
" SPC t = Toggle Terminal
nnoremap <silent> <leader>t :FloatermToggle<CR>
tnoremap <silent> <leader>t <C-\><C-n>:FloatermToggle<CR>

" SPC n = New Terminal (if you need a second one)
nnoremap <silent> <leader>tn :FloatermNew<CR>


" 1. Map ESC inside terminal to exit 'Type Mode' so you can use Vim keys
tnoremap <Esc> <C-\><C-n>

" 2. Make SPACE t toggle the window (Hide/Show)
nnoremap <silent> <leader>t :FloatermToggle<CR>
tnoremap <silent> <leader>t <C-\><C-n>:FloatermToggle<CR>
" =============================================================================
" General Vim Settings & Autocommands
" =============================================================================

" --- Filetype Settings ---
" Force Vim to recognize .v and .sv files as 'verilog'
" This ensures the correct snippets from 'vim-snippets' are loaded.
au BufNewFile,BufRead *.v,*.sv set filetype=verilog


" --- Basic Vim Setup (Consider adding these if you don't have them) ---
" filetype plugin indent on    " Load filetype-specific plugins, indent settings
  syntax on                    " Enable syntax highlighting
  set nocompatible             " Use Vim defaults, not Vi-compatible (often needed for plugins)
" set number                   " Show line numbers
" set relativenumber           " Show relative line numbers (combines well with 'numbers.vim')
" set tabstop=4                " Number of spaces a <Tab> counts for
" set shiftwidth=4             " Number of spaces for auto-indent
" set expandtab                " Use spaces instead of literal <Tab> characters
" set smartindent              " Basic smart auto-indenting
" set ignorecase               " Ignore case when searching
" set smartcase                " Override ignorecase if search pattern has uppercase letters
" set incsearch                " Show search results incrementally
  set hlsearch                 " Highlight search results
