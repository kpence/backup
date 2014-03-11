"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO Make map that enters paste mode then leaves it
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color characters after 128/140 lines
" set cc=140
" hi ColorColumn ctermbg=grey


" Add epub reading capability
au BufReadCmd   *.epub      call zip#Browse(expand("<amatch>"))

" Other custom mappings
nnoremap gm :call cursor(0, len(getline('.'))/2)<cr>
let g:EasyMotion_leader_key = '<c-s>'
imap <silent> <C-f> <C-o>l
imap <silent> <C-b> <C-o>h
imap <silent> <C-d> <C-o>dl
imap <silent> <C-e> <C-o>$
imap <silent> <C-a> <C-o>1\|
imap <silent> <C-n> <C-o>j
imap <silent> <C-p> <C-o>k
imap <silent> <C-k> <C-o>d$
imap <silent> <C-l> <C-o><C-l><C-h>
inoremap <silent> <C-y> <C-r>+
" Normal AND UNMAPPED
"map <silent> <C-s> :w<cr>
map <silent> <C-q> l
map <silent> <C-m> l
vnoremap <C-p> mzdhP
vnoremap <C-n> dp
" imap <silent> <C-space> <space>
" Page up page down
inoremap <ESC>p <C-o><C-u>
inoremap <ESC>n <C-o><C-d>
noremap <ESC>p <C-u>
noremap <ESC>n <C-d>
" map <silent> ; l " HAVEN'T MAPPED IT BECAUSE IT COULD BE ANNOYING
" nmap <silent> <c-a> <>
" imap <silent> <a-u> <c-w>
" imap <silent> <c-y> <c-o><c-y>
" imap <silent> <c-y> <c-o><c-y>
" Disable help key
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>
" NetRW
" Toggle Vexplore with Ctrl-S
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
" map <silent> <C-s> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Default to tree mode
let g:netrw_liststyle=3

" Change directory to the current buffer when opening files.
set autochdir
"
" TODO make this put the xselection clipboard in the yank clipboard, enter paste mode, paste, and exit paste mode: imap <silent> <c-y> <c-o>
" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction
" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("find . | grep -v .git | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction
" Dmenu tabs
map <C-t> :call DmenuOpen("tabe")<cr>
"map <c-s-t> :call DmenuOpen("e")<cr>
" Tab shortcuts
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-n> :tabnext<CR>
" :help statusline
set nocompatible ruler laststatus=2 showcmd showmode number cmdheight=2
" Search
set incsearch ignorecase smartcase hlsearch
" Remove useless splash screen
set shortmess+=l
" Clipboard stuff
" nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F5>
" Don't redraw while executing macros
set lazyredraw
" Tab and indent related
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
" Always show current position
set ruler
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" Enable syntax highlighting
syntax enable
" Turn on the WiLd menu
set wildmenu
set wildignore=*.o,*~,*.pyc
"Map space to search
"map <space> /
"map <c-space> ?
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Pos:\ %l,\ %c
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
" Clear highlights on ^S
noremap <silent> <c-l> :nohls<cr><c-l>
" Move a line of text with c-j/k
nmap <C-j> mz:m+<cr>`z
nmap <C-k> mz:m-2<cr>`z
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
" Helper functions
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction