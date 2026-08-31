return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- LSP
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "basedpyright",
        "vtsls",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "yaml-language-server",

        -- Formatter
        "stylua",
        "black",
        "prettier",
        "gofumpt",
        -- rustfmt 不在 Mason 里，需通过 rustup 安装：rustup component add rustfmt
        "clang-format",

        -- Linter
        "golangci-lint",
        "ruff",
        "eslint",
      },
      auto_update = false,
      run_on_start = true,
    })
  end,
}
