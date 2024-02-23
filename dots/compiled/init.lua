local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged/')

Plug 'neovim/nvim-lspconfig'  -- config for the nvim lsp client
Plug 'jiangmiao/auto-pairs' -- auto quotes, parens, etc
Plug 'nvim-treesitter/nvim-treesitter'  -- treesitter interface for neovim
Plug 'vim-airline/vim-airline'  -- fancier status line and buffer labels
Plug 'luxed/ayu-vim'  -- colorscheme
Plug('shougo/deoplete.nvim', {['do'] = ':UpdateRemotePlugins'})  -- autocompletion
Plug 'deoplete-plugins/deoplete-lsp'
Plug 'folke/which-key.nvim'  -- keybinding
Plug 'phaazon/hop.nvim'  -- easier movement
Plug 'scrooloose/nerdcommenter'  -- commenting
Plug 'machakann/vim-highlightedyank' -- self-explanatory
Plug 'airblade/vim-gitgutter'  -- show git diff in the sign column
Plug 'vim-scripts/BufOnly.vim'  -- close all but the current buffer
Plug('ibhagwan/fzf-lua', {['branch'] = 'main'})
Plug 'tpope/vim-fugitive' -- mainly just so I can have the branch name on the status line
Plug 'AckslD/nvim-neoclip.lua' -- clipboard manager
-- Python
Plug 'psf/black'
Plug 'fisadev/vim-isort'
Plug 'Vimjas/vim-python-pep8-indent'  -- fixes weird vim-jedi double indent

vim.call('plug#end')

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.lazyredraw = true
vim.opt.cursorline = true

vim.cmd 'autocmd BufEnter * set fo-=c fo-=r fo-=o' -- Disable next-line autocommenting           
vim.cmd 'autocmd BufRead *py call deoplete#custom#source("_", "ignore_case", v:true)'


require('neoclip').setup {}

local lspconfig = require('lspconfig')
lspconfig.pylsp.setup {
    root_dir = function() return "/opt/ecn/users/" .. vim.env.USER .. "/source/ecn/source/python" end,
    cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
}

local ts = require('nvim-treesitter.configs')
ts.setup {highlight = {enable = true}}

require('hop').setup {}

vim.diagnostic.disable()  -- causing way too much clutter

vim.g['airline#extensions#tabline#enabled'] = 1  -- show buffers

vim.g['deoplete#enable_at_startup'] = true

vim.g.ayucolor = 'dark'
vim.cmd 'colorscheme ayu'

vim.g['gitgutter_map_keys'] = 0  -- hide the default mappings in whichkey

vim.g['black_virtualenv'] = '/home/nmorse/.virtualenvs/nvim'
vim.g['black_linelength'] = 99


-- The vim.api.nvim_set_keymap() function allows you to define a new mapping
-- Specific behaviors such as noremap must be passed as a table to that function.
-- Here is a helper to create mappings with the noremap option set to true by default:
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' '
map('', '<C-Space>', ":call nerdcommenter#Comment('n', 'Toggle')<CR>")
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})  -- forward cycle through completion options
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})  -- backward cycle through completion options
map('i', '<CR>', 'pumvisible() ? "\\<C-y><CR>" : "\\<CR>"', {expr = true})  -- if pop-up menu visible, close pop-up and enter newline
map('', '<Leader>hl', '<cmd>HopLine<CR>')
map('', '<Leader>hw', '<cmd>HopWord<CR>')

local function trim(s)
    -- trim string to the last 25 characters; useful for displaying lengthy file paths
    local maxlen = 25
    if string.len(s) > maxlen then
        return '...' .. string.sub(s, string.len(s) - maxlen)
    else
        return s
    end
end

local wk = require('which-key')
wk.register({
    ['n'] = {"nzz", "next and recenter"},
    ['N'] = {"Nzz", "previous and recenter"},
    ['<F1>'] = {"<cmd>w<CR>", "save"},
    ['<F2>'] = {"<cmd>noh<CR>", "remove highlights"},
    ['<Tab>'] = {"<cmd>bn<CR>", "next buffer"},
    ['<S-Tab>'] = {"<cmd>bp<CR>", "previous buffer"},
})
wk.register(
    {
        b = {
            name = "buffers",
            d = {"<cmd>bd<CR>", "delete"},
            o = {"<cmd>BufOnly<CR>", "BufOnly"},
        },
        c = { name = 'NerdCommenter' }, -- use all the NerdCommenter default mappings here
        h = { "<cmd>lua require('fzf-lua').help_tags()<CR>", "help" },
        g = {
            name = 'goto',
            d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "definition"},
            r = {"<cmd>lua vim.lsp.buf.references()<CR>", "references"}
        },
        f = {
            name = 'find',
            f = {
                name = 'files',
                a = {'<cmd>FzfLua files cwd=~/ace/<CR>', 'ace'},
                h = {'<cmd>FzfLua files<CR>', trim(vim.fn.getcwd())},
                m = {'<cmd>FzfLua git_status<CR>', 'modified'},
                r = {'<cmd>FzfLua oldfiles<CR>', 'recent'},
                o = {'<cmd>FzfLua find_files cwd=~/dotfiles<CR>', 'dotfiles'}
            },
            w = {
                name = 'words',
                a = {'<cmd>FzfLua live_grep cwd=~/ace/<CR>', 'ace'},
                h = {'<cmd>FzfLua live_grep<CR>', trim(vim.fn.getcwd())},
            }
        },
        w = {'<cmd>w<CR>', 'write'},
        p = {
            name = 'python extras',
            b = {'<cmd>Black<CR>', 'blacken'},
            i = {'<cmd>Isort<CR>', 'isort'}
        },
        r = { '<cmd>lua require("neoclip.fzf")()<CR>', 'registers (neoclip)' },
        s = { '<cmd>source ~/.config/nvim/init.lua<CR>', 'source config file' },
    },
    { prefix = '<leader>' }
)
require('which-key').setup {}