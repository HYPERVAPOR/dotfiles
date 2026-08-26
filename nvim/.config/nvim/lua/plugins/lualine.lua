return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- 读取当前 nvim 进程占用的物理内存（MB）
    local function get_mem_mb()
      local pid = vim.fn.getpid()
      local f = io.open("/proc/" .. pid .. "/status", "r")
      if f then
        for line in f:lines() do
          local kb = line:match("^VmRSS:%s+(%d+)%s+kB")
          if kb then
            f:close()
            return string.format("%.1f", tonumber(kb) / 1024)
          end
        end
        f:close()
      end
      -- 如果读不了 /proc（比如 macOS），退回到 Lua 内存
      return string.format("%.1f", collectgarbage("count") / 1024)
    end

    _G.lualine_mem_mb = get_mem_mb()

    -- 每 5 秒更新一次内存显示
    vim.fn.timer_start(5000, function()
      _G.lualine_mem_mb = get_mem_mb()
      vim.cmd("redrawstatus")
    end, { ["repeat"] = -1 })

    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress", { function() return "󰍛 " .. _G.lualine_mem_mb .. " MB" end } },
        lualine_z = { "location" },
      },
    })
  end,
}
