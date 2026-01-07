-- Auto template for new Verilog / SystemVerilog files

local api = vim.api

-- Verilog (.v)
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.v",
    callback = function()
        local name = vim.fn.expand("%:t:r")
        api.nvim_buf_set_lines(0, 0, -1, false, {
            "module " .. name .. " (",
            ");",
            "",
            "endmodule",
        })
        api.nvim_win_set_cursor(0, { 2, 1 })
    end,
})

-- SystemVerilog (.sv)
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.sv",
    callback = function()
        local name = vim.fn.expand("%:t:r")
        api.nvim_buf_set_lines(0, 0, -1, false, {
            "module " .. name .. " (",
            "    input  logic clk,",
            "    input  logic rst_n",
            ");",
            "",
            "endmodule",
        })
        api.nvim_win_set_cursor(0, { 2, 5 })
    end,
})

