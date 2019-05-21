" vim: set foldmethod=marker foldlevel=0 nomodeline:
" =============================================================================
" .vimrc of zhanghaifeng
" =============================================================================


" Vim 8 Defaults
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

" =============================================================================
" VIM-PLUG {{{
" =============================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif
silent! if plug#begin('~/.vim/bundle')

" -----------------------------------------------------------------------------
" Colors
" -----------------------------------------------------------------------------
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'

" Rainbow parentheses
Plug 'junegunn/rainbow_parentheses.vim'

" -----------------------------------------------------------------------------
" Edit
" -----------------------------------------------------------------------------
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tomtom/tcomment_vim' " Comment: gcc gcu gcap
Plug 'vim-scripts/ReplaceWithRegister' " gr
Plug 'AndrewRadev/splitjoin.vim'
Plug 'mbbill/undotree'
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<CR>
if exists('##TextYankPost')
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 100
endif

" -----------------------------------------------------------------------------
" Browsing
" -----------------------------------------------------------------------------
Plug 'majutsushi/tagbar'
let g:tagbar_sort = 0
nnoremap <F2> :Tagbar<CR>
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" -----------------------------------------------------------------------------
" Git
" -----------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
if v:version >= 703
  Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = ['git']
  let g:signify_sign_add          = '│'
  let g:signify_sign_change       = '│'
  let g:signify_sign_changedelete = '│'
  let g:signify_sign_delete       = '│'
  let g:signify_sign_delete_first_line = '‾'
endif

" -----------------------------------------------------------------------------
" Lang
" -----------------------------------------------------------------------------
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" -----------------------------------------------------------------------------
" Completion
" -----------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

" -----------------------------------------------------------------------------
" Lint
" -----------------------------------------------------------------------------
Plug 'w0rp/ale'

call plug#end()

endif

" }}}

" =============================================================================
" BASIC SETTINGS {{{
" =============================================================================
let mapleader=' '
let maplocalleader=' '

augroup vimrc
  autocmd!
augroup END

set number
set relativenumber
set autoindent
set smartindent
set lazyredraw
set laststatus=2
set showcmd
set visualbell
set backspace=indent,eol,start
set timeoutlen=500
set whichwrap=b,s
set shortmess=aIT
set hlsearch " CTRL-L / CTRL-R W
set incsearch
set hidden
set ignorecase
set smartcase
set wildmenu
set wildmode=full
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set scrolloff=5
set encoding=utf-8
set list
set listchars=tab:\|\ ,
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set autoread
set clipboard=unnamed
set foldlevelstart=99
set grepformat=%f:%l:%c:%m,%f:%l:%m
set completeopt=menuone,preview
set nocursorline
set nrformats=hex
silent! set cryptmethod=blowfish2

set formatoptions+=1
if has('patch-7.3.541')
  set formatoptions+=j
endif
if has('patch-7.4.338')
  let &showbreak = '↳ '
  set breakindent
  set breakindentopt=sbr
endif

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

set modelines=2
set synmaxcol=1000

" For MacVim
set noimd
set imi=1
set ims=-1

" ctags
set tags=./tags;/

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.
if v:version >= 703
  set undodir=/tmp//,.
endif

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" set complete=.,w,b,u,t
set complete-=i

" mouse
silent! set ttymouse=xterm2
set mouse=a

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

" FOOBAR=~/<CTRL-><CTRL-F>
set isfname-==

if exists('&fixeol')
  set nofixeol
endif

if has('gui_running')
  set guifont=Menlo:h14 columns=80 lines=40
  silent! colo seoul256-light
else
  silent! colo seoul256
endif

if has('nvim')
  " https://github.com/neovim/neovim/issues/2897#issuecomment-115464516
  let g:terminal_color_0 = '#4e4e4e'
  let g:terminal_color_1 = '#d68787'
  let g:terminal_color_2 = '#5f865f'
  let g:terminal_color_3 = '#d8af5f'
  let g:terminal_color_4 = '#85add4'
  let g:terminal_color_5 = '#d7afaf'
  let g:terminal_color_6 = '#87afaf'
  let g:terminal_color_7 = '#d0d0d0'
  let g:terminal_color_8 = '#626262'
  let g:terminal_color_9 = '#d75f87'
  let g:terminal_color_10 = '#87af87'
  let g:terminal_color_11 = '#ffd787'
  let g:terminal_color_12 = '#add4fb'
  let g:terminal_color_13 = '#ffafaf'
  let g:terminal_color_14 = '#87d7d7'
  let g:terminal_color_15 = '#e4e4e4'

  set fillchars=vert:\|,fold:-
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif

" }}}

" =============================================================================
" MAPPINGS {{{
" =============================================================================

" -----------------------------------------------------------------------------
" Basic mappings
" -----------------------------------------------------------------------------
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap Y y$
vnoremap < <gv
vnoremap > >gv
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap Q :qa!<CR>

" Last inserted text
nnoremap g. :normal! `[v`]<cr><left>

" -----------------------------------------------------------------------------
" Windows
" -----------------------------------------------------------------------------
nnoremap <S-tab> <c-w>W
nnoremap <tab> <C-w>w
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

" -----------------------------------------------------------------------------
" Quickfix
" -----------------------------------------------------------------------------
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" -----------------------------------------------------------------------------
" Buffers
" -----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" -----------------------------------------------------------------------------
" Tabs
" -----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" -----------------------------------------------------------------------------
" <tab> / <s-tab> / <c-v><tab> | super-duper-tab
" -----------------------------------------------------------------------------
function! s:can_complete(func, prefix)
  if empty(a:func)
    return 0
  endif
  let start = call(a:func, [1, ''])
  if start < 0
    return 0
  endif

  let oline  = getline('.')
  let line   = oline[0:start-1] . oline[col('.')-1:]

  let opos   = getpos('.')
  let pos    = copy(opos)
  let pos[2] = start + 1

  call setline('.', line)
  call setpos('.', pos)
  let result = call(a:func, [0, matchstr(a:prefix, '\k\+$')])
  call setline('.', oline)
  call setpos('.', opos)

  if !empty(type(result) == type([]) ? result : result.words)
    call complete(start + 1, result)
    return 1
  endif
  return 0
endfunction

function! s:feedkeys(k)
  call feedkeys(a:k, 'n')
  return ''
endfunction

function! s:super_duper_tab(pumvisible, next)
  let [k, o] = a:next ? ["\<c-n>", "\<tab>"] : ["\<c-p>", "\<s-tab>"]
  if a:pumvisible
    return s:feedkeys(k)
  endif

  let line = getline('.')
  let col = col('.') - 2
  if line[col] !~ '\k\|[/~.]'
    return s:feedkeys(o)
  endif

  let prefix = expand(matchstr(line[0:col], '\S*$'))
  if prefix =~ '^[~/.]'
    return s:feedkeys("\<c-x>\<c-f>")
  endif
  if s:can_complete(&omnifunc, prefix) || s:can_complete(&completefunc, prefix)
    return ''
  endif
  return s:feedkeys(k)
endfunction

inoremap <silent> <tab>   <c-r>=<SID>super_duper_tab(pumvisible(), 1)<cr>
inoremap <silent> <s-tab> <c-r>=<SID>super_duper_tab(pumvisible(), 0)<cr>

" TBD
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" -----------------------------------------------------------------------------
" <Leader>c Close quickfix/location window
" -----------------------------------------------------------------------------
nnoremap <leader>c :cclose<bar>lclose<cr>

" -----------------------------------------------------------------------------
" #gi / #gpi | go to next/previous indentation level
" -----------------------------------------------------------------------------
function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction
nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

" }}}

" =============================================================================
" FUNCTIONS & COMMANDS {{{
" =============================================================================

" -----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" -----------------------------------------------------------------------------
function! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root()

" -----------------------------------------------------------------------------
" Todo
" -----------------------------------------------------------------------------
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -niI -e TODO -e FIXME 2> /dev/null',
        \ 'grep -rniI -e TODO -e FIXME * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()

" -----------------------------------------------------------------------------
" co? : Toggle options (inspired by unimpaired.vim)
" -----------------------------------------------------------------------------
function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('t', 'textwidth',
      \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:map_change_option('b', 'background',
      \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

" }}}

" =============================================================================
" PLUGINS {{{
" =============================================================================

" -----------------------------------------------------------------------------
" vim-plug extension
" -----------------------------------------------------------------------------
function! s:plug_gx()
  let line = getline('.')
  let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
  let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
        \ : getline(search('^- .*:$', 'bn'))[2:-2]
  let uri  = get(get(g:plugs, name, {}), 'uri', '')
  if uri !~ 'github.com'
    return
  endif
  let repo = matchstr(uri, '[^:/]*/'.name)
  let url  = empty(sha) ? 'https://github.com/'.repo
        \ : printf('https://github.com/%s/commit/%s', repo, sha)
  call netrw#BrowseX(url, 0)
endfunction

function! s:scroll_preview(down)
  silent! wincmd P
  if &previewwindow
    execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
    wincmd p
  endif
endfunction

function! s:plug_doc()
  let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
  if has_key(g:plugs, name)
    for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
      execute 'tabe' doc
    endfor
  endif
endfunction

function! s:setup_extra_keys()
  " PlugDiff
  nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
  nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
  nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
  nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
  nmap <silent> <buffer> <c-j> <c-n>o
  nmap <silent> <buffer> <c-k> <c-p>o

  " gx
  nnoremap <buffer> <silent> gx :call <sid>plug_gx()<cr>

  " helpdoc
  nnoremap <buffer> <silent> H  :call <sid>plug_doc()<cr>
endfunction

autocmd vimrc FileType vim-plug call s:setup_extra_keys()

let g:plug_window = '-tabnew'
let g:plug_pwindow = 'vertical rightbelow new'

" -----------------------------------------------------------------------------
" <Enter> | vim-easy-align
" -----------------------------------------------------------------------------
let g:easy_align_delimiters = {
      \ '>': { 'pattern': '>>\|=>\|>' },
      \ '\': { 'pattern': '\\' },
      \ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
      \ ']': {
      \     'pattern':       '\]\zs',
      \     'left_margin':   0,
      \     'right_margin':  1,
      \     'stick_to_left': 0
      \   },
      \ ')': {
      \     'pattern':       ')\zs',
      \     'left_margin':   0,
      \     'right_margin':  1,
      \     'stick_to_left': 0
      \   },
      \ 'f': {
      \     'pattern': ' \(\S\+(\)\@=',
      \     'left_margin': 0,
      \     'right_margin': 0
      \   },
      \ 'd': {
      \     'pattern': ' \ze\S\+\s*[;=]',
      \     'left_margin': 0,
      \     'right_margin': 0
      \   }
      \ }

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap ga <Plug>(EasyAlign)
nmap gaa ga_

xmap <Leader>ga   <Plug>(LiveEasyAlign)

" -----------------------------------------------------------------------------
" splitjoin
" -----------------------------------------------------------------------------
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap gss :SplitjoinSplit<cr>
nnoremap gsj :SplitjoinJoin<cr>

" -----------------------------------------------------------------------------
" defx
" -----------------------------------------------------------------------------
call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'toggle': 1,
      \ 'resume': 1
      \ })
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
        \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
        \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
        \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
        \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
        \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
        \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
        \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
        \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
        \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd')
endfunction
nnoremap <F3> :Defx<CR>
augroup defx_loader
  autocmd!
  autocmd VimEnter * Defx
  autocmd BufEnter * if (!has('vim_starting') && winnr('$') == 1 && &filetype ==# 'defx') | q | endif
augroup END

" -----------------------------------------------------------------------------
" fzf
" -----------------------------------------------------------------------------
if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <Leader>f        :Files<CR>
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>L        :Lines<CR>
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(<q-args>,
      \                 <bang>0 ? fzf#vim#with_preview('up:60%')
      \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \                 <bang>0)
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
      \ 'source': sort(keys(g:plugs)),
      \ 'sink':   function('s:plug_help_sink')}))

" -----------------------------------------------------------------------------
" vim-fugitive
" -----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" -----------------------------------------------------------------------------
" gv.vim / gl.vim
" -----------------------------------------------------------------------------
function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

" -----------------------------------------------------------------------------
" vim-go
" -----------------------------------------------------------------------------
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = {
      \ 'goimports': '-local do/',
      \ }

let g:go_debug_windows = {
      \ 'vars':  'leftabove 35vnew',
      \ 'stack': 'botright 10new',
      \ }


let g:go_test_prepend_name = 1
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0
let g:go_auto_sameids = 0
let g:go_info_mode = "gopls"

let g:go_def_mode = "gopls"
let g:go_echo_command_info = 1
let g:go_autodetect_gopath = 1
" let g:go_metalinter_autosave_enabled = ['vet', 'golint']
" let g:go_metalinter_enabled = ['vet', 'golint']

let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 0
let g:go_highlight_build_constraints = 1
let g:go_highlight_types = 0
let g:go_highlight_operators = 1
let g:go_highlight_format_strings = 0
let g:go_highlight_function_calls = 0
let g:go_gocode_propose_source = 1

let g:go_modifytags_transform = 'camelcase'
let g:go_fold_enable = []

" Open :GoDeclsDir with ctrl-g
nnoremap <C-g> :GoDeclsDir<cr>
inoremap <C-g> <esc>:<C-u>GoDeclsDir<cr>

" -----------------------------------------------------------------------------
" ALE
" -----------------------------------------------------------------------------
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'java': [],
      \ 'yaml': [],
      \ 'scala': [],
      \'clojure': [],
      \ 'go': ['golint', 'go vet'],
      \ }
let g:ale_fixers = {'ruby': ['rubocop']}
let g:ale_open_list = 1
let g:ale_lint_delay = 1000

nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)

" }}}

" =============================================================================
" AUTOCMD {{{
" =============================================================================
augroup vimrc
  " File types
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile

  au FileType markdown,text setlocal wrap
  au FileType yaml,vim setlocal expandtab shiftwidth=2 softtabstop=2
  au FileType c,cpp,java,javascript,python,rust,go RainbowParentheses

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

  " Close preview window
  if exists('##CompleteDone')
    au CompleteDone * pclose
  else
    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
  endif
augroup END

" -----------------------------------------------------------------------------
" Help in new tabs
" -----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
autocmd vimrc BufEnter *.txt call s:helptab()

" }}}

" =============================================================================
" LOCAL VIMRC {{{
" =============================================================================
let s:local_vimrc = fnamemodify(resolve(expand('<sfile>')), ':p:h').'/vimrc-extra'
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif

" }}}
