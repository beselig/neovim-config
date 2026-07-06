return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = {
      styles = {
        transparency = true,
      },
    },
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false,
    priority = 1000,
  },
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },
  {
    'f-person/auto-dark-mode.nvim',
    config = function()
      vim.cmd 'colorscheme tokyonight-night'
      require('auto-dark-mode').setup {
        set_dark_mode = function()
          vim.api.nvim_set_option_value('background', 'dark', {})
          vim.cmd 'colorscheme tokyonight-night'
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value('background', 'light', {})
          vim.cmd 'colorscheme github_light_high_contrast'
        end,
        update_interval = 3000,
        fallback = 'dark',
      }
    end,
  },
}
