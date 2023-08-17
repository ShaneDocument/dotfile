" Basic setting of vim
source ~/.vim/.vim_basic

source ~/.vim/.vim_func

source ~/.vim/.vim_keymap

source ~/.vim/.vim_nerdtree

source ~/.vim/.vim_color

" include cscope configuration
source ~/.vim/.cscope_config

" Plugins
:set rtp+=~/.vim/bundle/nerdtree
:set rtp+=~/.vim/bundle/vim-clang-format
:set rtp+=~/.vim/bundle/vim-airline
:set rtp+=~/.vim/bundle/supertab
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

" TODO "
""" Define a function to check if the buffer type is quickfix
""function! IsQuickfixBuffer()
""    return &buftype ==# 'quickfix'
"" endfunction
""" Define the custom mapping for <CR> in the quickfix buffer
""function! QuickfixEnter()
""   if IsQuickfixBuffer()
""       let l:line = getline('.')
""       let l:parts = split(l:line, '|')
""       if len(l:parts) > 1 && filereadable(l:parts[0])
""           execute "normal! <C-W>w"
""           execute 'tabnew ' . l:parts[0]
""       endif
""   else
""       return "\<CR>"
""   endif
""endfunction
""
""" Map <CR> in normal mode to call the QuickfixEnter function
""nnoremap <expr> <CR> QuickfixEnter()
