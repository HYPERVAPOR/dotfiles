return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Neogit",
  config = function()
    require("neogit").setup({
      -- 【核心配置】：调整面板的弹出布局
      kind = "vsplit", -- 可选值: "split" (上下), "vsplit" (左右), "floating" (悬浮), "replace" (全屏默认)

      -- 确保这些设置开启，这样你可以看到更多信息
      status = {
        recent_commit_count = 10, -- 显示最近的 10 次提交历史
      },

      integrations = {
        diffview = true, -- 这是核心：必须开启，否则你看不到代码差异
      },
    })
  end,
  keys = {
    { "<leader>gs", "<cmd>Neogit<cr>", desc = "Open Neogit" },
  },
}
