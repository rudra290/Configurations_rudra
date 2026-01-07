-- lua/verilog/completion.lua

-- Safe load: If cmp isn't installed yet, stop here to avoid crash
local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
    return
    end
local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "buffer", keyword_length = 2 },
        { name = "luasnip" },
        { name = "path" },
    },
})

