require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "lua_ls" }

-- Configure LSP servers with Blink capabilities
local lspconfig = require("lspconfig")
local blink = require("blink.cmp")

for _, server in ipairs(servers) do
  local capabilities = blink.get_lsp_capabilities()
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end

-- read :h vim.lsp.config for changing options of lsp servers 
