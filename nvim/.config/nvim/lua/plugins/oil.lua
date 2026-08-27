return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- 从普通文件 buffer 打开 oil 侧边栏
    -- 注意：在 oil buffer 里按 - 是 oil 自带的“返回上一级”，不要覆盖
    { "<leader>e", "<cmd>vsplit | Oil<cr>", desc = "Open oil sidebar" },
  },
  opts = {
    -- 让 oil 接管目录 buffer（nvim . 会先进 oil）
    default_file_explorer = true,
    view_options = { show_hidden = true },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = false,  -- 禁用 oil 的 preview，让全局 <C-p> 触发 telescope
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
  end,
}
