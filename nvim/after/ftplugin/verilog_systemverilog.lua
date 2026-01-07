-- Normalize verilog_systemverilog to proper filetypes
local ext = vim.fn.expand("%:e")

if ext == "sv" then
    vim.bo.filetype = "systemverilog"
    else
        vim.bo.filetype = "verilog"
        end
