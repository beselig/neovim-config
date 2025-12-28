return {
  { -- autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      stop_after_first = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        sql = { 'sqlfluff' },

        -- conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- you can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        vue = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        scss = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
      },
    },
  },
}
