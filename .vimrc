source plugins.vim

" See :h buffer-hidden, :h 'hidden'
set hidden

" Allow backspacing in insert mode.
set backspace=indent,eol,start

" indentation = 2 spaces
set tabstop=2 shiftwidth=2 expandtab
" For .go files, indentation = 4 spaces, and don't convert Tabs to spaces.
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab

" When displaying wrapped lines, break at reasonable characters (like space)
" rather than in the middle of a word. See also :h 'breakat'.
set linebreak

" line numbering
set number

" Highlight the current line. Makes airblade/vim-gitgutter easier to read.
set cursorline

" Highlight next match while typing a search command.
" Makes it easier to use / and ? as general purpose navigation commands.
set incsearch

" syntax highlighting
syntax enable

" Set background before changing the colorscheme or highlighting.
" Vim does unexpected things when this option changes, like reloading the
" colorscheme and modifying highlight groups. See :h 'background'.
set background=dark

colorscheme solarized
" Solarized's sign column highlighting makes gitgutter hard to read.
" See https://github.com/airblade/vim-gitgutter/issues/164
hi clear SignColumn

" Highlight DiffText same as DiffChange to make diffs more readable.
hi! link DiffText DiffChange

" configure vim_current_word
let g:vim_current_word#highlight_delay = 400
let g:vim_current_word#highlight_current_word = 0
