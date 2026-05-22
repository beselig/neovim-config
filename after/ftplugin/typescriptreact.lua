print 'typescript file detected'
vim.opt_local.shiftwidth = 2
vim.keymap.set({ 'n', 'v', 'i' }, '<M-S-o>', '<cmd>:LspTypescriptSourceAction<CR>')

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    require('config.lsp.ts_ls').organize_imports(args.buf)
  end,
})
