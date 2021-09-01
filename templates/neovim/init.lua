local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Plugins
require "paq" {
    {'savq/paq-nvim', opt = true};    -- paq-nvim manages itself
    {'shougo/deoplete-lsp'};  -- autocompletion
    {'shougo/deoplete.nvim', run = fn['remote#host#UpdateRemotePlugins']};
    {'nvim-treesitter/nvim-treesitter'};
    {'neovim/nvim-lspconfig'};  -- facilitate configuration of language servers
    {'junegunn/fzf', run = fn['fzf#install']};
    {'junegunn/fzf.vim'};
    {'ojroques/nvim-lspfuzzy'};
    {'luxed/ayu-vim'};  -- color scheme
    {'psliwka/vim-smoothie'};  -- smooth scrolling
    {  -- shortcut mappings
        'folke/which-key.nvim',
        config = function() require('which-key').setup {} end
    };
    {'phaazon/hop.nvim'};  -- replacement for easymotion
    {'scrooloose/nerdcommenter'};  -- commenting shortcuts
    {'vim-airline/vim-airline'};  -- status and tab lines
    {'Yggdroot/indentLine'};  -- allow special indent characters
    {'psf/black'};  -- code formatter
    {'fisadev/vim-isort'};  -- sort python imports
    {'jiangmiao/auto-pairs'};
    {'machakann/vim-highlightedyank'};  -- highlight yanked text
    {'vim-scripts/BufOnly.vim'};  -- close all buffers except the active one
    {'prettier/vim-prettier'};  -- js formatting
    {'airblade/vim-gitgutter'};
}

-- git gutter
g.gitgutter_map_keys = 0  -- no mappings
opt.updatetime = 100


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
local wk = require("which-key")
wk.register(
    {
        b = {":Black<CR>", "blacken"},
        h = {":HopLine<CR>", "hop"},
        f = {
            name = "find+",
            f = {
                name = "files+",
                p = {"<cmd>cd ~/source/python<cr><cmd>FZF<cr>", "python"},
                h = {"<cmd>cd ~/<cr><cmd>FZF<cr>", "home"},
                s = {"<cmd>cd ~/source/scripts<cr><cmd>FZF<cr>", "scripts"},
                c = {"<cmd>cd ~/source/cpp<cr><cmd>FZF<cr>", "cpp"},
                w = {"<cmd>cd ~/source/web<cr><cmd>FZF<cr>", "web"},
            },
            r = {"<cmd>Rg<cr>", "words"}
        },
        s = {"<cmd>set autochdir<cr>", "cd cwd"},
        p = {"<cmd>Prettier<cr>", "pretty"}
    },
    { prefix = '<leader>' }
)
