return {
  -- TypeScript / JavaScript（已有，保留显式声明）
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Python
  { import = "lazyvim.plugins.extras.lang.python" },

  -- Go
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Rust
  { import = "lazyvim.plugins.extras.lang.rust" },

  -- Tailwind CSS
  { import = "lazyvim.plugins.extras.lang.tailwind" },

  -- C / C++
  { import = "lazyvim.plugins.extras.lang.clangd" },

  -- JSON / YAML / TOML（常用配置文件）
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.toml" },

  -- Markdown
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- 补充 CSS LSP（LazyVim 没有单独的 CSS extra）
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
