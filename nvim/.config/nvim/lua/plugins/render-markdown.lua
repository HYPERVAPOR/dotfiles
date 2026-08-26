return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      -- 默认启用渲染
      enabled = true,
      -- 最大文件行数，超过则禁用（防止大文件卡）
      max_file_size = 5.0,
      -- 标题样式
      heading = {
        enabled = true,
        sign = true,
        style = "full",
        position = "inline",
      },
      -- 代码块样式
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
      },
      -- 列表符号美化
      bullet = {
        enabled = true,
      },
      -- 表格渲染
      pipe_table = {
        enabled = true,
      },
    })
  end,
}
