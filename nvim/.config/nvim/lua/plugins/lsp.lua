return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 把 nvim-cmp 的补全能力合并进 LSP 客户端
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 全局 LSP 默认配置（Neovim 0.11+）
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- LSP 附着时绑定快捷键
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
          map("n", "<leader>D", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })

      -- diagnostic 显示样式
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      require("mason-lspconfig").setup({
        -- 自动安装这些 server，也可以改成空表手动用 :Mason 装
        ensure_installed = { "lua_ls", "rust_analyzer" },
        -- 自动启用已安装的 server，但排除 copilot（不想用 AI 补全）
        automatic_enable = {
          exclude = { "copilot" },
        },
      })
    end,
  },
}
