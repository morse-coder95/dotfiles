local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Plugins --------------------------------------------------------------------
local Plug = fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged/')

Plug 'luxed/ayu-vim'  -- colorscheme
Plug 'shougo/deoplete-lsp'  -- autocompletion
Plug('shougo/deoplete.nvim', {['do'] = ':UpdateRemotePlugins' })
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'  -- facilitate configuration of language servers
Plug('junegunn/fzf', {['do'] = fn['fzf#install']})
Plug 'junegunn/fzf.vim'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'psliwka/vim-smoothie'  -- smooth scrolling
Plug 'folke/which-key.nvim'  -- keyboard shortcuts
Plug 'phaazon/hop.nvim'  -- easier line jumps
Plug 'scrooloose/nerdcommenter'  -- commenting shortcuts
Plug 'vim-airline/vim-airline'  -- status and tab lines
Plug 'Yggdroot/indentLine'  -- allow special indent characters
Plug 'psf/black'  -- code formatter
Plug 'fisadev/vim-isort'  -- sort python imports
Plug 'jiangmiao/auto-pairs';
Plug 'machakann/vim-highlightedyank'  -- highlight yanked text
Plug 'vim-scripts/BufOnly.vim'  -- close all buffers except the active one
Plug 'prettier/vim-prettier'  -- js formatting
Plug 'airblade/vim-gitgutter'  -- show modified lines
Plug 'SirVer/ultisnips'  -- snippets
Plug 'vim-test/vim-test'  -- run tests within vim
Plug 'Vimjas/vim-python-pep8-indent' -- fixes weird vim-jedi double indent
Plug 'tpope/vim-fugitive'  -- git operations

vim.call('plug#end')

-- options
opt.expandtab = true            -- use spaces instead of tabs
opt.shiftwidth = 4              -- size of an indent
opt.list = true                 -- Show some invisible characters
opt.tabstop = 4                 -- number of spaces a tab accounts for
opt.smarttab = true
opt.number = true               -- show line numbers
--opt.smartindent = true          -- auto indent
opt.wrap = false                -- disable line wrap
opt.termguicolors = true        -- true color support
opt.hidden = true               -- enable background buffers
opt.ignorecase = true           -- case-insensitive search
opt.cursorline = true           -- highlight the current line
opt.lazyredraw = true

-- python path
g.python3_host_prog = '/home/nmorse/.virtualenvs/nvim/bin/python3'

-- black
g.black_linelength = 99

-- vim-test
g["test#python#runner"] = "nose"
g["test#echo_command"] = 1

-- ultisnips
g.UltiSnipsExpandTrigger = "<c-f>"
g.UltiSnipsJumpForwardTrigger = "<M-n>"
g.UltiSnipsJumpBackwardTrigger = "<M-p>"
g.UltiSnipsSnippetsDir = "/home/nmorse/.config/nvim/UltiSnips"
g.UltiSnipsSnippetDirectories = {'UltiSnips', '/home/nmorse/.config/UltiSnips'}
g.UltiSnipsEnableSnipMate = 0

-- git gutter
g.gitgutter_map_keys = 0  -- no mappings
opt.updatetime = 100  -- default wa 4000 which was much too slow

-- Deoplete
g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup

-- Airline
g['airline#extensions#tabline#enabled'] = 1

-- indentLine
g.indentLine_char = '┆'

-- Disable next-line autocommenting
cmd 'autocmd BufEnter * set fo-=c fo-=r fo-=o'

cmd 'autocmd BufRead *sqli set ft=sql'

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

lsp.pylsp.setup {
    root_dir = lsp.util.root_pattern('.git', fn.getcwd()),  
    settings = {
        pylsp = {
            configurationSources = {'flake8'},
            plugins = {
                flake8 = {enabled = true},
                pycodestyle = {enabled = false},
                pylint = {enabled = false},
                pydocstyle = {enabled = false},
                pyflakes = {enabled = false},
                mccabe = {enabled = false},
                yapf = {enabled = false},
            }
        }
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false -- turning off for now
            }
        )
    }
}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

-- only show diagnostics on hover
--cmd('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')

-- Nerd Commenter
g.NERDCreateDefaultMappings = 1
g.NERDDefaultAlign = 'left'

-- The vim.api.nvim_set_keymap() function allows you to define a new mapping
-- Specific behaviors such as noremap must be passed as a table to that function.
-- Here is a helper to create mappings with the noremap option set to true by default:
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Hop
require 'hop'.setup()

-- Mappings
g.mapleader = ' '
map('n', '<F1>', ':w<CR>')
map('n', '<Tab>', ':bn<CR>')
map('n', '<S-Tab>', ':bp<CR>')
map('n', '<F2>', ':noh<CR>')
map('', '<C-Space>', ":call nerdcommenter#Comment('n', 'Toggle')<CR>")
-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
local wk = require("which-key")
wk.register(
    {
        b = {":Black<CR>", "blacken"},
        i = {":History<CR>", "history"},
        h = {"<cmd>HopLine<CR>", "hop"},
        f = {
            name = "find+",
            f = {
                name = "files+",
                a = {"<cmd>cd ~/source/ace<cr><cmd>FZF<cr>", "ace"},
                h = {"<cmd>cd ~/<cr><cmd>FZF<cr>", "home"},
            },
            r = {"<cmd>Rg<cr>", "words"}
        },
        s = {"<cmd>set autochdir<cr>", "cd cwd"},
        y = {
            name = "completion+",
            d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "definition"},
            r = {"<cmd>lua vim.lsp.buf.references()<CR>", "references"},
        }
    },
    { prefix = '<leader>' }
)
require("which-key").setup {}

