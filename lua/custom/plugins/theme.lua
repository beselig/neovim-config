return {
  {
    'projekt0n/github-nvim-theme',
    enabled = false,
    lazy = false,
    priority = 1001,
    config = function()
      -- setup must be called before loading
      vim.cmd 'colorscheme github_dark'
      -- vim.cmd 'colorscheme github_light'
    end,
  },

  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    enabled = true,
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here.
      -- like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-day'
      vim.cmd.colorscheme 'tokyonight-moon'

      -- you can configure highlights by doing something like
      vim.cmd.hi 'comment gui=none'
    end,
  },
}
