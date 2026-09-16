-- 在 oil 里按 <CR> 打开文件时，新窗口开在 oil 的哪一侧
-- "left" = 新窗口在 oil 左边；"right" = 在右边
local open_side = "left"

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
    -- 目录里新增/删除文件时自动刷新（默认关，所以 AI 建的文件看不到，要按 <C-l>）
    watch_for_changes = true,
    view_options = { show_hidden = true },
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      -- 文件：在 oil 旁边新开窗口（方向看 open_side）；目录：仍旧就地进入
      ["<CR>"] = {
        desc = "Open in a new window beside oil",
        callback = function()
          local entry = require("oil").get_cursor_entry()
          local actions = require("oil.actions")
          if entry and entry.type == "directory" then
            actions.select.callback()
          else
            actions.select.callback({
              vertical = true,
              split = open_side == "left" and "aboveleft" or "belowright",
            })
          end
        end,
      },
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
    local gitignored_cache = {}

    local function get_gitignored(dir)
      if gitignored_cache[dir] then
        return gitignored_cache[dir]
      end

      local ignored = {}
      local result = vim.system({
        "git",
        "ls-files",
        "--ignored",
        "--exclude-standard",
        "--others",
        "--directory",
      }, { cwd = dir, text = true }):wait()

      if result.code == 0 then
        for path in (result.stdout or ""):gmatch("[^\n]+") do
          ignored[path:gsub("/$", "")] = true
        end
      end

      gitignored_cache[dir] = ignored
      return ignored
    end

    -- Git ignored 文件使用单独的暗色；未被忽略的 dotfiles 使用正常文件颜色
    vim.api.nvim_set_hl(0, "OilGitIgnored", {
      fg = "#5c6370",
      italic = true,
    })
    local group = vim.api.nvim_create_augroup("oil_gitignored_highlight", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
        vim.api.nvim_set_hl(0, "OilGitIgnored", {
          fg = "#5c6370",
          italic = true,
        })
      end,
    })

    opts.view_options.highlight_filename = function(entry, is_hidden)
      local dir = require("oil").get_current_dir()
      if dir and get_gitignored(dir)[entry.name] then
        return "OilGitIgnored"
      end

      if is_hidden then
        local normal_groups = {
          directory = "OilDir",
          link = "OilLink",
          socket = "OilSocket",
        }
        return normal_groups[entry.type] or "OilFile"
      end

      return nil
    end

    -- 刷新时清除 Git 状态缓存，及时反映新增/删除的 ignored 文件
    opts.keymaps["<C-l>"] = {
      desc = "Refresh",
      callback = function()
        gitignored_cache = {}
        require("oil.actions").refresh.callback()
      end,
    }

    require("oil").setup(opts)
  end,
}
