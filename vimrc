"" --- Pathogen {{{
""  Pathogen Settings (https://github.com/tpope/vim-pathogen)
"filetype off
"filetype plugin indent off
"let g:javascript_plugin_jsdoc = 1
"let g:user_emmet_leader_key='<Tab>'
"let g:user_emmet_settings = {
"  \  'javascript.jsx' : {
"    \      'extends' : 'jsx',
"    \  },
"  \}

" Adds all bundles to the runtime path
"execute pathogen#infect()

" Updates all docs on load
"execute pathogen#helptags()
" --- }}}

" vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'scrooloose/nerdtree'
Plug 'elixir-editors/vim-elixir'

call plug#end()
" --- General Settings {{{
" File Settings
if &compatible
  set nocompatible              " Don't try to be compatible with Vi
endif

filetype plugin indent on       " Enables file type detection

syntax on                       " Enable syntax highlighting
set synmaxcol=150               " Don't highlight text past N columns

set encoding=utf-8              " Read files using utf-8
set autoread                    " Automatically read a changed file

" Backup/swap files
set nobackup                    " Don't create swp file or any files by default
set nowritebackup
set noswapfile

" Allows us to undo even after we closed vim and reopened it
if has('persistent_undo')
  set undofile
  set undodir=/tmp
endif

" Performance
set lazyredraw                  " Don't redraw while running macros
set ttyfast                     " Speed up scrolling
"set ttyscroll=3                 " Improve scrolling speed
set scrolloff=999               " Minimum lines above/below cursor
set history=25                  " Limit Vim's history to 25 commands
set ttimeoutlen=100             " Switch modes faster, 10th of a second

" Look & Feel
set hidden                      " When I open a new file in a buffer, hide old buffer
set shortmess+=Iat              " Disable help screen, avoid enter prompt
set nowrap                      " Don't line wrap
set backspace=indent,eol,start  " Treat backspace as delete
set number                      " Show line numbers

" More 'natural' vim splits
set splitbelow
set splitright

" When listing characters, show some invisible characters of interest
set listchars=tab:▸\ ,eol:¬,trail:·

" Searching
set ignorecase                  " Ignore case in search
set smartcase                   " Don't ignore case if contains uppercase letter
set wrapscan                    " Wrap search from bottom of file to top
set showmatch                   " Show matching brackets
set hlsearch                    " Highlight search results
set incsearch                   " Search as you type

" Sets 'very magic' mode, similar to Python/Ruby/Grep regex syntax
cnoremap %s/ %s/\v
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Tabs/spaces
set tabstop=2                   " Replace tabs with four spaces
set shiftwidth=2
set softtabstop=2
set expandtab

" Indenting
set autoindent                  " Enable auto indenting
set smartindent                 " Try to 'improve' indenting rules
set cindent                     " Smarter indents for C programs


" --- Wild Menu {{{
set wildignore+=*.swp,*~,tags,*.log,__init__.py,*.pyc,*.pyo,*.ttf,*.DS_Store
set wildignore+=*.mp3,*.wav,*.ogg,*.ico,*.icns,*.jpg,*.jpeg,*.png,*.gif,*.db
set wildignore+=*.out,*/tmp/*,*/build/*,*/node_modules/*,*.gem,*/assets/libs/*,*/bower_components/*,bundled.js,bundled.css
" --- }}}

" --- Autocommands {{{
function! TrimTrailingWhiteSpace()
  %s/\s\+$//e
endfunction

" --- Disable Mappings {{{
" Disable the built in F1 binding for help
nnoremap <F1> <NOP>
inoremap <F1> <NOP>

" --- Custom Functions {{{
" Rename current file, via Gary Bernhardt & Chris Hunt's helper function
function! MoveFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
" --- }}}

" --- Mappings {{{
let mapleader = ","

" Make jj/kk escape from insert mode
inoremap jj <ESC>
inoremap kk <ESC>

" Shortcut to toggle the visibility of newlines, tabs and long lines etc
nnoremap <leader>l :set list!<cr>

" Clear search highlights
nnoremap <C-l> :nohlsearch<cr>

" Save current buffer
nnoremap <leader>w :w!<cr>

" Paste from system clipboard (retain formatting)
nnoremap <leader>P "+p<cr>

" Visual copy key-bindings (uses pbcopy which is an OSX utility)
vnoremap <leader>c :w<Home>silent <End> !pbcopy<cr>

" Make space toggle code folds or move forward if not in a fold
nnoremap <silent> <Space> @=(foldlevel('.') ? 'za' : "\<Space>")<CR>

" Mappings for window splits
nnoremap <leader>\ :vsplit<cr>
nnoremap <leader>- :split<cr>

" Use shift h or l to move around tabs
nnoremap <S-h> gT
nnoremap <S-l> gt

" Don't deselect in visual mode when indenting/dedenting
vnoremap > >gv
vnoremap < <gv

" CTags bindings
nnoremap <leader>rt :! clear &&
            \ ctags -R --tag-relative=yes
            \ --exclude=.git
            \ --exclude=.rvm
            \ --exclude=.bundle
            \ --exclude=node_modules
            \ --exclude=db
            \ --exclude=bin
            \ --exclude=dist
            \ --exclude=build
            \ .<cr><cr>

" Toggle cursor line
nnoremap <leader>_ :set cursorline!<cr>

nnoremap <leader>r :!bundle exec rspec %<cr>
nnoremap <leader>R :!bundle exec rspec spec<cr>
" --- }}}

" --- Custom Function Mappings {{{
" 'Move', aka 'Rename' the current file
nnoremap <leader>mv :call MoveFile()<cr>
" --- }}}

" --- Status Line {{{
"set laststatus=2                            " Always show a status line
"set statusline=%f%m%r%h                     " file, modified, ro, help tags
"if v:version >= 703
"  set statusline+=%q                        " quickfix tag
"endif
"set statusline+=\ [%{&ff}]%y                " file format (dos/unix) and type
"set statusline+=\ %{fugitive#statusline()}  " git status (branch)
"set statusline+=%#warningmsg#
"" set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*                          "*
"set statusline+=\ %=#%n                     " start right-align. buffer number
"set statusline+=\ %l/%L,%c                  " lines/total, column
"set statusline+=\ [%P]                      " percentage in file
" --- }}}

" --- GUI Settings {{{
if has("gui_running")
  " We're probably in MacVim or gvim, increase the starting window size.
  set lines=60 columns=190
else
  " This is console Vim. Nothing special to do here.
endif
" --- }}}

"--- Colors {{{
if filereadable( expand("$HOME/.vim/colors/monokai.vim") )
  colorscheme monokai
  highlight Normal  ctermbg=NONE guibg=black
  highlight LineNR  ctermbg=NONE guibg=black
  highlight NonText ctermbg=NONE ctermfg=NONE guibg=black
endif
"--- }}}

map <C-n> :NERDTreeToggle<CR>
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:vim_jsx_pretty_colorful_config = 1

