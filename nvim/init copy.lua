-- ============================================================================
-- 0. BOOTSTRAP lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    end

    vim.opt.rtp:prepend(lazypath)

    -- Set leader keys (must be set before plugins)
    vim.g.mapleader = " "
    vim.g.maplocalleader = ","

    -- Disable netrw (Recommended by nvim-tree)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- ============================
    -- Plugins (single combined list)
    -- ============================
    local my_plugins = {
        { import = "verilog" },
        -- >> THEME <<
        {
            "navarasu/onedark.nvim",
            priority = 1000,
            config = function()
            require('onedark').setup { style = 'deep' }
            require('onedark').load()
            end
        },

        -- >> STATUSLINE <<
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
            require("lualine").setup({
                options = {
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    theme = "auto",
                    globalstatus = true,
                }
            })
            end,
        },
        -- lazy.nvim
        {
            "saghen/blink.indent",
            event = "BufReadPre",
            opts = {},
        },

        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
            },
        },
        {
            "neovim/nvim-lspconfig",
        },


        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
            require("nvim-tree").setup({
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = false },
            })
            end,
        },

        -- >> KEY BINDING HELPER (Which-Key) <<
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 200
            end,
            opts = {}
        },

        -- >> DASHBOARD <<
        require("dashboard"),

        -- Floating Terminal
        {
            "nvzone/floaterm",
            dependencies = "nvzone/volt",
            opts = {},
            cmd = "FloatermToggle",
        },

        -- >> FLOATING CMDLINE (Noice.nvim) <<
        {
            "folke/noice.nvim",
            event = "VeryLazy",
            opts = {
                cmdline = {
                    enabled = true,
                    view = "cmdline_popup", -- Center popup
                },
                messages = { enabled = true },
                popupmenu = { enabled = true }, -- Use Noice for the popup menu
            },
            dependencies = {
                "MunifTanjim/nui.nvim",
                "rcarriga/nvim-notify",
            }
        },


        -- >> UI ENHANCEMENTS <<
        "myusuf3/numbers.vim",
        "jiangmiao/auto-pairs",

        -- >> LANGUAGE SUPPORT <<
        "dense-analysis/ale",
        "lervag/vimtex",

        -- >> UTILITY <<
        "thaerkh/vim-workspace",
        "nanotee/zoxide.vim",
        { "mg979/vim-visual-multi", branch = "master" },
    }

    -- 1. Try to load external completion plugins safely
    local status_ok, completion_plugins = pcall(require, "plugins.completion")
    if status_ok then
        vim.list_extend(my_plugins, completion_plugins)
        end

        -- 2. Load Verilog Plugins (This adds your treesitter/autoinst/cmp configs)
        vim.list_extend(my_plugins, require("verilog.plugins"))

        -- 3. Setup lazy.nvim ONCE
        require("lazy").setup(my_plugins)

        -- 4. Load Verilog Runtime Config (Settings, snippets, etc.)
        -- This runs AFTER plugins are installed
        require("verilog")




    -- ============================================================================
    -- 2. GENERAL OPTIONS
    -- ============================================================================
    local opt = vim.opt

    opt.shell = vim.fn.executable("bash") == 1 and "/bin/bash" or "/bin/sh"
    opt.termguicolors = true
    opt.background = "dark"
    opt.cursorline = true
    opt.expandtab = true
    opt.shiftwidth = 4
    opt.tabstop = 4
    opt.hlsearch = true

    opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"


    -- ============================================================================
    -- 3. PLUGIN CONFIG (Globals & Autocommands)
    -- ============================================================================
    -- ALE
    vim.g.ale_lint_on_save = 1
    vim.g.ale_lint_on_text_changed = "normal"
    vim.g.ale_lint_on_insert_leave = 1
    vim.g.ale_lint_on_enter = 0
    vim.g.ale_virtualtext_cursor = 0



    -- VimTeX
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "okular"
    vim.g.vimtex_compiler_method = "latexmk"
    -- Level 2 shows formatted text, Level 0 shows raw code.
    -- This command switches to Level 0 (raw code) whenever you enter Insert Mode.
    vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = "*",
        callback = function() vim.opt.conceallevel = 0 end,
    })

    -- This switches back to Level 2 (formatted/hidden) when you leave Insert Mode.
    vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*",
        callback = function() vim.opt.conceallevel = 2 end,
    })

--     -- UltiSnips
--     vim.g.UltiSnipsExpandTrigger = "<tab>"
--     vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
--     vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"


    -- FIX: Clean Terminal UI (Removes the broken vertical lines)
    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
        -- 1. Disable Whitespace Markers (Fixes the broken | lines)
    vim.opt_local.list = false

    -- 2. Disable Line Numbers (Terminals don't need them)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"

    -- 3. Auto-start in Insert Mode
    vim.cmd("startinsert")
    end,
    })
    -- ============================================================================
    -- 4. KEYMAPS
    -- ============================================================================
    local keymap = vim.keymap.set

    -- Nvim-Tree Toggle (Leader + e)
    keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle File Explorer" })

    -- >> FLOATERM TOGGLE (Space + t) <<
    -- 1. Normal Mode: Open/Close
    keymap("n", "<leader>t", ":FloatermToggle<CR>", { silent = true, desc = "Toggle Terminal" })

    -- 2. Terminal Mode: Close while typing
    keymap("t", "<leader>t", "<C-\\><C-n>:FloatermToggle<CR>", { silent = true, desc = "Toggle Terminal" })

    -- 3. Exit Terminal Mode (Esc)
    keymap('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

    -- General Shortcuts
    keymap("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save File" })
    keymap("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
