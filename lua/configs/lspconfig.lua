require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "lua_ls" }

-- Configure LSP servers with Blink capabilities
local lspconfig = require("lspconfig")
local blink = require("blink.cmp")

-- Get base capabilities and extend with blink capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = blink.get_lsp_capabilities(capabilities)

-- documentSymbol should already be in default capabilities, but ensure it's explicitly set
-- This is required for outline.nvim to work properly
if not capabilities.textDocument then
  capabilities.textDocument = {}
end
if not capabilities.textDocument.documentSymbol then
  capabilities.textDocument.documentSymbol = {
    dynamicRegistration = true,
    hierarchicalDocumentSymbolSupport = true,
  }
end

for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end

-- Register tsgo as a custom LSP server using the modern API
local configs = require("lspconfig.configs")
if not configs.tsgo then
  configs.tsgo = {
    default_config = {
      cmd = { 'tsgo', '--lsp', '--stdio' },
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
      },
      root_markers = {
        'tsconfig.json',
        'jsconfig.json',
        'package.json',
        '.git',
        'tsconfig.base.json',
      },
      single_file_support = true,
    },
  }
end

-- Configure tsgo with custom settings using the modern API
vim.lsp.config.add({
  name = "tsgo",
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = {
    'tsconfig.json',
    'jsconfig.json',
    'package.json',
    '.git',
    'tsconfig.base.json',
  },
  capabilities = capabilities,
  single_file_support = true,
  -- Ensure documentSymbol is enabled
  init_options = {},
})

-- Also setup via lspconfig for compatibility
if configs.tsgo then
  lspconfig.tsgo.setup({
    capabilities = capabilities,
    init_options = {},
  })
end

-- read :h vim.lsp.config for changing options of lsp servers 
