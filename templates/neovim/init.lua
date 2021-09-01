local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Plugins
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq {'shougo/deoplete-lsp'}  -- autocompletion
paq {'shougo/deoplete.nvim', run = fn['remote#host#UpdateRemotePlugins']}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig'}  -- facilitate configuration of language servers
paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'luxed/ayu-vim'}  -- color scheme
paq {'psliwka/vim-smoothie'}  -- smooth scrolling
paq {'liuchengxu/vim-which-key'}  -- shortcut mappings
paq {'phaazon/hop.nvim'}  -- replacement for easymotion
paq {'scrooloose/nerdcommenter'}  -- commenting shortcuts
paq {'vim-airline/vim-airline'}  -- status and tab lines
paq {'Yggdroot/indentLine'}  -- allow special indent characters
paq {'psf/black'}  -- code formatter
paq {'fisadev/vim-isort'}  -- sort python imports
paq {'jiangmiao/auto-pairs'}

-- Deoplete
g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup

-- Airline
g['airline#extensions#tabline#enabled'] = 1

-- indentLine
g.indentLine_char = '┆'

-- options
opt.expandtab = true            -- use spaces instead of tabs
opt.shiftwidth = 4              -- size of an indent
opt.list = true                 -- Show some invisible characters
opt.tabstop = 4                 -- number of spaces a tab accounts for
opt.number = true               -- show line numbers
opt.smartindent = true          -- auto indent
opt.wrap = false                -- disable line wrap
opt.termguicolors = true        -- true color support
opt.hidden = true               -- enable background buffers
opt.ignorecase = true           -- case-insensitive search

-- python path
g.python3_host_prog = '/home/nmorse/.virtualenvs/nvim/bin/python3'


-- Disable next-line autocommenting
cmd 'autocmd BufEnter * set fo-=c fo-=r fo-=o'

-- tree sitter
-- Here the maintained value indicates that we wish to use all maintained languages modules.
-- You also need to set highlight to true otherwise the plugin will be disabled.
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-- color
g.ayucolor = 'dark'
cmd 'colorscheme ayu'

-- lsp stuff
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'
lsp.pylsp.setup {}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

-- Nerd Commenter
g.NERDCreateDefaultMappings = 0
g.NERDDefaultAlign = 'left'

-- The vim.api.nvim_set_keymap() function allows you to define a new mapping
-- Specific behaviors such as noremap must be passed as a table to that function.
-- Here is a helper to create mappings with the noremap option set to true by default:
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Mappings
g.mapleader = ' '
map('n', '<F1>', ':w<CR>')
map('n', '<Tab>', ':bn<CR>')
map('n', '<S-Tab>', ':bp<CR>')
map('n', '<F2>', ':noh<CR>')
map('', '<C-Space>', ":call NERDComment('n', 'Toggle')<CR>")  -- C-Space to toggle comment
-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
