-- Export the Treesitter plugin specification table for lazy.nvim
return {
  {
    -- Tree-sitter abstraction layer and parser manager for Neovim
    "nvim-treesitter/nvim-treesitter",

    -- Pin to the stable master branch where nvim-treesitter.configs is supported
    branch = "master",

    -- Automatically update all installed parsers whenever the plugin updates
    build = ":TSUpdate",

    -- Load plugin when opening an existing file or creating a new buffer
    event = { "BufReadPre", "BufNewFile" },

    -- Dependencies required for extended Treesitter features
    dependencies = {
      -- Automatically close and rename HTML/JSX/XML tags
      "windwp/nvim-ts-autotag",
    },

    -- Function executed after loading the plugin
    config = function()
      -- Import the treesitter configuration module safely
      local treesitter = require("nvim-treesitter.configs")

      -- Initialize Treesitter options
      treesitter.setup({
        -- Enable syntax highlighting based on the parsed AST
        highlight = {
          -- Turn on tree-sitter based highlighting
          enable = true,
          -- Disable built-in Vim regex highlighting to prevent performance degradation
          additional_vim_regex_highlighting = false,
        },

        -- Enable tree-sitter based intelligent code indentation
        indent = {
          -- Turn on syntax indentation
          enable = true,
        },

        -- Enable automatic closing and renaming of HTML/XML tags
        autotag = {
          -- Turn on nvim-ts-autotag integration
          enable = true,
        },

        -- List of language parsers guaranteed to be installed automatically
        ensure_installed = {
          -- Core Neovim configurations and documentation
          "lua",
          "vim",
          "vimdoc",
          "query",
          -- Common scripting and markup
          "bash",
          "markdown",
          "markdown_inline",
          "json",
          "yaml",
          "toml",
          -- Web development essentials
          "html",
          "css",
          "javascript",
          "typescript",
          "tsx",
          -- Systems and general programming
          "c",
          "python",
          "dockerfile",
          "gitignore",
        },

        -- Install parsers synchronously during startup (disabled to prevent UI freezes)
        sync_install = false,

        -- Automatically install missing parsers when opening unsupported filetypes
        auto_install = true,

        -- Enable incremental selection based on AST syntax nodes
        incremental_selection = {
          -- Turn on incremental selection module
          enable = true,
          -- Keymaps configuration for AST node selection
          keymaps = {
            -- [Ctrl + Space] -> Initialize node selection
            init_selection = "<C-space>",
            -- [Ctrl + Space] -> Expand selection to parent AST node
            node_incremental = "<C-space>",
            -- [Backspace] -> Shrink selection to child AST node
            node_decremental = "<bs>",
            -- [Ctrl + Backspace] -> Expand selection to outer syntax scope
            scope_incremental = "<C-s>",
          },
        },
      })
    end,
  },
}
