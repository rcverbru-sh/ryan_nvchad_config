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
    'akinsho/git-conflict.nvim',
    version = "*",
    lazy = false, -- Load immediately
    config = function()
      require('git-conflict').setup({
        default_mappings = true, -- load default mappings
        default_commands = true, -- load default commands
        disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
        list_opener = 'copen', -- command or function to open the conflicts list
        highlights = { -- They must have background color, otherwise the default color will be used
          incoming = 'DiffAdd',
          current = 'DiffText',
        }
      })
    end,
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
  -- Disable nvim-cmp from NvChad to prevent conflicts with blink.cmp
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
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
      
      -- Add custom keymaps after setup
      local keymap = vim.keymap.set
      keymap("i", "<Tab>", function()
        if blink.is_visible() then
          blink.select_next()
        else
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n")
        end
      end, { desc = "Next completion or insert tab" })
      
      keymap("i", "<S-Tab>", function()
        if blink.is_visible() then
          blink.select_prev()
        else
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n")
        end
      end, { desc = "Previous completion or insert shift-tab" })
      
      keymap("i", "<CR>", function()
        if blink.is_visible() then
          blink.accept()
        else
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n")
        end
      end, { desc = "Accept completion or insert newline" })
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

