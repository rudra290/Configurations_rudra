-- Entry point for all Verilog / SystemVerilog config

require("verilog.templates")
require("verilog.snippets")
require("verilog.guards")
-- require("verilog.ale")   -- optional, safe to remove
require("verilog.completion")
require("verilog.lsp")
vim.filetype.add({
    extension = {
        v = "verilog",
        vh = "verilog",
        sv = "systemverilog",
        svh = "systemverilog",
    },
})
