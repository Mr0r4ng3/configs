-- Export the which-key plugin specification table for lazy.nvim
return {
  {
    -- Highly customizable keybinding popup cheatsheet
    "folke/which-key.nvim",

    -- Load immediately during startup so all prefix hints work on first keystroke
    event = "VeryLazy",

    -- Initialize which-key options
    opts = {
      -- Preset layout design ("classic", "modern", or "helix")
      preset = "modern",

      -- Delay in milliseconds before popup appears after pressing a prefix key
      delay = 200,

      -- Visual icons configuration
      icons = {
        -- Use nerd font icons for mapped commands
        mappings = true,
      },
    },

    -- Define global cheatsheet search trigger
    keys = {
      -- [Space + ?] -> Open interactive cheatsheet search over all configured keymaps
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer local keymaps cheatsheet",
      },
    },
  },
}
