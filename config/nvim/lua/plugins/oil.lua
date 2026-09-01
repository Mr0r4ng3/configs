-- Export oil.nvim file manager specification table for lazy.nvim
return {
  {
    -- File explorer that lets you edit your filesystem like a regular buffer
    "stevearc/oil.nvim",

    -- Optional icon provider for filetype rendering
    dependencies = { "nvim-tree/nvim-web-devicons" },

    -- Load immediately when opening a directory path directly
    lazy = false,

    -- Keymaps to trigger oil.nvim
    keys = {
      -- [-] -> Open oil file manager in the parent directory of current file
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory with Oil" },

      -- [Space + o] -> Open oil in a floating popup window
      {
        "<leader>o",
        function()
          require("oil").open_float()
        end,
        desc = "Open Oil in floating window",
      },
    },

    -- Plugin options and keybinding configurations
    opts = {
      -- Use default keymaps provided by oil
      default_file_explorer = true,

      -- Columns to show in the buffer list
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      -- Buffer options specific to oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      -- Configuration for floating window mode
      float = {
        padding = 2,
        max_width = 90,
        max_height = 30,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },

      -- Action mappings while inside an oil buffer
      keymaps = {
        -- [Enter] -> Open file or enter directory
        ["<CR>"] = "actions.select",

        -- [Ctrl + v] -> Open selected file in vertical split
        ["<C-v>"] = "actions.select_vsplit",

        -- [Ctrl + s] -> Open selected file in horizontal split
        ["<C-s>"] = "actions.select_split",

        -- [Ctrl + t] -> Open selected file in a new tab
        ["<C-t>"] = "actions.select_tab",

        -- [Ctrl + p] -> Preview file in a popup window
        ["<C-p>"] = "actions.preview",

        -- [-] -> Navigate up to parent directory
        ["-"] = "actions.parent",

        -- [_] -> Open current working directory
        ["_"] = "actions.open_cwd",

        -- [Ctrl + h] -> Toggle hidden (dot) files visibility
        ["g."] = "actions.toggle_hidden",

        -- [q] -> Close oil buffer and restore previous window
        ["q"] = "actions.close",
      },

      -- View options
      view_options = {
        -- Show hidden files by default (dotfiles)
        show_hidden = true,

        -- Natural sort for file names
        natural_order = true,
      },
    },
  },
}
