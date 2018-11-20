set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'mhinz/vim-signify'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'airblade/vim-rooter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'dracula/vim'

call vundle#end()
filetype plugin indent on

" General

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set laststatus=2                "Always display the status line
set hidden                      "Hide buffer instead of closing it
set pastetoggle=<F2>            "Paste without being smart

" Swap file and backups

set noswapfile
set nobackup
set nowb
au FocusLost * :wa

" Persistent undo

if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" Indentation

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Wrapping

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" Folding

set nofoldenable                "don't fold by default
set foldmethod=syntax           "fold based on syntax

" " Search

set hlsearch
set incsearch
set ignorecase
set showmatch
set smartcase

" " Terminal

set termencoding=utf-8

" " Colors

syntax on
set cursorline
set background=dark
" let g:solarized_termcolors=256
colorscheme dracula
highlight clear SignColumn

" " Scrolling

set scrolloff=4
set sidescrolloff=15
set sidescroll=1

" Fix syntax highlighting issues
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" Write with sudo
cmap wi! %!sudo tee > /dev/null %

" Turn off search highlight
nnoremap <leader>a :noh<CR>

" Syntastic

let g:syntastic_mode_map = {
\ "mode": "active",
\ "active_filetypes": ["c", "cpp", "java", "javascript", "python", "ruby"],
\ "passive_filetypes": [] }

" NERDTree

"" Open NERDTree if no files were specified when vim was executed
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"" Shortcut for toggling NERDTree
noremap <C-n> :NERDTreeToggle<CR>

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

"" FZF config
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
noremap <C-o> :call Fzf_dev()<CR>

" Files
function! Fzf_dev()
  let l:fzf_files_options = '--preview "bat --theme="OneHalfDark" --style=numbers,changes --color always {} | head -'.&lines.'"'

  function! s:files()
    return split(system($FZF_DEFAULT_COMMAND), '\n')
  endfunction

  function! s:edit_file(item)
    execute 'silent e' a:item
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction

let g:lightline = {
  \   'colorscheme': 'Dracula',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ]
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }

let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ ['close'] ]
  \ }
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

