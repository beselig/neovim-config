return {
  {
    'MunifTanjim/prettier.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'jose-elias-alvarez/null-ls.nvim',
      'MunifTanjim/prettier.nvim',
    },
    opts = {
      bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
      filetypes = {
        'css',
        'graphql',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'less',
        'markdown',
        'scss',
        'typescript',
        'typescriptreact',
        'yaml',
        'prisma',
      },
    },
  },
}
