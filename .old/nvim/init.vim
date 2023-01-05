call plug#begin("~/.config/nvim/plugged")

" fuzzy search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" nice status bar
Plug 'vim-airline/vim-airline'

" show whitespaces and quick fix
Plug 'ntpeters/vim-better-whitespace'

" languages
Plug 'udalov/kotlin-vim'
Plug 'dag/vim-fish'

call plug#end()

" disable coloring as nvim has nicer looking highlighting
" however we want the stripping of whitespaces
let g:better_whitespace_enabled=0

" show line numbers in ruler
set number

" show cursor position
set ruler

" auto indent for convenience
set autoindent
set showcmd

" search
set incsearch
set ignorecase
set smartcase

" display hidden characters
set list

" shows matching pair
set showmatch

" tab stuff
set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" highlight current line
set cursorline

" read/write file when switching buffers
set autowrite
set autoread

" copy/paste system wide
set clipboard=unnamedplus

" allows to undo after quitting files
set undofile
set undodir=/tmp

" complete longest in wildmenu with tab
set wildmode=list:longest,full

" Open buffers to right and below
set splitbelow
set splitright

" Split window vertically with |
map <Bar> <C-W>v<C-W><Right>

" Split window horizontally with _
map _ <C-W>s<C-W><Down>

" leader mappings
let mapleader="\<SPACE>"

" Search and Replace
nmap <Leader>s :%s//g<Left><Left>

" Toggle between normal and relative numbering.
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

" Key mappings
nnoremap <leader>tn :call NumberToggle()<cr>
nnoremap <leader>sw :StripWhitespace<cr>
nnoremap <leader>o :FZF<cr>
nnoremap <C-p> :FZF<cr>
nnoremap <leader>d yyp
nnoremap <leader>k dd
nnoremap <leader>l :nohlsearch<cr>
nnoremap <leader>Q :q!<cr>
nnoremap <C-q> :q<cr>
nnoremap <C-s> :w<cr>
"" better movement for wrapped lines
nnoremap <up> gk
nnoremap <down> gj
nnoremap k gk
nnoremap j gj
"" move lines
noremap <M-up> :m -2<CR>
inoremap <M-up> <Esc>:m -2<CR>i
noremap <M-down> :m +1<CR>
inoremap <M-down> <Esc>:m +1<CR>i
" next/previous buffers
nmap <silent> ]b :bnext<cr>
nmap <silent> [b :bprev<cr>
" next/previous cursors
nmap <silent> <C-A-left> <C-o>
nmap <silent> <C-A-right> <C-i>

" Use ';' for commands.
nnoremap ; :

" copy current word
nnoremap <silent> <leader>cw vey
" paste last yank in insert mode
inoremap <silent> <C-v> <Esc>pa

