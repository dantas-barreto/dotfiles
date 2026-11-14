-- C e C++: formatação com o clang-format (lê o .clang-format do projeto).
-- O autoformat global continua desligado em options.lua; aqui ele liga só nos buffers de C e C++.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.b.autoformat = true
  end,
})

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },
  -- O extra lang.clangd (lazyvim.json) instala o clangd pelo Mason; use o do sistema (/usr/bin/clangd).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { mason = false },
      },
    },
  },
}
