return {
  { -- autoformat
    'stevearc/conform.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      stop_after_first = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        sql = { 'sqlfluff' },

        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        graphql = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        less = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        prisma = { 'prettierd', 'prettier', stop_after_first = true },
        rust = { 'rustfmt', lsp_format = 'fallback' },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      -- Install everything `formatters_by_ft` references, so the tool list is
      -- never maintained separately from the formatters actually in use.
      -- LSP servers are installed by mason-tool-installer over in lsp.lua.

      -- formatters mason does not package (rustfmt ships with rustup)
      local unmanaged = { rustfmt = true }

      local wanted = {}
      for _, formatters in pairs(opts.formatters_by_ft) do
        -- ipairs skips the keyed entries (`stop_after_first`, `lsp_format`)
        for _, name in ipairs(formatters) do
          if not unmanaged[name] then
            wanted[name] = true
          end
        end
      end

      local registry = require 'mason-registry'
      registry.refresh(function()
        vim.schedule(function()
          for name in pairs(wanted) do
            local ok, pkg = pcall(registry.get_package, name)
            if not ok then
              vim.notify(("conform: no mason package for formatter '%s'"):format(name), vim.log.levels.WARN)
            elseif not pkg:is_installed() then
              pkg:install()
            end
          end
        end)
      end)
    end,
  },
}
