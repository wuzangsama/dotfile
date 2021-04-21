" vim: set foldmethod=marker foldlevel=0 nomodeline:
" =============================================================================
" .vimrc of zhanghaifeng
" =============================================================================

if &compatible | set nocompatible | endif
syntax enable
syntax on
filetype plugin indent on

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
Plug 'machakann/vim-highlightedyank'
Plug 'jiangmiao/auto-pairs'
Plug 'editorconfig/editorconfig-vim'

" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'

" -----------------------------------------------------------------------------
" Browsing
" -----------------------------------------------------------------------------
Plug 'majutsushi/tagbar'
Plug 'Shougo/vinarise.vim'
Plug 'shougo/vimfiler.vim'
Plug 'Shougo/unite.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" -----------------------------------------------------------------------------
" Git
" -----------------------------------------------------------------------------
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-signify'

" -----------------------------------------------------------------------------
" Lang
" -----------------------------------------------------------------------------
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}

" -----------------------------------------------------------------------------
" Completion
" -----------------------------------------------------------------------------
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'

" -----------------------------------------------------------------------------
" Lint
" -----------------------------------------------------------------------------
Plug 'dense-analysis/ale'

" -----------------------------------------------------------------------------
" Wiki
" -----------------------------------------------------------------------------
" Plug 'vimwiki/vimwiki'

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

" -----------------------------------------------------------------------------
" encoding
" -----------------------------------------------------------------------------
set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" -----------------------------------------------------------------------------
" UI
" -----------------------------------------------------------------------------
silent! set number relativenumber background=dark nowrap guioptions= signcolumn=yes
silent! set ruler laststatus=2 showmode cursorline colorcolumn=80 cmdheight=2
silent! set list listchars=tab:\|\ , scrolloff=5 t_ti= t_te= shortmess+=c
silent! set mouse=a mousehide helplang=cn
if has('gui_running') | set guifont=Monaco:h13 | else | set t_Co=256 | endif
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

if has_key(g:plugs, 'seoul256.vim')
  if has('gui_running')
    set guifont=Menlo:h14
    silent! colo seoul256-light
  else
    silent! colo seoul256
  endif
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

" -----------------------------------------------------------------------------
" Edit
" -----------------------------------------------------------------------------
silent! set shiftwidth=4 expandtab tabstop=4 softtabstop=4
silent! set nofoldenable foldlevel=2 foldmethod=indent
silent! set backspace=indent,eol,start formatoptions=cmMj
silent! set tags=tags,./tags
silent! set clipboard=unnamed clipboard+=unnamedplus
silent! set hidden

" -----------------------------------------------------------------------------
" Search
" -----------------------------------------------------------------------------
silent! set ignorecase smartcase incsearch hlsearch magic

" -----------------------------------------------------------------------------
" Command
" -----------------------------------------------------------------------------
silent! set wildmenu wildmode=list:longest
silent! set wildignore=*.~,*.?~,*.sw?,*.bak,*.hi,*.pyc,*.out,*.lock,*.DS_Store
silent! set wildignore+=.hg,.git,.svn
silent! set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
silent! set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.manifest

" -----------------------------------------------------------------------------
" Performance
" -----------------------------------------------------------------------------
silent! set updatetime=300 timeout timeoutlen=500 ttimeout ttimeoutlen=50 ttyfast lazyredraw

" -----------------------------------------------------------------------------
" Bell
" -----------------------------------------------------------------------------
silent! set noerrorbells visualbell t_vb=

" -----------------------------------------------------------------------------
" Tmp file
" -----------------------------------------------------------------------------
" silent! set backupdir=/tmp//,. directory=/tmp//,. undodir=/tmp//,.
silent! set nobackup nowritebackup

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
if has_key(g:plugs, 'vim-easy-align')
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
endif

" -----------------------------------------------------------------------------
" splitjoin
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'splitjoin.vim')
  let g:splitjoin_split_mapping = ''
  let g:splitjoin_join_mapping = ''
  nnoremap gss :SplitjoinSplit<cr>
  nnoremap gsj :SplitjoinJoin<cr>
endif

" -----------------------------------------------------------------------------
" highlightedyank
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-highlightedyank')
  let g:highlightedyank_highlight_duration = 100
endif

" -----------------------------------------------------------------------------
" editorconfig-vim
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'editorconfig-vim')
  let g:EditorConfig_exclude_patterns = ['fugitive://.\*', 'scp://.\*']
endif


" -----------------------------------------------------------------------------
" vim-codefmt
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-codefmt')
  call glaive#Install()
  " Optional: Enable codefmt's default mappings on the <Leader>= prefix.
  Glaive codefmt plugin[mappings]
endif

" -----------------------------------------------------------------------------
" undotree
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'undotree')
  nnoremap U :UndotreeToggle<CR>
endif

" -----------------------------------------------------------------------------
" tagbar
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'tagbar')
  let g:tagbar_sort = 0
  nnoremap <F2> :Tagbar<CR>
endif

" -----------------------------------------------------------------------------
" vim-signify
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-signify')
  let g:signify_vcs_list = ['git']
  let g:signify_sign_add          = '│'
  let g:signify_sign_change       = '│'
  let g:signify_sign_changedelete = '│'
  let g:signify_sign_delete       = '│'
  let g:signify_sign_delete_first_line = '‾'
endif

" -----------------------------------------------------------------------------
" vimfiler
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_ignore_pattern = [
        \ '^\.git$',
        \ '^\.DS_Store$',
        \ '^\.init\.vim-rplugin\~$',
        \ '^\.netrwhist$',
        \ '\.class$'
        \]
  call vimfiler#custom#profile('default', 'context', {
        \ 'explorer' : 1,
        \ 'winwidth' : 30,
        \ 'winminwidth' : 30,
        \ 'toggle' : 1,
        \ 'auto_expand': 1,
        \ 'explorer_columns' : 30,
        \ 'parent': 0,
        \ 'status' : 1,
        \ 'safe' : 0,
        \ 'split' : 1,
        \ 'hidden': 1,
        \ 'no_quit' : 1,
        \ 'force_hide' : 0,
        \ 'auto_cd': 1,
        \ })

  augroup vfinit
    au!
    autocmd FileType vimfiler call s:vimfilerinit()
    autocmd vimenter * if !argc() | VimFilerExplorer | endif " 无文件打开显示vimfiler
    autocmd BufEnter * if (!has('vim_starting') && winnr('$') == 1 && &filetype ==# 'vimfiler') |
          \ q | endif
  augroup END
  function! s:vimfilerinit()
    setl nonumber
    setl norelativenumber

    silent! nunmap <buffer> <C-l>
    silent! nunmap <buffer> <C-j>

    nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
    nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
    nmap <buffer> u       <Plug>(vimfiler_smart_h)
  endf

  nnoremap <F3> :VimFilerExplorer<CR>
endif

" -----------------------------------------------------------------------------
" fzf
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'fzf.vim')
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
  nnoremap <silent> <Leader><Enter>  :Buffers<CR>
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
endif

" -----------------------------------------------------------------------------
" vim-fugitive
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-fugitive')
  nmap     <Leader>gs :Gstatus<CR>gg<c-n>
  nnoremap <Leader>gd :Gdiff<CR>
endif

" -----------------------------------------------------------------------------
" gv.vim / gl.vim
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'gv.vim')
  function! s:gv_expand()
    let line = getline('.')
    GV --name-status
    call search('\V'.line, 'c')
    normal! zz
  endfunction

  autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>
endif

" -----------------------------------------------------------------------------
" vim-go
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-go')
  let g:go_fmt_fail_silently = 1
  let g:go_fmt_command = "goimports"
  let g:go_debug_windows = {
        \ 'vars':  'leftabove 35vnew',
        \ 'stack': 'botright 10new',
  \ }

  let g:go_test_prepend_name = 1
  let g:go_list_type = "quickfix"
  let g:go_auto_type_info = 0
  let g:go_auto_sameids = 0

  let g:go_null_module_warning = 0
  let g:go_echo_command_info = 1

  let g:go_autodetect_gopath = 1
  " let g:go_metalinter_autosave_enabled = ['vet', 'golint']
  " let g:go_metalinter_enabled = ['vet', 'golint']

  let g:go_info_mode = 'gopls'
  let g:go_rename_command='gopls'
  let g:go_gopls_complete_unimported = 1
  let g:go_implements_mode='gopls'
  let g:go_diagnostics_enabled = 1
  let g:go_doc_popup_window = 1

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

  nmap <C-g> :GoDecls<cr>
  imap <C-g> <esc>:<C-u>GoDecls<cr>

  " run :GoBuild or :GoTestCompile based on the go file
  function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
      call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
      call go#cmd#Build(0)
    endif
  endfunction

  augroup go
    autocmd!

    autocmd FileType go nmap <silent> <Leader>v <Plug>(go-def-vertical)
    autocmd FileType go nmap <silent> <Leader>s <Plug>(go-def-split)
    autocmd FileType go nmap <silent> <Leader>d <Plug>(go-def-tab)

    autocmd FileType go nmap <silent> <Leader>x <Plug>(go-doc-vertical)

    autocmd FileType go nmap <silent> <Leader>i <Plug>(go-info)
    autocmd FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)

    autocmd FileType go nmap <silent> <leader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
    autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
    autocmd FileType go nmap <silent> <leader>e  <Plug>(go-install)

    autocmd FileType go nmap <silent> <Leader>c <Plug>(go-coverage-toggle)

    " I like these more!
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  augroup END
endif

" -----------------------------------------------------------------------------
" ultisnips
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'ultisnips')
  let g:UltiSnipsExpandTrigger="<C-j>"
  let g:UltiSnipsJumpForwardTrigger="<C-j>"
  let g:UltiSnipsJumpBackwardTrigger="<C-k>"
endif

" -----------------------------------------------------------------------------
" coc.nvim
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'coc.nvim')
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h' expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Highlight symbol under cursor on CursorHold
  " autocmd CursorHold * silent call CocActionAsync('highlight')

  let g:go_doc_keywordprg_enabled = 0

  " Remap keys for gotos
  nmap <silent> <C-]> <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  " gr已经被使用
  nmap <silent> gR <Plug>(coc-references)

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  autocmd FileType scss setl iskeyword+=@-@
endif

" -----------------------------------------------------------------------------
" ALE
" -----------------------------------------------------------------------------
if has_key(g:plugs,'ale')
  let g:ale_linters_explicit = 1
  let g:ale_linters = {
        \ 'go': ['gometalinter'],
        \ 'sh': ['language_server'],
        \ 'java': [],
        \ }
  let g:ale_go_gometalinter_options = '--fast'
  let g:ale_fixers = {'ruby': ['rubocop']}
  let g:ale_open_list = 1
  let g:ale_lint_delay = 1000

  nmap ]a <Plug>(ale_next_wrap)
  nmap [a <Plug>(ale_previous_wrap)
endif

" }}}

" =============================================================================
" AUTOCMD {{{
" =============================================================================
augroup vimrc
  " File types
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile

  au FileType markdown,text setlocal wrap
  au FileType yaml,vim,c,cpp setlocal expandtab shiftwidth=2 softtabstop=2

  if has_key(g:plugs, 'rainbow_parentheses.vim')
    au FileType c,cpp,java,javascript,python,rust,go RainbowParentheses
  endif

  if has_key(g:plugs, 'vim-codefmt')
    " autocmd FileType bzl AutoFormatBuffer buildifier
    " autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
    autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
    autocmd FileType vue AutoFormatBuffer prettier
  endif

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

  " 自动切换路径
  " autocmd BufEnter * silent! lcd %:p:h

  " Close preview window
  if exists('##CompleteDone')
    autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
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
