" vim: ft=vim

""" Plugin Installation
call plug#begin('~/.config/nvim/plugged')

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'ayu-theme/ayu-vim'
Plug 'airblade/vim-gitgutter'
Plug 'liuchengxu/vim-which-key'
Plug 'psliwka/vim-smoothie'
Plug 'machakann/vim-sandwich'
Plug 'mhinz/vim-startify'
Plug 'haya14busa/incsearch.vim'
Plug 'voldikss/vim-floaterm'
Plug 'scrooloose/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'fisadev/vim-isort'
Plug 'rhysd/git-messenger.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

"""" coc.nvim
""""" Trimmed default recommended settings
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=750

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

""""" Actual settings
let g:coc_global_extensions = [
    \'coc-python',
    \'coc-ultisnips',
    \'coc-json',
    \'coc-floaterm',
    \'coc-git',
    \]

let g:coc_disable_startup_warning = 1


"""" Floaterm
let g:floaterm_width = 0.9
let g:floaterm_height = 0.7


"""" Black
"let g:black_linelength = 100
"let g:black_virtualenv = '~/.virtualenvs/neovim/'

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

"""" WhichKey
let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")
set timeoutlen=1000

"""" GitGutter
" Allow gitgutter to display the changes made to the file faster (default in vim is 4000 [4 seconds])
set updatetime=100

"""" GitMessenger
let g:git_messenger_always_into_popup = v:true

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

"""" NERDCommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'


command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --hidden --smart-case --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%', '?'),
    \   <bang>0)

""" Key Bindings
"""" Change leader key to space (KEEP ABOVE OTHER LEADER MAPPINGS)
" This has to be higher in the file than any <Leader> mappings, since it resets any leader mappings
" defined above it
let mapleader = ' '

"""" WhichKey
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

"""" coc (replace YCM)
let g:which_key_map.y = {
    \'name': '+goto',
        \'d': ['<Plug>(coc-definition)', 'definition'],
        \'r': ['<Plug>(coc-references)', 'references'],
    \}

let g:which_key_map.b = [":call CocAction('format')", 'blacken']

"""" Fuzzy Finding
let g:which_key_map.f = {
    \'name': '+find',
    \'f': {
        \'name': '+file_name_search',
        \'s': [":cd ~/source/ | Files", 'source'],
        \'a': [":cd ~/source/ace/ | Files", 'ace'],
        \'h': [":cd ~/ | File", 'home'],
        \'c': ["Files", 'cwd'],
    \},
    \'r': {
        \'name': '+file_content_search_regex',
        \'s': [":cd ~/source/ | Rg", 'source'],
        \'a': [":cd ~/source/ace/ | Rg", 'ace'],
        \'h': [":cd ~/ | File", 'home'],
        \'c': ["Rg", 'cwd'],
    \}
    \}

"""" Git
let g:which_key_map.g = {
    \'name': '+git',
    \'b': [':Gblame', 'blame'],
    \'s': [':Gstatus', 'status'],
    \'c': [':Gcommit', 'commit'],
    \'l': ['BCommits', 'list of commits'],
    \'m': [':GitMessenger', 'message preview'],
    \}

"""" Floaterm
let g:which_key_map.z = {
    \'name': 'floaterm',
    \"t": [":FloatermToggle", "toggle"],
    \"n": [":FloatermNew", "open new"],
    \"k": [":FloatermKill", "kill"]
    \}

"""" toggle normal mode
let g:which_key_map.n = [':call ToggleNormalMode()', 'toggle normal mode']

"""" change to cwd
let g:which_key_map.s = [':set autochdir', 'set autochdir']


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
map <C-Space> :call NERDComment('n', 'Toggle')<CR>
tnoremap <C-\> <C-\><C-N>

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

" Commands to edit or reload this file
command! Editconf :edit ~/.config/nvim/init.vim
command! Reloadconf :so ~/.config/nvim/init.vim

""" Misc
" Highlight .sqli files as sql
autocmd BufRead *sqli set ft=sql
autocmd BufEnter * set fo-=c fo-=r fo-=o  " stop annoying auto commenting on new lines
