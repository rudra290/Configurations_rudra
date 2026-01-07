vim.api.nvim_create_autocmd("FileType", {
    pattern = "verilog",
    callback = function()
        local forbidden = {
            "logic",
            "always_ff",
            "always_comb",
            "typedef",
            "interface",
            "package",
        }
        for _, kw in ipairs(forbidden) do
            vim.fn.matchadd("ErrorMsg", "\\<" .. kw .. "\\>")
        end
    end,
})

