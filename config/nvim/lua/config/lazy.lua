-- Define the target directory path where lazy.nvim will be cloned and installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed; clone repository if it is missing
if not vim.uv.fs_stat(lazypath) then
  -- Perform a shallow clone of lazy.nvim using git CLI
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  -- If git clone fails, abort execution and print the error message
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy.nvim directory to Neovim runtimepath so its modules can be required
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim configuration and plugin loaders
require("lazy").setup({
  -- Automatically discover and import plugin spec files from lua/plugins/
  spec = {
    { import = "plugins" },
  },

  -- Configure installer behavior and startup fallback theme
  install = {
    -- Colorscheme to try installing first and apply during lazy sync
    colorscheme = { "nord", "habamax" },
  },

  -- Automatically check for plugin updates in the background
  checker = {
    enabled = true,
    notify = false,
  },

  -- Enable change detection to auto-reload configuration on save
  change_detection = {
    notify = false,
  },

  -- Configure appearance of the lazy.nvim interactive UI window
  ui = {
    border = "rounded",
  },
})
