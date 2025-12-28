return {
  {
    'projekt0n/github-nvim-theme',
    lazy = false,
    priority = 1000,
  },
  {
    'f-person/auto-dark-mode.nvim',
    config = function()
      require('auto-dark-mode').setup {
        set_dark_mode = function()
          vim.api.nvim_set_option_value('background', 'dark', {})
          vim.cmd 'colorscheme github_dark_high_contrast'
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value('background', 'light', {})
          vim.cmd 'colorscheme github_light'
        end,
        update_interval = 3000,
        fallback = 'dark',
      }
    end,
  },
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = false,
  --   priority = 1001,
  --   config = function()
  --     -- setup must be called before loading
  --     vim.cmd 'colorscheme github_dark'
  --   end,
  -- },
  -- { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
  --   'folke/tokyonight.nvim',
  --   enabled = false,
  --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     -- vim.cmd.colorscheme 'tokyonight-day'
  --
  --     -- if macOSDark == 'Dark' then
  --     --   vim.cmd.colorscheme 'tokyonight-moon'
  --     -- else
  --     --   vim.cmd.colorscheme 'tokyonight-day'
  --     -- end
  --
  --     -- you can configure highlights by doing something like
  --     vim.cmd.hi 'comment gui=none'
  --   end,
  -- },
}
