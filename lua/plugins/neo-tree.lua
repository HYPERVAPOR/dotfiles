return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        -- 显示 .gitignore 中的文件（默认是隐藏的）
        hide_gitignored = false,
        -- 显示隐藏文件（以 . 开头的）
        hide_dotfiles = false,
        -- 被过滤的文件以灰色显示，而不是完全消失
        visible = true,
      },
    },
  },
}
