require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
-- local M = {}

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Telescope keymaps
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", function()
  require("telescope.builtin").git_status()
end, { desc = "Git status" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })

-- map("c", "o", { desc = "Git Conflict Choose Ours" })
-- map("c", "t", { desc = "Git Conflict Choose Theirs" })
-- map("c", "b", { desc = "Git Conflict Choose Both" })
-- map("c", "0", { desc = "Git Conflict Choose None" })

-- Live Preview keymaps
map("n", "<leader>lp", "<cmd>LivePreview start<cr>", { desc = "Live Preview Start" })
map("n", "<leader>lpp", "<cmd>LivePreview pick<cr>", { desc = "Live Preview Pick" })
map("n", "<leader>lpc", "<cmd>LivePreview close<cr>", { desc = "Live Preview Close" })

-- Outline keymap
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

-- Symbols keymaps
map("n", "<leader>s", "<cmd>Symbols<CR>", { desc = "Toggle Symbols" })
map("n", "<leader>S", "<cmd>SymbolsClose<CR>", { desc = "Close Symbols" })

-- LSP diagnostic command
map("n", "<leader>ld", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  
  local messages = {}
  
  if #clients == 0 then
    table.insert(messages, "No LSP clients attached to this buffer")
  else
    for _, client in ipairs(clients) do
      local supports_doc_symbol = client.server_capabilities.documentSymbolProvider ~= nil
      table.insert(messages, string.format(
        "LSP: %s - DocumentSymbol: %s",
        client.name,
        supports_doc_symbol and "?" or "?"
      ))
    end
  end
  
  -- Check outline provider
  local ok, outline_providers = pcall(require, 'outline.providers.init')
  if ok then
    local provider, info = outline_providers.find_provider()
    if provider then
      table.insert(messages, string.format("Outline Provider: %s", provider.name))
    else
      table.insert(messages, "Outline Provider: None found")
    end
  end
  
  -- Check treesitter parser
  local ft = vim.bo[bufnr].filetype
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if parser_ok and parser then
    local lang = parser:lang()
    table.insert(messages, string.format("Treesitter: %s (parser: %s)", ft, lang))
    
    -- Check if aerial query exists
    local query_ok, query = pcall(vim.treesitter.query.get, lang, "aerial")
    if query_ok and query then
      table.insert(messages, string.format("Aerial query: ? (found for %s)", lang))
    else
      table.insert(messages, string.format("Aerial query: ? (not found for %s)", lang))
    end
    
    -- Test treesitter provider directly
    local provider_ok, treesitter_provider = pcall(require, 'outline.providers.treesitter')
    if provider_ok then
      local supports, info = treesitter_provider.supports_buffer(bufnr)
      table.insert(messages, string.format("Treesitter provider: %s", supports and "? supports buffer" or "? doesn't support buffer"))
      if not supports then
        table.insert(messages, "  (This is why outline.nvim can't find a provider)")
      end
    end
  else
    table.insert(messages, string.format("Treesitter: %s (no parser)", ft))
    table.insert(messages, "  Try: :TSInstall typescript tsx")
  end
  
  vim.notify(table.concat(messages, "\n"), vim.log.levels.INFO)
end, { desc = "Check LSP & Outline Status" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
