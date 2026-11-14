-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- TSV (cartões do Anki): o separador é uma tabulação de verdade, então a tecla Tab não pode virar espaços.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tsv" },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- Não formatar Markdown ao salvar: o markdownlint-cli2 reescreveria as notas.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(event)
    vim.b[event.buf].autoformat = false
  end,
})
