-- Export formatting plugin specification table for lazy.nvim
return {
  {
    -- Lightweight yet powerful formatter runner for Neovim
    "stevearc/conform.nvim",

    -- Load plugin when reading an existing file or creating a new buffer
    event = { "BufReadPre", "BufNewFile" },

    -- Define keybindings to trigger manual formatting
    keys = {
      -- [Space + m + f] -> Manually format buffer or visual range
      {
        "<leader>mf",
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format buffer or visual selection",
      },
    },

    -- Plugin options and formatters by filetype
    opts = {
      -- Map filetypes to their corresponding formatters
      formatters_by_ft = {
        -- Lua code formatter
        lua = { "stylua" },

        -- Web development formatters (runs prettier on matching files)
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Python formatters (runs isort then black sequentially)
        python = { "isort", "black" },

        -- Shell script formatter
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- C and C++ formatter
        c = { "clang-format" },
        cpp = { "clang-format" },
      },

      -- Enable automatic format-on-save behavior
      format_on_save = {
        -- Fall back to LSP formatting if no standalone formatter is configured
        lsp_fallback = true,

        -- Synchronous formatting on save to avoid race conditions
        async = false,

        -- Max time in ms to wait for formatter to finish before saving
        timeout_ms = 1000,
      },
    },
  },
}
