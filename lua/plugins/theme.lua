return {
  { 'rose-pine/neovim', name = 'rose-pine', lazy = false, priority = 1000 },
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
    -- config = function()
    --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --   -- vim.cmd.colorscheme 'tokyonight-day'
    --
    --   -- if macOSDark == 'Dark' then
    --   --   vim.cmd.colorscheme 'tokyonight-moon'
    --   -- else
    --   --   vim.cmd.colorscheme 'tokyonight-day'
    --   -- end
    --
    --   -- you can configure highlights by doing something like
    --   vim.cmd.hi 'comment gui=none'
    -- end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    config = function()
      require('auto-dark-mode').setup {
        set_dark_mode = function()
          -- require('github-theme').setup {}
          vim.api.nvim_set_option_value('background', 'dark', {})
          -- vim.cmd 'colorscheme github_dark'
          require('rose-pine').setup {
            styles = {
              transparency = true,
            },
          }
          vim.cmd 'colorscheme rose-pine-moon'
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value('background', 'light', {})
          require('rose-pine').setup {
            styles = {
              transparency = true,
            },
          }
          vim.cmd 'colorscheme rose-pine'
          -- vim.cmd 'colorscheme github_light'
          -- vim.cmd 'colorscheme tokyonight-day'
        end,
        update_interval = 3000,
        fallback = 'dark',
      }
    end,
  },
}
