print 'typescript file detected'
vim.opt_local.shiftwidth = 2
vim.keymap.set({ 'n', 'v', 'i' }, '<M-S-o>', function()
  require('config.lsp.ts_ls').organize_imports()
end)
