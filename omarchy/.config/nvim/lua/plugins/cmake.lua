-- CMake: formatação com o cmake-format (do pacote cmakelang, que o extra lang.cmake instala pelo Mason).
-- O autoformat global continua desligado em options.lua; aqui ele liga só nos buffers de CMake.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cmake" },
  callback = function()
    vim.b.autoformat = true
  end,
})

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cmake = { "cmake_format" },
      },
      formatters = {
        -- O conform passa o buffer pelo stdin, e assim o cmake-format não acha o arquivo de configuração do
        -- projeto: ele é procurado aqui, subindo a partir da pasta do arquivo, e passado com -c. O -c vai depois
        -- do "-" porque aceita vários arquivos e engoliria o "-", e o cmake-format não escreveria nada.
        cmake_format = {
          append_args = function(_, ctx)
            local config = vim.fs.find(
              { ".cmake-format.py", ".cmake-format.yaml", ".cmake-format.yml", ".cmake-format.json" },
              { path = ctx.dirname, upward = true }
            )[1]
            return config and { "-c", config } or {}
          end,
        },
      },
    },
  },
}
