-- Export the Language Server Protocol (LSP) configuration table for lazy.nvim
return {
  {
    -- Package manager for LSP servers, DAP servers, linters, and formatters
    "williamboman/mason.nvim",

    -- Load Mason when running these user commands directly
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },

    -- Dependencies required to bridge Mason and Neovim native LSP client
    dependencies = {
      -- Extension to easily integrate Mason with nvim-lspconfig
      "williamboman/mason-lspconfig.nvim",

      -- Quickstart configurations for the Neovim native LSP client
      "neovim/nvim-lspconfig",

      -- Additional Lua development configuration for Neovim config editing
      "folke/neodev.nvim",

      -- Completion capabilities source for nvim-cmp
      "hrsh7th/cmp-nvim-lsp",

      -- UI component for displaying standalone LSP progress status
      { "j-hui/fidget.nvim", opts = {} },
    },

    -- Load LSP suite when reading an existing file or creating a new buffer
    event = { "BufReadPre", "BufNewFile" },

    keys = {
      -- [Space + m] -> Open Mason package manager window
      { "<leader>m", "<cmd>Mason<CR>", desc = "Open Mason UI" },
    },

    -- Function executed after loading Mason and LSP dependencies
    config = function()
      -- Import required Lua modules safely
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local neodev = require("neodev")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- Setup neodev before lspconfig for proper Neovim Lua API completion
      neodev.setup()

      -- Initialize Mason package manager UI
      mason.setup({
        ui = {
          -- Set rounded border styling for Mason floating windows
          border = "rounded",
          -- Custom icons for Mason package status
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- List of LSP servers guaranteed to be installed automatically
      local servers = {
        -- Lua language server for Neovim configuration and plugins
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                -- Recognize vim global variable to prevent false diagnostic warnings
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
              },
              telemetry = {
                -- Disable telemetry tracking
                enable = false,
              },
            },
          },
        },
        -- Bash language server for shell scripts
        bashls = {},
        -- Python language server
        pyright = {},
        -- C / C++ language server
        clangd = {},
        -- JSON language server
        jsonls = {},
        -- Markdown language server
        marksman = {},
      }

      -- Define custom diagnostic symbols for the sign column
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Configure visual layout and behavior of LSP diagnostics
      vim.diagnostic.config({
        -- Show inline virtual text with diagnostic messages
        virtual_text = {
          prefix = "●",
        },
        -- Update diagnostics in insert mode (disabled to reduce visual distraction)
        update_in_insert = false,
        -- Underline problematic code sections
        underline = true,
        -- Show severity sort in sign column
        severity_sort = true,
        -- Configure floating diagnostic preview window
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Configure autocommand triggered whenever an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Helper function to map buffer-local LSP keybindings
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          -- [g + d] -> Jump to symbol definition via Snacks
          map("gd", function()
            Snacks.picker.lsp_definitions()
          end, "Go to definition")

          -- [g + D] -> Jump to symbol declaration
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- [g + r] -> List all references to symbol via Snacks
          map("gr", function()
            Snacks.picker.lsp_references()
          end, "Go to references")

          -- [g + I] -> Jump to symbol implementation via Snacks
          map("gI", function()
            Snacks.picker.lsp_implementations()
          end, "Go to implementation")

          -- [Space + D] -> Jump to type definition via Snacks
          map("<leader>D", function()
            Snacks.picker.lsp_type_definitions()
          end, "Type definition")

          -- [Space + d + s] -> Search document symbols via Snacks
          map("<leader>ds", function()
            Snacks.picker.lsp_symbols()
          end, "Document symbols")

          -- [Space + w + s] -> Search workspace symbols via Snacks
          map("<leader>ws", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "Workspace symbols")

          -- [K] -> Show hover documentation for symbol under cursor
          map("K", vim.lsp.buf.hover, "Hover documentation")

          -- [Ctrl + k] -> Show function signature help
          map("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")

          -- [Space + r + n] -> Smart rename symbol across entire project
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

          -- [Space + c + a] -> Select and execute code actions
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- [d + n] -> Jump to next diagnostic issue
          map("dn", vim.diagnostic.goto_next, "Go to next diagnostic")

          -- [d + p] -> Jump to previous diagnostic issue
          map("dp", vim.diagnostic.goto_prev, "Go to previous diagnostic")

          -- [Space + e] -> Open diagnostic message in a floating popup window
          map("<leader>e", vim.diagnostic.open_float, "Show line diagnostics")
        end,
      })

     -- Broadcast nvim-cmp capabilities to all LSP servers
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Configure Mason-LSPConfig auto-installation and handlers
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              settings = servers[server_name] and servers[server_name].settings or {},
            })
          end,
        },
      })
    end,
  },
}
