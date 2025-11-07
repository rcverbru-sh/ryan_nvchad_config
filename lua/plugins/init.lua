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

  {
    'brianhuster/live-preview.nvim',
    dependencies = {
      -- You can choose one of the following pickers
      'nvim-telescope/telescope.nvim',
      'ibhagwan/fzf-lua',
      'echasnovski/mini.pick',
		  'folke/snacks.nvim',
    },
    config = function()
      -- Setup live-preview (optional config)
      -- require('livepreview.config').set({})
      -- Add keymaps for live preview - using vim.schedule to ensure plugin is loaded
      vim.schedule(function()
        vim.keymap.set('n', '<leader>lp', '<cmd>LivePreview start<cr>', { desc = "Live Preview Start" })
        vim.keymap.set('n', '<leader>lpp', '<cmd>LivePreview pick<cr>', { desc = "Live Preview Pick" })
        vim.keymap.set('n', '<leader>lpc', '<cmd>LivePreview close<cr>', { desc = "Live Preview Close" })
      end)
    end,
  },

  {
    'akinsho/git-conflict.nvim', 
    version = "*",
    lazy = false,
    config = function()
      require('git-conflict').setup({
        default_mappings = true,
        default_commands = true,
        disable_diagnostics = false,
        highlights = {
          incoming = 'DiffAdd',
          current = 'DiffText',
        }
      })
    end,
  },

  {
    "hedyhli/outline.nvim",
    lazy = false,
    dependencies = {
      -- Treesitter provider for TypeScript/TSX when LSP doesn't support documentSymbol
      "epheien/outline-treesitter-provider.nvim",
    },
    config = function()
      -- Ensure TypeScript/TSX parsers are installed (NvChad includes treesitter but may not have these parsers)
      vim.schedule(function()
        local parsers = { "typescript", "tsx", "javascript", "jsx" }
        for _, parser in ipairs(parsers) do
          pcall(vim.cmd, "TSInstall " .. parser)
        end
      end)
      
      require("outline").setup({
        -- Configure providers - prioritize treesitter for TypeScript/TSX since tsgo doesn't support documentSymbol
        providers = {
          -- Try treesitter first, then LSP as fallback
          priority = { 'treesitter', 'lsp', 'coc', 'markdown', 'norg', 'man' },
          lsp = {
            -- Don't blacklist tsgo, but treesitter will be used first
            blacklist_clients = {},
          },
        },
      })
    end,
  },
}

