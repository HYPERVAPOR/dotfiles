return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- 新版 nvim-treesitter 只负责安装 parser 和 queries
    -- 高亮由 Neovim 内置的 treesitter 提供
    require("nvim-treesitter").setup()

    -- 只安装还没装的 parser，避免每次启动都重装
    local parsers = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
    local install_dir = require("nvim-treesitter.config").get_install_dir("parser")
    local to_install = vim.tbl_filter(function(lang)
      return vim.fn.filereadable(install_dir .. "/" .. lang .. ".so") ~= 1
    end, parsers)

    if #to_install > 0 then
      -- 用 force=true 跳过 nvim-treesitter 自带的“已安装”检测
      -- （旧 queries 存在但 parser .so 缺失时会被误判为已安装）
      require("nvim-treesitter").install(to_install, { force = true }):wait(300000)
    end
  end,
}
