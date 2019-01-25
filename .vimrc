" =============================================================================
" .vimrc of zhanghaifeng
" =============================================================================

" 基础 {{{
if &compatible | set nocompatible | endif
let mapleader=' '
let maplocalleader=' '
syntax enable
syntax on
filetype on
filetype plugin on
filetype indent on

" 编码
set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" 界面相关
silent! set number relativenumber background=dark nowrap guioptions=
silent! set ruler laststatus=2 showmode cursorline colorcolumn=80
silent! set list listchars=tab:›\ ,trail:• scrolloff=3 t_ti= t_te=
silent! set mouse=a mousehide guicursor=a:block-blinkon0 helplang=cn
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

" 编辑
silent! set shiftwidth=4 expandtab tabstop=4 softtabstop=4
silent! set nofoldenable foldlevel=2 foldmethod=indent
silent! set backspace=indent,eol,start formatoptions=cmMj
silent! set tags=tags,./tags,../tags,../../tags,../../../tags

" 剪切板
silent! set clipboard=unnamed
silent! set clipboard+=unnamedplus

" 搜索
silent! set ignorecase smartcase incsearch hlsearch magic

" 命令
silent! set wildmenu wildmode=list:longest
silent! set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out,*.lock,*.DS_Store
silent! set wildignore+=.hg,.git,.svn
silent! set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
silent! set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.manifest

" 缓存
silent! set history=1000
silent! set swapfile directory=~/.vim/tmp/swap//
silent! set nobackup backupdir=~/.vim/tmp/backup//
silent! set undofile undolevels=1000 undodir=~/.vim/tmp/undo//
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" 性能表现
silent! set updatetime=300 timeout timeoutlen=500 ttimeout ttimeoutlen=50 ttyfast lazyredraw

" 警告声
silent! set noerrorbells visualbell t_vb=
" }}}

" Auto group {{{
augroup vimrc
    autocmd!
augroup END

autocmd vimrc GUIEnter * silent! simalt ~x
autocmd vimrc GUIEnter * silent! set t_vb=
autocmd vimrc SwapExists * let v:swapchoice = 'o' " 如已打开，自动选择只读
autocmd vimrc BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 启动后定位到上次关闭光标位置
autocmd vimrc FileType haskell,puppet,ruby,yaml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd vimrc FileType markdown,text setlocal wrap

function! s:strip_trailing_whitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd vimrc FileType c,cpp,java,php,javascript,python,rust,xml,yaml,perl,sql autocmd BufWritePre <buffer> call <SID>strip_trailing_whitespace()
" }}}

" 插件安装 {{{
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
endif
call plug#begin('~/.vim/bundle')

" 属性增强
" Plug 'MarcWeber/vim-addon-mw-utils'

" 外观
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'icymind/NeoSolarized'
Plug 'junegunn/rainbow_parentheses.vim'

" 一般功能
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
" Plug 'jiangmiao/auto-pairs'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'Shougo/vinarise.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'shougo/vimfiler.vim'
Plug 'Shougo/unite.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-slash'
" Plug 'junegunn/vim-peekaboo'
Plug 'vim-scripts/ReplaceWithRegister' " gr
Plug 'terryma/vim-expand-region'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle'  }

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-signify'

" 所有语言
Plug 'junegunn/vim-easy-align'
Plug 'tomtom/tcomment_vim' " 注释 gcc gcu gcap
Plug 'w0rp/ale'

" Dockerfile
Plug 'honza/dockerfile.vim', {'for' : 'Dockerfile'}

" C/CPP
Plug 'octol/vim-cpp-enhanced-highlight',{'for': 'cpp'}
Plug 'lyuts/vim-rtags', { 'for': ['c', 'cpp'] }

" Go
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'buoto/gotests-vim'

" 自动补全
" if has('nvim')
"     Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"     Plug 'Shougo/deoplete.nvim'
"     Plug 'roxma/nvim-yarp'
"     Plug 'roxma/vim-hug-neovim-rpc'
" endif
" Plug 'zchee/deoplete-go', { 'do': 'make'}
" Plug 'Shougo/neco-syntax'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --go-completer --java-completer' }

call plug#end()

" 设置主题
if !empty(glob('~/.vim/bundle/seoul256.vim'))
    set termguicolors
    let g:seoul256_background = 236
    if !empty(glob('~/.vim/bundle/indentLine'))
        let g:indentLine_color_term = 239
        let g:indentLine_color_gui = '#616161'
    endif

    colorscheme seoul256
endif

if !empty(glob('~/.vim/bundle/vim-easy-align'))
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endif

if !empty(glob('~/.vim/bundle/deoplete.nvim'))
    let g:deoplete#enable_at_startup = 1

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
    " Close preview window
    " if exists('##CompleteDone')
    "     au CompleteDone * pclose
    " else
    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
    " endif
endif

if !empty(glob('~/.vim/bundle/YouCompleteMe'))
    let g:ycm_confirm_extra_conf = 0
    " let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'markdown' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1,
                \ 'mundo': 1,
                \ 'fzf': 1,
                \ 'ctrlp' : 1
                \}

    " 评论中也应用补全
    let g:ycm_complete_in_comments = 1

    let g:ycm_always_populate_location_list = 1

    " 两个字开始补全
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_semantic_triggers =  {'c' : ['->', '.'], 'objc' : ['->', '.'], 'ocaml' : ['.', '#'], 'cpp,objcpp' : ['->', '.', '::'], 'php' : ['->', '::'], 'cs,java,javascript,vim,coffee,python,scala,go' : ['.'], 'ruby' : ['.', '::']}

    augroup javaycm
        autocmd!
        autocmd FileType java nnoremap <buffer> <silent> <C-]> :YcmCompleter GoToImprecise<CR>
    augroup END

    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif

    " set completeopt-=preview
endif

if !empty(glob('~/.vim/bundle/rainbow_parentheses.vim'))
    autocmd vimrc FileType c,cpp,java,php,javascript,python,rust,xml,yaml,perl,sql,go RainbowParentheses
endif

if !empty(glob('~/.vim/bundle/vim-signify'))
    let g:signify_vcs_list = ['git']
    let g:signify_skip_filetype = { 'journal': 1 }
    let g:signify_sign_add          = '│'
    let g:signify_sign_change       = '│'
    let g:signify_sign_changedelete = '│'
    let g:signify_sign_delete       = '│'
    let g:signify_sign_delete_first_line = '‾'
endif

if !empty(glob('~/.vim/bundle/fzf.vim'))
    " Default fzf layout
    " - down / up / left / right
    let g:fzf_layout = { 'down': '~40%' }

    " In Neovim, you can set up fzf window using a Vim command
    let g:fzf_layout = { 'window': 'enew' }
    let g:fzf_layout = { 'window': '-tabnew' }
    let g:fzf_layout = { 'window': '10split enew' }

    " Customize fzf colors to match your color scheme
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

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = '~/.fzf-history'

    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

    " [Tags] Command to generate tags file
    let g:fzf_tags_command = 'ctags -R'
    nnoremap <Leader>ff :Files<cr>
    nnoremap <Leader>fb :Buffers<cr>
    nnoremap <Leader>fm :Marks<cr>
    nnoremap <Leader>fr :History<cr>
    nnoremap <Leader>fc :Commits<cr>
    nnoremap <Leader>fs :GFiles?<cr>
    nnoremap <Leader>fhs :History/<cr>
    nnoremap <Leader>fhc :History:<cr>
    nnoremap <Leader>ft :BTags<cr>

    " 搜索选中项
    function! s:visual_selection() range
        let l:saved_reg = @"
        execute "normal! vgvy"

        let l:pattern = escape(@", '\\/.*$^~[]')
        let l:pattern = substitute(l:pattern, "\n$", "", "")

        execute 'Ag '.l:pattern

        let @/ = l:pattern
        let @" = l:saved_reg
    endfunction
    vnoremap <Leader>fg :call <SID>visual_selection()<CR>
    nnoremap <Leader>fg :Ag 
endif

if !empty(glob('~/.vim/bundle/ale'))
    let g:ale_linters_explicit = 1
    let g:ale_linters = {
                \ 'go': ['golint', 'go vet'],
                \ }
    " let g:ale_go_gometalinter_options = '--disable-all --enable=errcheck'
    " let g:ale_go_gometalinter_lint_package = 1
    let g:ale_open_list = 1
endif

if !empty(glob('~/.vim/bundle/tagbar'))
    nnoremap <F2> :Tagbar<CR>
    inoremap <F2> <ESC>:Tagbar<CR>
    vnoremap <F2> <ESC>:Tagbar<CR>
endif

if !empty(glob('~/.vim/bundle/delimitMate'))
    let delimitMate_excluded_ft = "clojure,lisp"
    let delimitMate_expand_cr = 1
endif

if !empty(glob('~/.vim/bundle/unite.vim'))
    call unite#custom#source('codesearch', 'max_candidates', 30)
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    let g:unite_source_grep_max_candidates = 200
    let g:unite_source_grep_default_opts =
                \ '-iRHn'
                \ . " --exclude='tags'"
                \ . " --exclude='cscope*'"
                \ . " --exclude='*.svn*'"
                \ . " --exclude='*.log*'"
                \ . " --exclude='*tmp*'"
                \ . " --exclude-dir='**/tmp'"
                \ . " --exclude-dir='CVS'"
                \ . " --exclude-dir='.svn'"
                \ . " --exclude-dir='.git'"
                \ . " --exclude-dir='node_modules'"

    " Use ag (the silver searcher)
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
                \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''

    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
endif

if !empty(glob('~/.vim/bundle/vimfiler.vim'))
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
        silent! nunmap <buffer> B

        nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
        nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
        nmap <buffer> u       <Plug>(vimfiler_smart_h)
    endf

    nnoremap <F3> :VimFilerExplorer<CR>
    inoremap <F3> <ESC>:VimFilerExplorer<CR>
    vnoremap <F3> <ESC>:VimFilerExplorer<CR>
endif

if !empty(glob('~/.vim/bundle/undotree'))
	let g:undotree_WindowLayout = 2
	nnoremap <F4> :UndotreeToggle<CR>
endif

if !empty(glob('~/.vim/bundle/vim-go'))
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
    let g:go_info_mode = "gocode"

    let g:go_def_mode = "godef"
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

    augroup go
        autocmd!

        " :GoAlternate  commands :A, :AV, :AS and :AT
        autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
        autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
    augroup END
endif
" }}}

" 快捷键 {{{
nnoremap LB 0
nnoremap LE $
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap Y y$
vnoremap < <gv
vnoremap > >gv
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>WQ :wa<CR>:q<CR>
nnoremap <Leader>Q :qa!<CR>
nnoremap Q :qa!<CR>
nnoremap <Leader>cd :lcd %:h<CR>
nnoremap <Leader>' :terminal<CR>

nnoremap <C-w> <C-w>w
nnoremap <tab> <C-w>w
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

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
" }}}
