" vim: ft=vim

""" Plugin Installation
call plug#begin('~/.config/nvim/plugged')

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe',  { 'commit': '417b74b1e971d5a7b5d58b251865941b426ac096', 'frozen': 'true'}
Plug 'SirVer/ultisnips', { 'commit': '7dc30c55e5c41c98a8c7421bb01fec1d559256fd', 'frozen': 'true' }
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
Plug 'ayu-theme/ayu-vim'
"Plug 'rhysd/committia.vim'
Plug 'airblade/vim-gitgutter'
Plug 'liuchengxu/vim-which-key'
Plug 'janko/vim-test'
Plug 'psliwka/vim-smoothie'
Plug 'machakann/vim-sandwich'
Plug 'mhinz/vim-startify'
Plug 'haya14busa/incsearch.vim'
Plug 'voldikss/vim-floaterm'

Plug 'scrooloose/nerdcommenter'
Plug 'prettier/vim-prettier', {'do': 'npm install'}
Plug 'easymotion/vim-easymotion'
Plug 'Yggdroot/indentLine'
Plug 'rhysd/git-messenger.vim'
Plug 'majutsushi/tagbar'
Plug 'preservim/nerdtree'
Plug 'fisadev/vim-isort'


call plug#end()

""" General Config
set mouse=a
set ignorecase
set cursorline
set colorcolumn=100
set textwidth=100
set formatoptions-=t
set expandtab tabstop=4 shiftwidth=4 smarttab
set number norelativenumber
set lazyredraw
set nowrap
set clipboard+=unnamedplus
set clipboard=unnamedplus
filetype plugin on      " Allow filetype plugins to be enabled


""" Plugin Settings

"""" Tagbar
let g:tagbar_sort = 0
let g:tagbar_width = 65
autocmd FileType python nested :TagbarOpen

let g:tagbar_type_python = {
    \ 'kinds' : [
        \ 'i:imports:1:0',
        \ 'c:classes',
        \ 'f:functions',
        \ 'm:members',
        \ 'v:variables:0:0',
        \ '?:unknown',
    \ ],
\ }

"""" UltiSnips
let g:python_host_prog = '/opt/bats/bin/python'
"let g:python_host_prog = '~/.virtualenvs/neovim/bin/python'
let g:python3_host_prog = '~/.virtualenvs/neovim/bin/python3'
let g:UltiSnipsExpandTrigger = "<c-f>"
let g:UltiSnipsJumpForwardTrigger = "<M-n>"
let g:UltiSnipsJumpBackwardTrigger = "<M-p>"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0


"""" Markology
"let g:markology_enable = 0

"""" YouCompleteMe
let g:ycm_python_binary_path = '/opt/bats/bin/python'
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_key_detailed_diagnostics = ''

"""" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extension#ale#enabled = 1
let g:airline_theme = 'wombat'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline_section_x = ''
let g:airline_section_y = '%{getcwd()}'
set showmode
set ttimeoutlen=10  " Set the escape key timeout to very little
" comment out the below section if you don't have a patched font installed (or another nerd font)
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

"""" indentLine
let g:indentLine_char = '┆'

"""" auto-pairs
let g:AutoPairsCenterLine = 0

"""" SimpylFold
set foldlevel=999
let g:SimpylFold_fold_import = 0

"""" FastFold
let g:fastfold_force = 1
let g:fastfold_savehook = 0

"""" FZF
let g:fzf_layout = { 'window': 'call FloatingFZF(0.9, 0.6, "Comment")' }

" File searching with ag
command! -bang -nargs=* RgPython
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/source/python', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* RgDbNodes
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/db/nodes', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* RgEquities
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/source/python/ecn', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* RgOptions
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/source/python/opt', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* RgFutures
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/source/python/cfe', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* RgSource
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>) . ' ~/source', 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
let g:ackprg = 'ag --vimgrep'
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
cnoreabbrev Ack Ack!

"""" Ale
" Linting settings
let g:ale_linters = {
\   'python': ['flake8']
\}
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0
let g:ale_lint_on_text_changed = 'always'

"""" WhichKey
let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")
set timeoutlen=750

"""" GitGutter
" Allow gitgutter to display the changes made to the file faster (default in vim is 4000 [4 seconds])
set updatetime=100

"""" GitMessenger
let g:git_messenger_always_into_popup = v:true

"""" VimTest
let test#python#runner = 'nose'
let test#strategy = {
    \'file': 'floating',
    \'last': 'floating',
    \'nearest': 'floating',
    \'suite': 'neovim'
    \}
let test#python#nose#options = {
    \'file': '-sv',
    \'last': '-sv',
    \'nearest': '-sv',
\}

"""" ayu
set termguicolors
let ayucolor='dark'
colorscheme ayu
hi! Whitespace guifg=#b2b2b2
hi! Folded guifg=#00b3b3
" make the line numbers more visible (must be called after colorscheme)
"hi LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

"""" vim-startify
autocmd User Startified setlocal buflisted  " necessary to integrate nicely with vim-float
let g:startify_session_persistence = 1  " auto-save which buffers are in the session
let g:startify_custom_header = startify#pad(split(system('echo n\(athan\)vim | cowsay -f ghostbusters'), '\n'))


"""" incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1  " automatically turn off highlighting when navigating off

""" Key Bindings
"""" Change leader key to space (KEEP ABOVE OTHER LEADER MAPPINGS)
" This has to be higher in the file than any <Leader> mappings, since it resets any leader mappings
" defined above it
let mapleader = ' '

"""" WhichKey
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

""""" Linting
let g:which_key_map.a = {
    \'name': '+ale',
    \'t': [':ALEToggle', 'toggle'],
    \'p': ['<Plug>(ale_previous_wrap)', 'previous error'],
    \'n': ['<Plug>(ale_next_wrap)', 'next error']
    \}

"""" Buffers
let g:which_key_map.b = {
    \'name': '+buffers',
    \'p': [':bp', 'previous'],
    \'n': [':bn', 'next'],
    \'d': [':bd', 'kill current'],
    \}

"""" NERDCommenter
let g:which_key_map.c = {'name': '+nerd_commenter'}
let g:NERDDefaultAlign = 'left'

"""" Fuzzy Finding
let g:which_key_map.f = {
    \'name': '+find',
    \'f': {
        \'name': '+file_name_search',
        \'p': [':FZF ~/source/python/', 'python'],
        \'o': [':FZF ~/source/python/opt/', 'options'],
        \'e': [':FZF ~/source/python/ecn/', 'equities'],
        \'f': [':FZF ~/source/python/cfe/', 'futures'],
        \'d': [':FZF ~/db/nodes/', 'db'],
        \'s': [':FZF ~/source/', 'source'],
        \'h': [':FZF', 'here'],
        \'~': [':FZF ~/', 'home']
    \},
    \'r': {
        \'name': '+file_content_search_regex',
        \'p': [':RgPython', 'python'],
        \'e': [':RgEquities', 'ecn'],
        \'o': [':RgOptions', 'opt'],
        \'f': [':RgFutures', 'cfe'],
        \'s': [':RgSource', 'source'],
        \'d': [':RgDbNodes', 'dbnodes'],
        \'h': [':Rg', 'here'],
    \},
    \}

"""" Git
let g:which_key_map.g = {
    \'name': '+git',
    \'b': [':Gblame', 'blame'],
    \'p': [':GitGutterPrevHunk', 'previous hunk'],
    \'n': [':GitGutterNextHunk', 'next hunk'],
    \'d': [':GitGutterUndoHunkrch-nohlsearch)<Plug>NERDCommenterSexy', 'delete hunk'],
    \'s': [':Gstatus', 'status'],
    \'c': [':Gcommit', 'commit'],
    \'m': [':GitMessenger', 'message preview']
    \}

""""
let g:which_key_map.l = {
    \'name': '+tagbar',
    \'l': [':TagbarOpen fj', 'open and focus tagbar'],
    \'o': [':TagbarOpen', 'open tagbar'],
    \'c': [':TagbarClose', 'close tagbar'],
    \'t': [':TagbarToggle', 'toggle tagbar']
    \}

"""" toggle normal mode
let g:which_key_map.n = {
            \'name': '+nerdtree',
            \'p': [':NERDTree ~/source/python', 'open python dir'],
            \'w': [':NERDTree', 'open working dir'],
            \'t': [':NERDTreeToggle', 'toggle'],
            \'q': [':NERDTreeClose', 'close']
            \}

"""" Tests
let g:which_key_map.t = {
    \'name': '+tests',
    \'f': [':TestFile', 'Run current test file'],
    \'l': [':TestLast', 'Run last run test'],
    \'n': [':TestNearest', 'Run test nearest cursor'],
    \'c': [':set autochdir | :call FloatingTest("nosetests --verbose -a current ")', 'Run current test']
    \}

"""" Write
let g:which_key_map.w = [':w', 'write']

"""" Quit
let g:which_key_map.q = [':q', 'quit']

"""" Completion
let g:which_key_map.y = {
    \'name': '+youcompleteme',
    \'d': [':YcmCompleter GoToDefinition', 'GotoDefinition'],
    \'r': [':YcmCompleter GoToReferences', 'GotoReferences'],
    \}

"""" Easy Motion
 " <Leader><Leader> is annoying, turn it off
"map <Leader> <Plug>(easymotion-prefix)

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


"""" General
map <F1> :w <CR>
map <F2> :noh <CR>
nnoremap Y y$
nnoremap U <c-r>
nmap <Tab> :bn<CR>
nmap <S-Tab> :bp<CR>
map <C-Space> <Leader>c<Space>k<CR>
nmap <F12> :call ToggleNormalMode()<Cr>
let @a='?def testOfrom nose.plugins.attrib import attr@attr("current")'

"""" Split Navigation
nnoremap <C-j> <C-W><down>
nnoremap <C-k> <C-W><up>
nnoremap <C-l> <C-W><right>
nnoremap <C-h> <C-W><left>

"""" incsearch
" zz appended to center the search on the screen
map n  <Plug>(incsearch-nohl-n)zz
map N  <Plug>(incsearch-nohl-N)zz
map *  <Plug>(incsearch-nohl-*)zz
map #  <Plug>(incsearch-nohl-#)zz
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

""" Text expansions
iabbrev lbreak;; # -------------------------------------------------------------------------------------------------
iabbrev break;; # ---------------------------------------------------------------------------------------------

""" Custom Functions
function! ToggleNormalMode()
    let l:state = get(b:, 'CustomEditorStateNormal', 1)
    if l:state == 1
        set nonumber norelativenumber
        set nolist
        IndentLinesDisable
        let b:CustomEditorStateNormal = 0
    else
        set number norelativenumber
        set list
        IndentLinesEnable
        let b:CustomEditorStateNormal = 1
    endif
endfunction


" Only define function if neovim is new enough to have floating windows
if has('nvim-0.4.0')
    function! _CreateBorder(width, height)
        let top = '╭' . repeat('─', a:width - 2) . '╮'
        let mid = '│' . repeat(' ', a:width - 2) . '│'
        let bot = '╰' . repeat('─', a:width - 2) . '╯'
        return [top] + repeat([mid], a:height - 2) + [bot]
    endfunction

    function! _CreateFloat(hl, opts)
        let buf = nvim_create_buf(v:false, v:true)
        let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
        let win = nvim_open_win(buf, v:true, opts)
        call setwinvar(win, '&winhighlight', 'NormalFloat:'.a:hl)
        call setwinvar(win, '&colorcolumn', '')
        return buf
    endfunction

    function! FloatingFZF(width, height, border_highlight)
        " Size and position
        let width = float2nr(&columns * a:width)
        let height = float2nr(&lines * a:height)
        let row = float2nr((&lines - height) / 2)
        let col = float2nr((&columns - width) / 2)

        " Border
        let border = _CreateBorder(width, height)

        " Draw frame
        let s:frame = _CreateFloat(a:border_highlight, {'row': row, 'col': col, 'width': width, 'height': height})
        call nvim_buf_set_lines(s:frame, 0, -1, v:true, border)

        " Draw viewport
        call _CreateFloat('Normal', {'row': row + 1, 'col': col + 2, 'width': width - 4, 'height': height - 2})
        autocmd BufWipeout <buffer> execute 'bwipeout' s:frame
    endfunction

    function! OnTestExit(job_id, code, event) dict
        if a:code == 0
            call _OFWGKTA()
        endif
    endfunction

    function! _OFWGKTA()
        silent! execute 'bwipeout' s:frame | silent! execute 'bwipeout!' s:contents
    endfunction

    function! TermTest(cmd)
        "call termopen(a:cmd, {'on_exit': 'OnTestExit'})
        call termopen(a:cmd)
    endfunction

    function! FloatingTest(cmd)
        let buf = nvim_create_buf(v:false, v:true)
        let width = float2nr(&columns * 0.9)
        let height = float2nr(&lines * 0.7)
        let row = float2nr((&lines - height) / 2)
        let col = float2nr((&columns - width) / 2)

        let opts = {
            \'row': row,
            \'col': col,
            \'width': width,
            \'height': height,
            \}

        let border = _CreateBorder(width, height)
        let s:frame = _CreateFloat('Comment', opts)
        call nvim_buf_set_lines(s:frame, 0, -1, v:true, border)

        let opts = {
            \'row': row + 1,
            \'col': col + 2,
            \'width': width - 4,
            \'height': height - 2
            \}
        let s:contents = _CreateFloat('Normal', opts)
        autocmd BufWipeout <buffer> call _OFWGKTA()
        call TermTest(a:cmd)
    endfunction

    " Has to be defined after the function. Sad :(
    let g:test#custom_strategies = {'floating': function('FloatingTest')}
endif




" Commands to edit or reload this file
command! Editconf :edit ~/.config/nvim/init.vim
command! Reloadconf :so ~/.config/nvim/init.vim

""" Misc
" Highlight .sqli files as sql
autocmd BufRead *sqli set ft=sql
autocmd BufEnter * set fo-=c fo-=r fo-=o  " stop annoying auto commenting on new lines

""" Help
"""" vim-commentary
" gc{motion}            comment or uncomment lines that {motion} moves over
" [count]gcc            comment or uncomment [count] lines 

"""" vim-sandwich recipes
" sdb           delete the surrounding _whatever_
" sd"           delete the surrounding double-quotes
" sr[(          change the surrounding square-brackets to parens
" saiw"         add double-quotes to the inner-word object
" saW"          add double-quotes around the word (incl. punctuation)

"""" quickfix
" :copen        open the quickfix window
" :copen 40     open the quickfix window with 40 lines of display
" :cclose       close the quickfix window
" :cw           open the quickfix window if errors, otherwise close it

" Old stuff
"set clipboard+=unnamedplus
"inoremap jj <ESC>
" Toggle to keep cursor centered in the screen
"nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>
