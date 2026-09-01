-- Export the plugin specification table for lazy.nvim
return {
  {
    -- Repository URL for the Nord colorscheme plugin
    "shaunsingh/nord.nvim",

    -- Do not lazy-load the colorscheme so it renders immediately on startup
    lazy = false,

    -- Give this plugin maximum load priority over UI elements and other plugins
    priority = 1000,

    -- Function executed after downloading and loading the plugin
    config = function()
      -- Enable transparent background integration with your terminal
      vim.g.nord_disable_background = false

      -- Make border outlines visible in floating popup windows
      vim.g.nord_borders = true

      -- Apply the Nord theme as the active colorscheme in Neovim
      vim.cmd.colorscheme("nord")
    end,
  },
}
