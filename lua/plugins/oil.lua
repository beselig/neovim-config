return {
  'stevearc/oil.nvim',
  -- oil is keymap-only: nvim-tree owns directory buffers (`nvim .`, `:e src/`),
  -- so oil must not hijack them. That's also what makes lazy-loading safe here
  -- (upstream only warns against it because of the directory-buffer takeover).
  keys = {
    { '_', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    { '-', '<CMD>Oil --float<CR>', desc = 'Open parent directory in floating window' },
  },
  opts = {
    default_file_explorer = false,
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
