-- Export the autocompletion suite plugin specification table for lazy.nvim
return {
  {
    -- Autocompletion engine plugin for Neovim
    "hrsh7th/nvim-cmp",

    -- Load completion engine whenever entering insert mode
    event = "InsertEnter",

    -- Source providers, snippet engines, and UI icon extensions
    dependencies = {
      -- Snippet Engine written in Lua
      {
        "L3MON4D3/LuaSnip",
        -- Build step for regex support in snippets (requires make)
        build = "make install_jsregexp",
      },

      -- Bridge LuaSnip with nvim-cmp completion sources
      "saadparwaiz1/cmp_luasnip",

      -- Completion source for Neovim native LSP client
      "hrsh7th/cmp-nvim-lsp",

      -- Completion source for filesystem paths
      "hrsh7th/cmp-path",

      -- Completion source for text words inside the current buffer
      "hrsh7th/cmp-buffer",

      -- Curated set of community snippets for multiple languages
      "rafamadriz/friendly-snippets",

      -- VS Code-like pictograms for the completion menu
      "onsails/lspkind.nvim",
    },

    -- Function executed after loading cmp and dependencies
    config = function()
      -- Import required Lua modules safely
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load VS Code style snippets from installed plugins (friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Configure nvim-cmp setup options
      cmp.setup({
        -- Configure snippet expansion handler
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Style completion popup and documentation windows with rounded borders
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- Define keybindings inside the autocompletion menu
        mapping = cmp.mapping.preset.insert({
          -- [Ctrl + k] -> Move to previous item in suggestion list
          ["<C-k>"] = cmp.mapping.select_prev_item(),

          -- [Ctrl + j] -> Move to next item in suggestion list
          ["<C-j>"] = cmp.mapping.select_next_item(),

          -- [Ctrl + b] -> Scroll documentation window backwards
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),

          -- [Ctrl + f] -> Scroll documentation window forwards
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- [Ctrl + Space] -> Manually trigger autocompletion popup
          ["<C-Space>"] = cmp.mapping.complete(),

          -- [Ctrl + e] -> Abort and close autocompletion popup
          ["<C-e>"] = cmp.mapping.abort(),

          -- [Enter] -> Confirm selected suggestion
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          -- [Tab] -> Super-tab: Next item or expand/jump snippet placeholder forward
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- [Shift + Tab] -> Previous item or jump snippet placeholder backward
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Define active completion sources and priority order
        sources = cmp.config.sources({
          -- 1. LSP suggestions (highest priority)
          { name = "nvim_lsp" },
          -- 2. Snippet suggestions
          { name = "luasnip" },
          -- 3. File system paths
          { name = "path" },
          -- 4. Current buffer text words (lowest priority)
          { name = "buffer", keyword_length = 3 },
        }),

        -- Configure visual presentation and icons in completion menu
        formatting = {
          format = lspkind.cmp_format({
            -- Show both pictogram symbol and text label
            mode = "symbol_text",
            -- Max width of completion popup before truncating
            maxwidth = 50,
            -- Character to show when truncating long items
            ellipsis_char = "...",
            -- Show source origin label next to completion item
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              path = "[Path]",
              buffer = "[Buffer]",
            },
          }),
        },
      })
    end,
  },
}
