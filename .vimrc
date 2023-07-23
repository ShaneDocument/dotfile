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

" Set the toggle of line number
nmap <leader>sn :set nu!<CR>

" Set the toggle of mouse
function! ToggleMouse()
    if &mouse == ''
        let &mouse='a'
    else
        let &mouse=''
    endif
endfunction
nnoremap <leader>sm :call ToggleMouse()<cr>

" Set the function for vimgrep
" vimgrep will use quickfix. Therefore, I setup the configuration for qucikfix
let g:search_pattern = ''
let g:winview = ''

" Enter the quickfix and highlight the search pattern
function! EnterQuickFix()
    if &buftype != 'quickfix'
    " Save the view of original window. It's used in QuickMoveHighlight
        let g:winview = winsaveview()
    endif
    execute "copen"
    execute "call QuickFixPatternHighlight()"
endfunction

function! QuickFixPatternHighlight()
    if &buftype == 'quickfix'
        execute "highlight pattern ctermbg=39"
        execute "match pattern /". g:search_pattern. "/"
    endif
endfunction

" Set up the search_pattern and execute the vimgrep. Then enter the quickfix
function! VimGrepCurrentFile(cmd, pattern, file)
    if a:cmd == 'normal'
        let g:search_pattern = a:pattern
    elseif a:cmd == 'gd'
        let word = expand("<cword>")
        let g:search_pattern = '\<'.escape(word, '\'). '\>'
    endif
    execute "vimgrep /". g:search_pattern."/j" . a:file
    execute "call EnterQuickFix()"
endfunction
nmap <leader>gp :call VimGrepCurrentFile("normal", "", " %")<left><left><left><left><left><left><left><left>
nmap <leader>gd :call VimGrepCurrentFile("gd", "", " %")<cr>

" Search the text for current folder
nmap <leader>ap :call VimGrepCurrentFile("normal", "", " *")<left><left><left><left><left><left><left><left>
nmap <leader>ag :call VimGrepCurrentFile("gd", "", " *")<cr>

" ********* QuickFix  *********
nmap <leader>gc :cclose<cr>
nmap <leader>go :call EnterQuickFix()<cr>

" Navigate the whole-line highlight in quickfix
function! QuickFixMoveHighlight(cmd)
    try
        execute a:cmd
        execute "normal! \<C-O>"
    catch
    endtry
    execute "call EnterQuickFix()"
endfunction
nnoremap <expr> j &buftype ==# 'quickfix' ? ":call QuickFixMoveHighlight('cnext')<CR>" : "j"
nnoremap <expr> k &buftype ==# 'quickfix' ? ":call QuickFixMoveHighlight('cprev')<CR>" : "k"

" window switch - Highlight for quickfix
:nmap <leader>h :wincmd h<CR>:call QuickFixPatternHighlight()<CR>
:nmap <leader>l :wincmd l<CR>:call QuickFixPatternHighlight()<CR>
:nmap <leader>j :wincmd j<CR>:call QuickFixPatternHighlight()<CR>
:nmap <leader>k :wincmd k<CR>:call QuickFixPatternHighlight()<CR>



" Tab switch
:nmap <TAB> :tabn<CR>
:nmap <S-TAB> :tabp<CR>


" window create
:nmap <leader>w- :split<CR>
:nmap <leader>w/ :vsplit<CR>

" Color configuration
hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
hi CursorLineNr cterm=bold ctermfg=Green ctermbg=NONE

au BufNewFile,BufRead * if &syntax == '' | set syntax=C | endif

" include cscope configuration
source ~/.vim/.cscope_config


" Plugins
:set rtp+=~/.vim/bundle/nerdtree
:set rtp+=~/.vim/bundle/vim-clang-format
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

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


" Vim like file explorer
let NERDTreeMapUpdir = 'h'
let NERDTreeMapChangeRoot = 'l'

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

" Execute the match
autocmd BufEnter,WinEnter * :match ExtraWhiteSpace /\s\+$/

" Show file name even only one file is opened
set showtabline=2

" Only shows filename in the tab
set tabline=%!MyTabLine()
function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        let buflist = tabpagebuflist(i + 1)
        let winnr = tabpagewinnr(i + 1)
        let s .= '%' . (i + 1) . 'T'
        let s .= (i + 1 == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' '  . fnamemodify(bufname(buflist[winnr - 1]), ':t') . ' '
    endfor
    let s .= '%T%#TabLineFill#%= '
    return s
endfunction
