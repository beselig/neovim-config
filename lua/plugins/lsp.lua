-- astro-ls (and vue/ts tooling) refuse to initialize without a typescript
-- SDK. Projects without a local `typescript` dependency need a fallback,
-- otherwise `initialize` fails with:
--   The `typescript.tsdk` init option is required.
---@param dir string a `typescript/lib` directory
---@return string|nil dir if it actually holds a typescript SDK
local function tsdk_or_nil(dir)
  if vim.uv.fs_stat(vim.fs.joinpath(dir, 'typescript.js')) then
    return dir
  end
end

---Candidates are tried in order and evaluated lazily, so the global lookup in
---step 3 (which shells out) only runs when the cheaper ones miss.
local function resolve_tsdk(root_dir, mason_packages)
  -- 1. typescript installed in the project. `vim.fs.find` returns matches
  --    nearest-first, so a workspace package wins over the monorepo root.
  if root_dir then
    for _, dir in ipairs(vim.fs.find('node_modules', { path = root_dir, upward = true, type = 'directory', limit = math.huge })) do
      local tsdk = tsdk_or_nil(vim.fs.joinpath(dir, 'typescript', 'lib'))
      if tsdk then
        return tsdk
      end
    end
  end

  -- 2. the copy mason ships with typescript-language-server
  local mason_tsdk = tsdk_or_nil(vim.fs.joinpath(mason_packages, 'typescript-language-server', 'node_modules', 'typescript', 'lib'))
  if mason_tsdk then
    return mason_tsdk
  end

  -- 3. a globally installed typescript
  local global_tsdk = tsdk_or_nil(vim.fs.joinpath(require('config.lsp.npm').get_npm_root(), 'typescript', 'lib'))
  if global_tsdk then
    return global_tsdk
  end

  -- astro-ls would otherwise just fail `initialize` with no hint as to why
  vim.notify(
    ('astro-ls: no typescript SDK found for %s -- install typescript in the project or globally'):format(root_dir or vim.uv.cwd()),
    vim.log.levels.WARN
  )
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
      {
        'saghen/blink.cmp',
      },
    },
    config = function()
      local mason_packages = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'packages')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- MASON
      local servers = {
        astro = {
          -- replaces lspconfig's before_init, which only looks for a
          -- project-local typescript and hard-fails when there isn't one
          before_init = function(_, config)
            config.init_options = config.init_options or {}
            config.init_options.typescript = config.init_options.typescript or {}
            config.init_options.typescript.tsdk = resolve_tsdk(config.root_dir, mason_packages)
          end,
        },

        gopls = {},
        pyright = {},
        ruff = {},
        html = {},
        eslint = {},
        markdown_oxide = {},
        tailwindcss = {},

        postgres_lsp = {},

        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = '2',
                },
              },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        vue_ls = {},
        ts_ls = {
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vim.fs.joinpath(mason_packages, 'vue-language-server', 'node_modules', '@vue', 'language-server'),
                languages = { 'vue' },
                configNamespace = 'typescript',
              },
            },
          },
          filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        },
      }

      -- LSP servers only; formatters/linters are installed by conform.lua from
      -- its own `formatters_by_ft`, so there is no second list to keep in sync
      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

      -- every server is configured and enabled explicitly below, so mason must
      -- not auto-enable whatever else happens to be installed
      require('mason-lspconfig').setup { automatic_enable = false }

      -- register + enable per-server config
      for server_name, server in pairs(servers) do
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        vim.lsp.config(server_name, server)
        vim.lsp.enable(server_name)
      end

      -- load some custom utility functions
      require 'config.lsp.utils'

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          -- keymaps for all clients
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = args.buf })

          -- ts_ls-only keymaps
          if client.name == 'ts_ls' then
            -- e.g. organize imports via code action filter
            vim.keymap.set('n', '<leader>oi', function()
              vim.lsp.buf.code_action {
                apply = true,
                context = {
                  only = { 'source.organizeImports' },
                  diagnostics = {},
                },
              }
            end, { buffer = args.buf })
          end
        end,
      })
    end,
  },
}
