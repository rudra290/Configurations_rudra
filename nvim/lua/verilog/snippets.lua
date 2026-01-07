-- lua/verilog/snippets.lua

-- Safe load: If luasnip isn't installed yet, stop here to avoid crash
local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
    end

local ls  = require("luasnip")
local s   = ls.snippet
local i   = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- filename helper
local function fname()
    return vim.fn.expand("%:t:r")
end

-- SystemVerilog snippets
ls.add_snippets("systemverilog", {
    s("aff", fmt([[
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {}
    end else begin
        {}
    end
end
]], { i(1), i(2) })),
})

-- Verilog snippets
ls.add_snippets("verilog", {
    s("aff", fmt([[
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {}
    end else begin
        {}
    end
end
]], { i(1), i(2) })),
})

