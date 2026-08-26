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
    -- 自定义 <CR>：文件用新分屏打开，目录正常进入
    opts.keymaps["<CR>"] = {
      callback = function()
        local oil = require("oil")
        oil.select({
          handle_buffer_callback = function(filebufnr)
            local bufname = vim.api.nvim_buf_get_name(filebufnr)

            -- 目录：在 oil 当前窗口打开（保持 sidebar 行为）
            if vim.endswith(bufname, "/") then
              vim.api.nvim_set_current_buf(filebufnr)
              return
            end

            -- 文件：在主编辑区新建一个竖直分屏打开
            local oil_win = vim.api.nvim_get_current_win()
            local main_win = nil
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if win ~= oil_win then
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype ~= "oil" then
                  main_win = win
                  break
                end
              end
            end

            if main_win then
              vim.api.nvim_set_current_win(main_win)
            end

            vim.cmd("vsplit")
            vim.api.nvim_set_current_buf(filebufnr)
          end,
        })
      end,
      mode = "n",
      desc = "Open file in new split",
    }

    require("oil").setup(opts)

    -- 当 oil 是唯一窗口时，自动切成左侧主编辑区 + 右侧 oil 侧边栏
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("oil_sidebar", { clear = true }),
      pattern = "oil",
      callback = function(args)
        -- 如果已经有多个窗口，说明用户自己 split 了，不干涉
        if vim.fn.winnr("$") ~= 1 then
          return
        end

        -- 记住当前 oil 窗口的宽度偏好
        local oil_win = vim.api.nvim_get_current_win()

        -- 在左侧显示一个空 buffer 作为主编辑区
        vim.cmd("vsplit")
        vim.cmd("wincmd h")
        vim.cmd("enew")

        -- 调整右侧 oil 窗口宽度（更窄一点）
        vim.cmd("wincmd l")
        vim.cmd("vertical resize 25")

        -- 焦点回到左侧空 buffer
        vim.cmd("wincmd h")
      end,
    })
  end,
}
