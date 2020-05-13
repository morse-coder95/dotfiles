" vim: ft=vim

""" Plugin Installation
call plug#begin('~/.config/nvim/plugged')

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe'
Plug 'tpope/vim-fugitive'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
Plug 'ayu-theme/ayu-vim'
Plug 'rhysd/committia.vim'
Plug 'airblade/vim-gitgutter'
Plug 'liuchengxu/vim-which-key'
Plug 'janko/vim-test'
Plug 'psliwka/vim-smoothie'
Plug 'machakann/vim-sandwich'
Plug 'mhinz/vim-startify'
Plug 'haya14busa/incsearch.vim'
Plug 'voldikss/vim-floaterm'
Plug 'scrooloose/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'psf/black'
Plug 'fisadev/vim-isort'

call plug#end()

""" General Config
set autochdir
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

"""" Floaterm
let g:floaterm_width = 0.9
let g:floaterm_height = 0.7

"""" UltiSnips
let g:UltiSnipsExpandTrigger = "<c-f>"
let g:UltiSnipsJumpForwardTrigger = "<M-n>"
let g:UltiSnipsJumpBackwardTrigger = "<M-p>"
let g:UltiSnipsSnippetsDir = $HOME."/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories = ['UltiSnips', $HOME.'/.config/UltiSnips']
let g:UltiSnipsEnableSnipMate = 0


"""" Black
let g:black_linelength = 100
let g:black_virtualenv = '~/.virtualenvs/neovim/'

"""" YouCompleteMe
let g:ycm_python_binary_path = '/usr/bin/python3'
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
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''

"""" nerdcommenter
let g:NERDDefaultAlign = 'left'

"""" indentLine
let g:indentLine_char = '┆'

"""" auto-pairs
let g:AutoPairsCenterLine = 0

"""" SimpylFold
set foldlevel=999
let g:SimpylFold_fold_import = 0

cnoreabbrev Ack Ack!

"""" Ale
" Linting settings
let g:ale_linters = {
\   'python': ['flake8']
\}
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 0

"""" WhichKey
let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")
set timeoutlen=1000

"""" GitGutter
" Allow gitgutter to display the changes made to the file faster (default in vim is 4000 [4 seconds])
set updatetime=100

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
let g:startify_custom_header = startify#pad(split(system('echo "n\(athan\)vim" | cowsay -f turtle'), '\n'))


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

"""" Fuzzy Finding
let g:which_key_map.f = {
    \'name': '+find',
    \'f': {
        \'name': '+file_name_search',
        \'s': [":call _FloatermFZF('~/source/')", 'source'],
        \'a': [":call _FloatermFZF('~/source/ace/')", 'ace'],
        \'h': [":call _FloatermFZF('NONE')", 'here'],
    \},
    \'r': {
        \'name': '+file_content_search_regex',
        \'a': [":call PromptedFloatermSearch('~/source/ace/ace')", 'ace'],
        \'s': [":call PromptedFloatermSearch('~/source/')", 'source'],
        \'h': [":call PromptedFloatermSearch('NONE')", 'source'],
    \}
    \}

"""" Git
let g:which_key_map.g = {
    \'name': '+git',
    \'b': [':Gblame', 'blame'],
    \'p': [':GitGutterPrevHunk', 'previous hunk'],
    \'n': [':GitGutterNextHunk', 'next hunk'],
    \'d': [':GitGutterUndoHunk', 'delete hunk'],
    \'s': [':Gstatus', 'status'],
    \'c': [':Gcommit', 'commit'],
    \}

let g:which_key_map.y = {
    \'name': '+youcompleteme',
    \'d': [':YcmCompleter GoToDefinition', 'GotoDefinition'],
    \'r': [':YcmCompleter GoToReferences', 'GotoReferences'],
    \}

let g:which_key_map.z = {
    \'name': 'floaterm',
    \"t": [":FloatermToggle", "toggle"],
    \"f": [":call _FloatermPathCmd('cd', '%:p:h')", "open on file"],
    \"n": [":FloatermNew", "open new"],
    \"k": [":FloatermKill", "kill"]
    \}

let g:which_key_map.s = [':Startify', 'pull up startify']


"""" Easy Motion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"""" General
map <F1> :w <CR>
map <F2> :noh <CR>
nmap <Tab> :bn<CR>
nmap <S-Tab> :bp<CR>
map <C-Space> <Leader>c<Space>k<CR>

"""" Split Navigation
"nnoremap <C-j> <C-W><down>
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

function! _OpeningCallback(...) abort
    if filereadable('/tmp/floaterm-tmp-nonsense')
    let filenames = readfile('/tmp/floaterm-tmp-nonsense')
    if !empty(filenames)
        if has('nvim')
            call floaterm#window#hide_floaterm(bufnr('%'))
        endif
        for filename in filenames
            execute g:floaterm_open_command . ' ' . fnameescape(filename)
        endfor
    endif
  endif
endfunction

function! _FloatermFZF(path)
    if a:path ==# 'CURRENT_FILE'
        let l:path = expand('%:p:h')
    elseif a:path ==# 'NONE'
        let l:path = ''
    else
        let l:path = a:path
    endif
    call floaterm#terminal#open(
        \-1,
        \'find ' . l:path . ' -type f | fzf -m > /tmp/floaterm-tmp-nonsense',
        \{'on_exit': funcref('_OpeningCallback')},
        \{},
        \)
endfunction

function! _FloatermSearch(path, term)
    if a:path ==# 'CURRENT_FILE'
        let l:path = expand('%:p:h')
    elseif a:path ==# 'NONE'
        let l:path = ''
    else
        let l:path = a:path
    endif
    let l:rg_cmd = 'rg -S --files-with-matches --no-messages "' . a:term . '" ' . l:path .''
    let l:preview_cmd = "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '" . a:term . "' || rg --ignore-case --pretty --context 10 '" . a:term . "' {}"
    let l:fif_cmd = l:rg_cmd . ' | fzf -m --reverse --preview="' . l:preview_cmd . '" > /tmp/floaterm-tmp-nonsense'
    call floaterm#terminal#open(
        \-1,
        \l:fif_cmd,
        \{'on_exit': funcref('_OpeningCallback')},
        \{},
        \)
endfunction

function! PromptedFloatermSearch(path)
    call inputsave()
    let l:search = input('Search regex: ')
    call inputrestore()
    redraw
    call _FloatermSearch(a:path, l:search)
endfunction

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
