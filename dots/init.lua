vim.g.mapleader = ' '  -- Set leader key before loading plugins

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged/')

Plug 'windwp/nvim-autopairs'  -- auto-close quotes, parens, brackets
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}) -- syntax highlighting and code understanding
Plug 'nvim-lualine/lualine.nvim'  -- status line with git info, file info, mode indicator
Plug 'luxed/ayu-vim'  -- ayu dark colorscheme
Plug 'folke/which-key.nvim'  -- popup showing available keybindings
Plug 'hrsh7th/nvim-cmp'  -- completion engine
Plug 'hrsh7th/cmp-nvim-lsp'  -- LSP completions (Python, etc)
Plug 'hrsh7th/cmp-buffer'  -- completions from current buffer text
Plug 'hrsh7th/cmp-path'  -- file path completions
Plug 'hrsh7th/cmp-cmdline'  -- command-line completions
Plug 'quangnguyen30192/cmp-nvim-ultisnips'  -- snippet completions
Plug 'phaazon/hop.nvim'  -- jump to any word or line with <leader>hw / <leader>hl
Plug 'numToStr/Comment.nvim'  -- toggle comments with <leader>c
Plug 'lewis6991/gitsigns.nvim'  -- show git diff markers, stage hunks, blame
Plug 'vim-scripts/BufOnly.vim'  -- close all buffers except current one
Plug('ibhagwan/fzf-lua', {['branch'] = 'main'})  -- fuzzy finder for files, text, help, etc
Plug 'tpope/vim-fugitive'  -- git integration (used for branch name in statusline)
Plug 'kkharji/sqlite.lua'  -- SQLite database for persistent storage (required by neoclip)
Plug 'AckslD/nvim-neoclip.lua'  -- clipboard history manager
Plug 'fisadev/vim-isort'  -- Python import sorter
-- Plug 'jose-elias-alvarez/null-ls.nvim'  -- for formatting/linting
Plug 'nvim-lua/plenary.nvim'  -- required by null-ls

vim.call('plug#end')

vim.g['python3_host_prog'] = '/home/nmorse/.virtualenvs/nvim/bin/python3'
vim.opt.expandtab = true  -- convert tabs to spaces
vim.opt.shiftwidth = 4  -- number of spaces for each indentation level
vim.opt.tabstop = 4  -- number of spaces that a tab counts for
vim.opt.smarttab = true  -- insert spaces according to shiftwidth at line start
vim.opt.number = true  -- show line numbers
vim.opt.wrap = false  -- don't wrap long lines
vim.opt.ignorecase = true  -- ignore case in search patterns
vim.opt.termguicolors = true  -- enable 24-bit RGB colors
vim.opt.lazyredraw = true  -- don't redraw screen during macros/scripts (faster)
vim.opt.cursorline = true  -- highlight the current line
vim.opt.formatoptions:remove({ 'c', 'r', 'o' })  -- disable auto-commenting on new lines


-- Highlight yanked text (built-in feature)
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 1500 })
    end
})

-- Disable diagnostics for git commit messages
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'gitcommit',
    callback = function()
        vim.diagnostic.enable(false)
    end
})

-- Auto-detect indentation for JS/TS files
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'json', 'html', 'css'},
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end
})

-- Better JSX/TSX commenting (works with Comment.nvim)
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'typescriptreact', 'javascriptreact'},
    callback = function()
        vim.bo.commentstring = '// %s'
    end
})

require('neoclip').setup({
    enable_persistent_history = true,
})

vim.lsp.enable('pylsp')
vim.lsp.config(
    'pylsp',
    {
        cmd = {vim.env.HOME .. '/.virtualenvs/nvim/bin/pylsp'},
        settings = {
            pylsp = {
                plugins = {
                    black = { enabled = true, line_length = 99 },
                    pycodestyle = { enabled = false },  -- disable style checking (line length, etc)
                    mccabe = { enabled = false },  -- disable complexity checking
                    flake8 = { enabled = false },  -- disable flake8 (it includes style checks)
                    pyflakes = { enabled = true },  -- keep syntax/error checking only
                }
            }
        }
    }
)

-- TypeScript LSP with custom diagnostic settings
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
    cmd = {'typescript-language-server', '--stdio'},
    on_attach = function(client, bufnr)
        -- These settings only apply to TypeScript buffers
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        }, bufnr)  -- Note the bufnr parameter - makes it buffer-local
    end
})

-- ESLint LSP
--vim.lsp.enable('eslint')
--vim.lsp.config('eslint', {
--    cmd = {'vscode-eslint-language-server', '--stdio'}
--})

-- local null_ls = require('null-ls')
-- null_ls.setup({
--     sources = {
--         null_ls.builtins.formatting.prettier,  -- auto-format JS/TS/JSON/CSS
--     },
-- })


-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup({
    -- Keybindings for completion
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),  -- trigger completion menu
        ['<C-e>'] = cmp.mapping.abort(),  -- close completion menu
        ['<CR>'] = cmp.mapping.confirm({ select = false }),  -- confirm selection only if explicitly selected
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()  -- cycle to next completion item
            else
                fallback()  -- normal tab behavior if menu not visible
            end
        end, { 'i', 's' }),  -- works in insert and select modes
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()  -- cycle to previous completion item
            else
                fallback()  -- normal shift-tab behavior if menu not visible
            end
        end, { 'i', 's' }),
    }),
    -- Completion sources (in priority order)
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },  -- LSP completions (Python, etc)
        { name = 'ultisnips' },  -- snippet completions
        { name = 'buffer' },  -- text from current buffer
        { name = 'path' },  -- file path completions
    })
})

-- Command-line completion for `/` search
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Command-line completion for `:` commands
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- nvim-autopairs setup
require('nvim-autopairs').setup({
    check_ts = true  -- use treesitter for smarter pairing
})

-- Integrate nvim-autopairs with nvim-cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- lualine setup
require('lualine').setup({
    options = {
        theme = 'ayu_dark',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    tabline = {
        lualine_a = {'buffers'},
        lualine_z = {'tabs'}
    },
})

-- Comment.nvim setup
require('Comment').setup()

-- gitsigns setup
require('gitsigns').setup({
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
})

require('nvim-treesitter').setup({
    ensure_installed = {
        'python',
        'lua',
        'typescript',
        'tsx',
        'javascript',
        'html',
        'css',
        'json'
    },
    highlight = {enable = true}, 
    indent = {enable = true}
})

require('hop').setup {}

-- vim.diagnostic.enable(false)  -- re-enabled after disabling E501 line length errors

vim.g.ayucolor = 'dark'
vim.cmd 'colorscheme ayu'

-- Customize completion menu colors for better contrast
vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1F2430', fg = '#CBCCC6' })  -- popup menu background/foreground
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#253340', fg = '#FFFFFF', bold = true })  -- selected item
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#1F2430' })  -- scrollbar background
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#3E4B59' })  -- scrollbar thumb
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#FFD580', bold = true })  -- matching characters highlighted
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#FFD580' })  -- fuzzy matching characters


local wk = require('which-key')
wk.add({
    { "n", "nzz", desc = "next and recenter" },
    { "N", "Nzz", desc = "previous and recenter" },
    { "<F1>", "<cmd>w<CR>", desc = "save" },
    { "<F2>", "<cmd>noh<CR>", desc = "remove highlights" },
    { "<Tab>", "<cmd>bn<CR>", desc = "next buffer" },
    { "<S-Tab>", "<cmd>bp<CR>", desc = "previous buffer" },

    { "<leader>b", group = "buffers" },
    { "<leader>bd", "<cmd>bd<CR>", desc = "delete" },
    { "<leader>bo", "<cmd>BufOnly<CR>", desc = "BufOnly" },

    { "<leader>c", function() require("Comment.api").toggle.linewise.current() end, desc = "toggle comment" },
    { "<leader>c", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", desc = "toggle comment", mode = "v" },

    { "<leader>h", group = "hop" },
    { "<leader>hl", "<cmd>HopLine<CR>", desc = "hop to line", mode = { "n", "v" } },
    { "<leader>hw", "<cmd>HopWord<CR>", desc = "hop to word", mode = { "n", "v" } },

    { "<leader>?", "<cmd>lua require('fzf-lua').help_tags()<CR>", desc = "help" },

    { "<leader>g", group = "goto" },
    { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "definition" },
    { "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "references" },

    { "<leader>d", group = "diagnostics" },
    { "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "show diagnostic" },
    { "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "next diagnostic" },
    { "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "previous diagnostic" },
    { "<leader>do", "<cmd>lua vim.diagnostic.setloclist()<CR>", desc = "open location list" },

    { "<leader>l", group = "location list" },
    { "<leader>lo", "<cmd>lopen<CR>", desc = "open" },
    { "<leader>lc", "<cmd>lclose<CR>", desc = "close" },

    { "<leader>f", group = "find" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "buffers" },
    { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "keymaps" },
    { "<leader>ff", group = "files" },
    { "<leader>ffh", "<cmd>FzfLua files<CR>", desc = "cwd (" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ")" },
    { "<leader>ffm", "<cmd>FzfLua git_status<CR>", desc = "modified" },
    { "<leader>ffr", "<cmd>FzfLua oldfiles<CR>", desc = "recent" },
    { "<leader>ffo", "<cmd>FzfLua files cwd=~/dotfiles<CR>", desc = "dotfiles" },

    { "<leader>fw", group = "words" },
    { "<leader>fwh", "<cmd>FzfLua live_grep<CR>", desc = "cwd (" .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ")" },

    { "<leader>w", "<cmd>w<CR>", desc = "write" },

    { "<leader>p", group = "python extras" },
    { "<leader>pb", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, desc = "blacken", mode = "n" },
    { "<leader>pb", function()
        -- Capture selection range while still in visual mode
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end

        -- Exit visual mode
        vim.cmd('normal! \\<Esc>')

        -- Save file
        vim.cmd('write')

        local filename = vim.api.nvim_buf_get_name(0)

        -- Call yapf with --lines for range formatting (black-compatible style)
        local cmd = string.format('%s/.virtualenvs/nvim/bin/yapf --style="{based_on_style: facebook, column_limit: 99}" --lines %d-%d -i "%s"',
            vim.env.HOME, start_line, end_line, filename)
        local result = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
            print("Yapf error: " .. result)
        end

        -- Reload buffer
        vim.cmd('checktime')
    end, desc = "format selection", mode = "v" },
    { "<leader>pi", "<cmd>Isort<CR>", desc = "isort" },

    { "<leader>r", '<cmd>lua require("neoclip.fzf")()<CR>', desc = "registers (neoclip)" },
    { "<leader>s", "<cmd>source ~/.config/nvim/init.lua<CR>", desc = "source config file" },
    { "<leader>t", group = "typescript/javascript" },
    { "<leader>tf", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, desc = "format (prettier)" },
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "hover documentation" },
})
require('which-key').setup {}
