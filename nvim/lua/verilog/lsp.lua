-- SystemVerilog LSP (svls) - Neovim 0.11+ native API

-- Safety guard
if not (vim.lsp and vim.lsp.config) then
    return
    end

    -- Register the server (once)
    vim.lsp.config("svls", {
        cmd = { "svls" },
        filetypes = { "systemverilog" },
        root_dir = function()
        return vim.fs.root(0, { ".git" }) or vim.loop.cwd()
        end,
    })

    -- Enable it
    vim.lsp.enable("svls")
