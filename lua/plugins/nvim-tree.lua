return {
  {
    'nvim-tree/nvim-tree.lua',
    enabled = true,
    config = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true

      require('nvim-tree').setup {
        view = {
          width = 40,
        },

        -- replaced by the BufEnter autocmd below, which also collapses the
        -- branches the focused file is not part of. `update_root` is still
        -- read by `api.tree.find_file()`, so it stays declared here: keep the
        -- tree rooted at the project, don't follow files outside it.
        update_focused_file = {
          enable = false,
          update_root = { enable = false },
        },
      }

      -- Reveal the focused buffer in the tree, leaving *only* its ancestor
      -- chain expanded: collapse everything, then find the file, which
      -- re-expands the path down to it.
      local function reveal_focused_file()
        local api = require('nvim-tree.api')

        -- only sync a tree that is already on screen; never force it open
        if not api.tree.is_visible() then
          return
        end

        -- only reveal real, on-disk files: skip terminals, help, quickfix, the
        -- tree itself, unnamed buffers, and scheme buffers like `oil://`
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype ~= '' then
          return
        end

        local name = vim.api.nvim_buf_get_name(buf)
        if name == '' or name:match '^%w%w+://' then
          return
        end

        api.tree.collapse_all { keep_buffers = false }
        api.tree.find_file()
      end

      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('nvim-tree-reveal-focused', { clear = true }),
        callback = function()
          -- same debounce nvim-tree uses for its own version of this
          require('nvim-tree.utils').debounce('BufEnter:reveal_focused_file', 15, reveal_focused_file)
        end,
      })

      -- OR setup with some options
      -- require("nvim-tree").setup({
      --   sort = {
      --     sorter = "case_sensitive",
      --   },
      --   view = {
      --     width = 30,
      --   },
      --   renderer = {
      --     group_empty = true,
      --   },
      --   filters = {
      --     dotfiles = true,
      --   },
      -- })
    end,
  },
}
