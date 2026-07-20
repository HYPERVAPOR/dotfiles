return {
  -- 补充 CSS / HTML LSP（LazyVim 没有单独的 CSS/HTML extra）
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "css-lsp",
        "html-lsp",
      },
    },
  },
}
