" Basic setting of vim
source ~/.vim/.vim_basic

source ~/.vim/.vim_func

source ~/.vim/.vim_keymap

source ~/.vim/.vim_nerdtree

source ~/.vim/.vim_coc

source ~/.vim/.vim_color

" include cscope configuration
source ~/.vim/.cscope_config

" Plugins
:set rtp+=~/.vim/bundle/nerdtree
:set rtp+=~/.vim/bundle/vim-clang-format
:set rtp+=~/.vim/bundle/vim-airline
" :set rtp+=~/.vim/bundle/supertab
:set rtp+=~/.vim/bundle/taboverflow
:set rtp+=~/.vim/bundle/vim-smoothie

" ****** supertab Setting ******

let g:SuperTabDefaultCompletionType = "<c-n>"

" ****** Airline Setting ******
set noshowmode
let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ ''     : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ ''     : 'V',
    \ }
let g:vimspector_enable_mappings = 'HUMAN'
" packadd! vimspector
syntax enable
filetype plugin indent on
