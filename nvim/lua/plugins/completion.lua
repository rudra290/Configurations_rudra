-- File: lua/plugins/completion.lua
-- Usage:
-- 1) Save this file as: ~/.config/nvim/lua/plugins/completion.lua
-- 2) In your main init.lua where you call require('lazy').setup({ ... }), merge or append
--    the returned table from this file. Example:
--
--    local completion_plugins = require('plugins.completion')
--    require('lazy').setup(vim.list_extend(my_existing_plugins, completion_plugins))
--
-- Or, if you want to load only these plugins temporarily for testing, you can do:
--    require('lazy').setup(require('plugins.completion'))
--
-- This module returns a table of plugin specifications for lazy.nvim which
-- provide nvim-cmp + LuaSnip + friendly-snippets and a small lspconfig entry
-- for svls (SystemVerilog language server). It is defensive: it avoids hard
-- failures if optional modules aren't present.

local M = {}

M.plugins = {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind-nvim",
    },
    config = function()
      local ok_cmp, cmp = pcall(require, "cmp")
      if not ok_cmp then return end
      local ok_luasnip, luasnip = pcall(require, "luasnip")
      if not ok_luasnip then
        luasnip = nil
      end

      -- Load friendly-snippets (VSCode-style) lazily if LuaSnip is available
      if luasnip then
        pcall(function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end)
      end

      -- lspkind for icons (optional)
      local ok_lspkind, lspkind = pcall(require, "lspkind")
      if not ok_lspkind then
        lspkind = nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            if luasnip then
              require("luasnip").lsp_expand(args.body)
            end
          end,
        },

        mapping = cmp.mapping and cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }) or {},

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),

        formatting = {
          format = lspkind and lspkind.cmp_format({ with_text = true, maxwidth = 80 })
                   or nil,
        },

        experimental = { ghost_text = false },
      })
    end,
  },

--   -- Optional: LSP config entry for svls (SystemVerilog Language Server). This
--   -- assumes svls is installed on your system. If you don't use svls, you can
--   -- safely remove this block.
--   {
--     "neovim/nvim-lspconfig",
--     config = function()
--       local ok, lspconfig = pcall(require, "lspconfig")
--       if not ok then return end
--       -- Wrap in pcall because svls may not be installed on the host
--       pcall(function()
--         lspconfig.svls.setup({})
--       end)
--     end,
--   },
}

return M.plugins

