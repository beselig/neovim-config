require 'kickstart.health'

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

require 'config.lazy'

-- keymaps to quickly resource or run current file or selection
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')
-- keymaps for Oil

local oil = pcall(require, 'oil')
if oil then
  vim.keymap.set('n', '_', '<CMD>Oil --float<CR>', { desc = 'Open parent directory in floating window' })
  vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
else
  vim.notify('init.lua: Cannot set keymaps for Oil when Oil is not loaded', vim.log.levels.WARN)
end

-- [[ OPTIONS ]] --

vim.opt.laststatus = 3
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- cursor style
vim.opt.guicursor = 'n-v-c-i:block'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 50

-- wrap lines
vim.opt.wrap = false

-- [[ KEYMAPS ]] --
-- exist insert mode through j / k
vim.keymap.set('i', 'jj', '<Esc>j')
vim.keymap.set('i', 'kk', '<Esc>k')

--  Use CTRL+<hjkl> to switch between windows (See `:help wincmd`)
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- buffer related
vim.keymap.set('n', '<leader>p', function()
  vim.fn.setreg('+', vim.api.nvim_buf_get_name(0))
end, { desc = 'Copy relative path of current buffer' })

-- Navigating quickfix
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- LSP keymaps
vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action)
vim.keymap.set('i', 'gd', vim.lsp.buf.definition)

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)

-- macro keymaps
vim.keymap.set('v', '@', '":norm @" . getcharstr() . "<cr>"', { expr = true })
vim.keymap.set('n', '<M-q>', function()
  vim.cmd ':bd'
end)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require 'config.terminal'

vim.notify 'Happy coding'
