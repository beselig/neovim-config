print 'typescript file detected'
vim.opt_local.shiftwidth = 2
vim.keymap.set({ 'n', 'v', 'i' }, '<M-S-o>', '<cmd>:TSToolsOrganizeImports<CR>')
vim.keymap.set({ 'n', 'v', 'i' }, '<M-S-i>', '<cmd>:TSToolsAddMissingImports<CR>')
