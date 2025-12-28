return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires special font.
    --  If you already have a Nerd Font, or terminal set up with fallback fonts
    --  you can enable this
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    require('telescope').setup {
      pickers = {
        find_files = {
          theme = 'ivy',
        },
      },
      extensions = {
        fzf = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
            -- even more opts
          },
        },
      },
    }

    -- load extensions
    require('telescope').load_extension 'fzf'
    require('telescope').load_extension 'ui-select'

    -- local themes = require('telescope.themes')
    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '<C-[>', builtin.lsp_references)
    vim.keymap.set('n', '<space>sh', builtin.help_tags)
    vim.keymap.set('n', '<space>sf', builtin.git_files)
    vim.keymap.set('n', '<space>sd', builtin.diagnostics)
    vim.keymap.set('n', '<space>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end)
    vim.keymap.set('n', '<space>sp', function()
      builtin.find_files {
        ---@diagnostic disable-next-line: param-type-mismatch
        cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy'),
      }
    end)
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

    vim.keymap.set('n', '<space>sX', function()
      builtin.find_files {
        cwd = vim.fn.expand '$XDG_CONFIG_HOME',
      }
    end, { desc = 'Search $XDG_CONFIG_HOME' })

    require('config.telescope.multigrep').setup()
  end,
}
