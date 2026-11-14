-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false

-- Indentação de 4 espaços (o LazyVim usa 2 por padrão). A tecla Tab insere espaços.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Corretor ortográfico em português e inglês (o dicionário vem do pacote vim-spell-pt).
vim.opt.spelllang = { "pt", "en" }
