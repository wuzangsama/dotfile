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
Plug 'Chiel92/vim-autoformat'

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
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'vim-scripts/DoxygenToolkit.vim', { 'for': ['c', 'cpp'] }
Plug 'lyuts/vim-rtags', { 'for': ['c', 'cpp'] }
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}

" -----------------------------------------------------------------------------
" Completion
" -----------------------------------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" -----------------------------------------------------------------------------
" Lint
" -----------------------------------------------------------------------------
Plug 'dense-analysis/ale'

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

  " Open :GoDeclsDir with ctrl-g
  nnoremap <C-g> :GoDeclsDir<cr>
  inoremap <C-g> <esc>:<C-u>GoDeclsDir<cr>
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
" vim-cpp-enhanced-highlight
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_posix_standard = 1
  let g:cpp_experimental_simple_template_highlight = 1
  let g:cpp_concepts_highlight = 1
  let g:cpp_no_function_highlight = 1
  let c_no_curly_error=1
endif

" -----------------------------------------------------------------------------
" DoxygenToolkit
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'DoxygenToolkit.vim')
  let g:DoxygenToolkit_authorName="zhanghf@zailingtech.com"
  let g:DoxygenToolkit_versionString="1.0"
  nnoremap <leader>da <ESC>gg:DoxAuthor<CR>
  nnoremap <leader>df <ESC>:Dox<CR>
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

  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h' expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  nnoremap <silent> K :call <SID>show_documentation()<CR>

  let g:go_doc_keywordprg_enabled = 0

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  augroup coc-config
    autocmd!
    autocmd VimEnter * nmap <silent> gd <Plug>(coc-definition)
  augroup END
endif

" -----------------------------------------------------------------------------
" vim-rtags
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'vim-rtags')
  let g:rtagsUseDefaultMappings=0

  augroup cpprtags
    autocmd!
    autocmd FileType c,cpp nnoremap <silent> <localleader>ri :call rtags#SymbolInfo()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rj :call rtags#JumpTo(g:SAME_WINDOW)<CR>
    autocmd FileType c,cpp nnoremap <silent> <Ctrl-]> :call rtags#JumpTo(g:SAME_WINDOW)<CR>
    autocmd FileType c,cpp nnoremap <silent> gd :call rtags#JumpTo(g:SAME_WINDOW)<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rJ :call rtags#JumpTo(g:SAME_WINDOW, { '--declaration-only' : '' })<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rS :call rtags#JumpTo(g:H_SPLIT)<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rV :call rtags#JumpTo(g:V_SPLIT)<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rT :call rtags#JumpTo(g:NEW_TAB)<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rp :call rtags#JumpToParent()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rf :call rtags#FindRefs()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rF :call rtags#FindRefsCallTree()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rn :call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rs :call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rr :call rtags#ReindexFile()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rl :call rtags#ProjectList()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rw :call rtags#RenameSymbolUnderCursor()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rv :call rtags#FindVirtuals()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rb :call rtags#JumpBack()<CR>
    autocmd FileType c,cpp nnoremap <silent> <Ctrl-t> :call rtags#JumpBack()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rC :call rtags#FindSuperClasses()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rc :call rtags#FindSubClasses()<CR>
    autocmd FileType c,cpp nnoremap <silent> <localleader>rd :call rtags#Diagnostics()<CR>
  augroup END
endif

" -----------------------------------------------------------------------------
" ALE
" -----------------------------------------------------------------------------
if has_key(g:plugs,'ale')
  let g:ale_linters_explicit = 1
  let g:ale_linters = {
        \ 'go': ['golint', 'go vet'],
        \ 'cpp': ['clang-format','clangcheck'],
        \ 'c': ['clang-format','clangtidy'],
        \ 'sh': ['language_server'],
        \ }
  let g:ale_cpp_clang_options='-std=c++11 -Wall'
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
  au FileType yaml,vim setlocal expandtab shiftwidth=2 softtabstop=2

  if has_key(g:plugs, 'rainbow_parentheses.vim')
    au FileType c,cpp,java,javascript,python,rust,go RainbowParentheses
  endif

  if has_key(g:plugs, 'vim-autoformat')
    au BufWrite * :Autoformat
  endif

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

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
