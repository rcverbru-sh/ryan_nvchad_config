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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
