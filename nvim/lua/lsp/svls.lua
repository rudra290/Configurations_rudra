-- lua/lsp/svls.lua
-- Modern svls config: prefer vim.lsp.config on Neovim 0.11+
local function safe_require(name)
local ok, mod = pcall(require, name)
return ok and mod or nil
end

local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")

-- basic capabilities (enhanced with cmp if available)
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- optional on_attach helper
  local function on_attach(client, bufnr)
  local buf = function(lhs, rhs, desc)
  if desc then desc = "LSP: " .. desc end
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
    buf("gd", vim.lsp.buf.definition, "goto definition")
    buf("K", vim.lsp.buf.hover, "hover")
    buf("<leader>rn", vim.lsp.buf.rename, "rename")
    buf("gr", vim.lsp.buf.references, "references")
    end

    -- config table for svls
    local svls_config = {
      cmd = { "svls" }, -- uses svls in PATH
      filetypes = { "verilog", "systemverilog", "sv", "v" },
      root_dir = function(fname)
      -- optionally use git root or default to cwd
      local util = safe_require("lspconfig.util")
      if util and util.find_git_root then
        return util.find_git_root(fname) or vim.loop.cwd()
        end
        return vim.loop.cwd()
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {}, -- add svls-specific settings here if needed
    }

    -- If the new native API exists, register the config with vim.lsp.config
    if vim.lsp and vim.lsp.config then
      -- register / extend the server config
      vim.lsp.config("svls", svls_config)

      -- enable it now (this attaches to buffers matching filetypes)
      -- If you prefer on-demand activation, remove the next line and call `:lua vim.lsp.enable('svls')` manually.
      pcall(vim.lsp.enable, "svls")
      else
        -- Fallback for older nvim-lspconfig usage (keeps backward compatibility)
        local lspconfig = safe_require("lspconfig")
        if lspconfig and lspconfig.svls then
          pcall(function() lspconfig.svls.setup(svls_config) end)
          else
            vim.notify("svls/lspconfig not available; LSP disabled for SystemVerilog", vim.log.levels.WARN)
            end
            end
