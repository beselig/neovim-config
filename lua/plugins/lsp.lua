return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
      },
      {
        'luckasRanarison/tailwind-tools.nvim',
        name = 'tailwind-tools',
        build = ':UpdateRemotePlugins',
        dependencies = {
          'nvim-treesitter/nvim-treesitter',
          'nvim-telescope/telescope.nvim', -- optional
          'neovim/nvim-lspconfig', -- optional
        },
      },
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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- MASON
      local servers = {
        -- clangd = {},
        gopls = {},
        pyright = {},
        html = {},

        postgres_lsp = {},

        -- ts_ls = {},
        -- vue_ls = {},

        lua_ls = {
          -- cmd = {...},
          capabilities = capabilities,
          format = {
            indent_size = 2,
          },
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
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
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
        'tailwindcss-language-server',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        automatic_installation = false,
        ensure_installed,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            vim.lsp.config(server_name, {
              on_attach = function(client, bufnr)
                vim.notify(client + 'attached to buffer: ' + bufnr)
              end,
            })
            -- require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- load some custom utility functions
      require 'config.lsp.utils'

      -- Typescript + Vue
      local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
      local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      local ts_ls_config = {
        init_options = {
          plugins = {
            vue_plugin,
          },
        },
        filetypes = tsserver_filetypes,
      }

      local vue_ls_config = {}

      vim.lsp.config('vue_ls', vue_ls_config)
      vim.lsp.config('ts_ls', ts_ls_config)
      vim.lsp.enable { 'ts_ls', 'vue_ls' } -- If using `ts_ls` replace `vtsls` to `ts_ls`

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

      require('tailwind-tools').setup {
        server = {
          capabilities = vim.lsp.ClientCapabilities,
          override = true, -- setup the server from the plugin if true
          settings = { -- shortcut for `settings.tailwindCSS`
            -- experimental = {
            --   classRegex = { "tw\\('([^']*)'\\)" }
            -- },
            -- includeLanguages = {
            --   elixir = "phoenix-heex",
            --   heex = "phoenix-heex",
            -- },
          },
        },
      }
    end,
  },
}
