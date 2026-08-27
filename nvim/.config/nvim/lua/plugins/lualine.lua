return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- 读取当前 nvim 进程及其所有子进程占用的物理内存（MB）
    local function get_mem_mb()
      local function pid_rss(pid)
        local f = io.open("/proc/" .. pid .. "/status", "r")
        if not f then
          return 0
        end
        local rss = 0
        for line in f:lines() do
          local kb = line:match("^VmRSS:%s+(%d+)%s+kB")
          if kb then
            rss = tonumber(kb)
            break
          end
        end
        f:close()
        return rss
      end

      local function children(pid)
        local path = string.format("/proc/%d/task/%d/children", pid, pid)
        local f = io.open(path, "r")
        if not f then
          return {}
        end
        local out = f:read("*a") or ""
        f:close()
        local pids = {}
        for p in out:gmatch("%d+") do
          table.insert(pids, tonumber(p))
        end
        return pids
      end

      local total_kb = 0
      local visited = {}
      local function accumulate(pid)
        if visited[pid] then
          return
        end
        visited[pid] = true
        total_kb = total_kb + pid_rss(pid)
        for _, child in ipairs(children(pid)) do
          accumulate(child)
        end
      end

      accumulate(vim.fn.getpid())

      -- 如果读不了 /proc（比如 macOS），退回到 Lua 内存
      if total_kb == 0 then
        return string.format("%.1f", collectgarbage("count") / 1024)
      end

      return string.format("%.1f", total_kb / 1024)
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
