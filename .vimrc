" ******* Color theme *******
set t_Co=256
set term=screen-256color
set cursorline
colorscheme onehalfdark
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
syntax on

:set nu
:set ai
:set cursorline
:set incsearch
:set expandtab
:set tabstop=4
:set mouse=" "
:set hlsearch

" insert a virtual space to the right of the last char (in normal mode)
set virtualedit+=onemore

" For showing the tab character
:set list
:set listchars=tab:>-

" For showing extra space
:highlight ExtraWhiteSpace ctermbg=red guibg=red
:match ExtraWhiteSpace /\s\+$/


" Change leader to space
let mapleader = " "
nnoremap <SPACE> <Nop>

" Hot key for insert mode
:inoremap ( ()<Esc>i
:inoremap {} {}<Esc>i
:inoremap {<CR> {<CR>}<Esc>ko
:inoremap " ""<Esc>i
:inoremap [ []<Esc>i
:inoremap ' ''<Esc>i
" Press Ctrl + d to update the file
:inoremap <C-d> <Esc>:up<CR>
" Set for vim-Clangformat
xnoremap <C-c> :ClangFormat<CR>

" Set the toggle of highlight
nmap <leader>sh :set hlsearch!<CR>

" Set the toggle of mouse
function! ToggleMouse()
    if &mouse == ''
        let &mouse='a'
    else
        let &mouse=''
    endif
endfunction
nnoremap <leader>sm :call ToggleMouse()<cr>

" Set the function of vimgrep
" vimgrep will use quickfix. Therefore, I setup the configuration for qucikfix
let g:search_pattern = ' '

function! QuickFixHighLight()
    if &buftype ==# 'quickfix'
        " The 'cwindow' is fine to be  executed again in quickfix
        execute "call EnterQuickFix()"
    endif
endfunction

" Enter the quickfix and highlight the search pattern
function! EnterQuickFix()
    execute "cwindow"
    execute "highlight pattern ctermbg=39"
    execute "match pattern /". g:search_pattern. "/"
endfunction

" Set up tje search_pattern and execute the vimgrep. Then enter the quickfix
function! VimGrepCurrentFile(cmd, pattern)
    if a:cmd == 'normal'
        let g:search_pattern = a:pattern
    elseif a:cmd == 'gd'
        let word = expand("<cword>")
        let g:search_pattern = '\<'.escape(word, '\'). '\>'
    endif
    execute "vimgrep /". g:search_pattern."/ %"
    execute "call EnterQuickFix()"
endfunction
nmap <leader>gp :call VimGrepCurrentFile("normal", "")<left><left>
nmap <leader>gd :call VimGrepCurrentFile("gd", "")<cr>

" ********* QuickFix  *********
nmap <leader>gc :cclose<cr>
nmap <leader>go :call EnterQuickFix()<cr>

" Set the toggle of line number
nmap <leader>sn :set nu!<CR>

" Tab switch
:nmap <TAB> :tabn<CR>
:nmap <S-TAB> :tabp<CR>

" window switch
:nmap <leader>h :wincmd h<CR>:call QuickFixHighLight()<CR>
:nmap <leader>l :wincmd l<CR>:call QuickFixHighLight()<CR>
:nmap <leader>j :wincmd j<CR>:call QuickFixHighLight()<CR>
:nmap <leader>k :wincmd k<CR>:call QuickFixHighLight()<CR>

" Color configuration
hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
hi CursorLineNr cterm=bold ctermfg=Green ctermbg=NONE

au BufNewFile,BufRead * if &syntax == '' | set syntax=C | endif

" include cscope configuration
source ~/.vim/.cscope_config


" Plugins
:set rtp+=~/.vim/bundle/nerdtree
:set rtp+=~/.vim/bundle/vim-clang-format
":set rtp+=~/.vim/bundle/YouCompleteMe
:set rtp+=~/.vim/bundle/vim-airline
:set rtp+=~/.vim/bundle/supertab

" ****** supertab Setting ******

let g:SuperTabDefaultCompletionType = "<c-n>"


" ****** NERDTree Setting ******
" Opens (or reopens) the NERDTree if it is not currently visible;
" otherwise, the cursor is moved to the already-open NERDTree.
nnoremap <leader>no :NERDTree<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
" Without the optional argument, find and reveal the file for the active
" buffer in the NERDTree window.  With the <path> argument, find and
" reveal the specified path.

nnoremap <leader>nf :NERDTreeFind<CR>

" Shift + i can toggle this setting.
let NERDTreeShowHidden=1
let NERDTreeCustomOpenArgs={'file':{'where': 't'}}

" Execute the match
autocmd BufEnter * :match ExtraWhiteSpace /\s\+$/
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


" ****** YCM Setting ******

let g:ycm_python_binary_path='Users/shane/python/bin/python3'
let g:ycm_global_ycm_extra_conf = "/Users/shane/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"
let g:ycm_enable_diagnostic_highlighting = 1
inoremap <C-Space> <C-x><C-o>

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

" ******* Other setting *******

" Let the backspace work fine
set backspace=indent,eol,start

" When open a file, set the cursor at the line same as last time.
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \| exe "normal! g'\"" | endif
endif
:set spell spelllang=en_us
hi clear SpellBad
hi SpellBad cterm=underline,bold
