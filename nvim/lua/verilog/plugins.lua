-- lua/verilog/plugins.lua

return {
    {
        "mingo99/verilog-autoinst.nvim",
        ft = { "verilog", "systemverilog" },
        cmd = "AutoInst",
        keys = {
            { "<leader>fv", "<cmd>AutoInst<cr>", desc = "Verilog: Auto instantiate module" },
        },
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    -- 1. Install LuaSnip (Snippet Engine)
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
            "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
        -- USE PCALL: This prevents the crash if the plugin is not installed yet
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            return
            end

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
            end,
    },

    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
        -- Optional: Custom configuration
        require('rainbow-delimiters.setup').setup {
            highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            },
        }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "BufReadPost",
        config = function()
        require("treesitter-context").setup({
            enable = true,
            max_lines = 4,          -- number of context lines
            trim_scope = "outer",   -- drop inner context first
            mode = "cursor",        -- context follows cursor
            separator = "─",
            zindex = 20,
        })
        end,
    }

}

