return {
  'stevearc/oil.nvim',
  opts = {
    view_options = { show_hidden = true },
    -- Configuration for the file preview window
    preview_win = {
      -- Whether the preview window is automatically updated when the cursor is moved
      update_on_cursor_moved = true,
      -- How to open the preview window "load"|"scratch"|"fast_scratch"
      preview_method = 'fast_scratch',
      -- A function that returns true to disable preview on a file e.g. to avoid lag
      disable_preview = function(filename)
        return true
      end,
      -- Window-local options to use for preview window buffers
      win_options = {},
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
