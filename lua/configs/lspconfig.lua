require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "lua_ls" }

-- Configure LSP servers with Blink capabilities
local lspconfig = require("lspconfig")
local blink = require("blink.cmp")

-- Get base capabilities and extend with blink capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end

-- read :h vim.lsp.config for changing options of lsp servers 
