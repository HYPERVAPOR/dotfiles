return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        telescope = true,
        treesitter = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")

    -- 窗口分隔线用 catppuccin 的 surface1，低调不刺眼
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#45475a", bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#45475a", bg = "NONE" })
  end,
}
