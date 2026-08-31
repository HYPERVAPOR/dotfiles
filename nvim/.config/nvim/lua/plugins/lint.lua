return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      go = { "golangcilint" },
      python = { "ruff" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      javascriptreact = { "eslint" },
      typescriptreact = { "eslint" },
    }

    -- 保存时自动 lint
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
