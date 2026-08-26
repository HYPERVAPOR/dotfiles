return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit commit" },
    { "<leader>gl", "<cmd>Neogit log<cr>", desc = "Neogit log" },
  },
  config = function()
    require("neogit").setup({
      -- 状态面板“Recent commits”默认只显示 10 条，这里改多一点
      status = {
        recent_commit_count = 25,
      },
      integrations = {
        diffview = true,
        telescope = true,
      },
    })
  end,
}
