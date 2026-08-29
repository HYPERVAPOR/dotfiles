return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files (Ctrl+P)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Global search" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          preview_cutoff = 80, -- 终端宽度 >= 80 列就显示预览
          preview_width = 0.5,
        },
        -- live_grep 用 ripgrep，默认遵守 .gitignore
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          -- 加上 --hidden 可以搜隐藏文件（但仍遵守 .gitignore）
          -- "--hidden",
        },
      },
      extensions = {
        fzf = {},
      },
    })

    pcall(require("telescope").load_extension, "fzf")
  end,
}
