return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "html", "cssls" },
      automatic_installation = true,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "stylua" },
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        pcall(require("mason-lspconfig").setup, {
          ensure_installed = { "html", "cssls" },
          automatic_installation = true,
        })

        pcall(require("mason-tool-installer").install)
      end, { desc = "Install all Mason LSPs and tools" })
    end,
  },
  {
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
          require("peek").setup()
          vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
          vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules/",
            ".git/",
            "%.lock",
            "%.log",
            "%.tmp",
            "%.cache",
            "%.DS_Store",
            "Thumbs.db",
            "lazy-lock.json",
            "%.stylua.toml",
          },
          find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/**' },
          -- Lock sorting strategy to ascending (top to bottom)
          sorting_strategy = "ascending",
          -- Ensure consistent layout
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
          },
        },
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/**' },
            sorting_strategy = "ascending",
          },
        },
      })
    end,
  },
  -- Blink completion engine
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    -- Use pre-built binaries instead of building from source
    lazy = false, -- Load immediately
    config = function()
      local blink = require("blink.cmp")
      
      blink.setup({
        keymap = { preset = "default" },
        appearance = {
          nerd_font_variant = "mono"
        },
        completion = {
          documentation = { auto_show = false }
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
      })
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}

