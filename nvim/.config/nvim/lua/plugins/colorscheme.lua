return {
  "clearaspect/onehalf",
  lazy = false,
  priority = 1000,
  config = function()
    require("onehalf").setup({
      integrations = {
        telescope = true,
        treesitter = true,
        gitsigns = true,
        cmp = true,
      },
    })

    vim.cmd.colorscheme("onehalfdark")

    -- 窗口分隔线用低调的灰色，不刺眼
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3e4451", bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4451", bg = "NONE" })

    -- inline blame 使用灰蓝色，与 OneHalf Dark 背景保持区分但不抢焦点
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
      fg = "#7f8795",
      italic = true,
    })
  end,
}
