return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- 读取当前 nvim 进程及其子进程的内存明细（Name + VmRSS），按占用排序
    local function get_mem_detail()
      local function proc_info(pid)
        local f = io.open("/proc/" .. pid .. "/status", "r")
        if not f then
          return nil
        end
        local name, rss
        for line in f:lines() do
          if not name then
            name = line:match("^Name:%s*(.+)$")
          end
          if not rss then
            rss = line:match("^VmRSS:%s+(%d+)%s+kB")
          end
          if name and rss then
            break
          end
        end
        f:close()
        if not name or not rss then
          return nil
        end
        return { name = name, rss = tonumber(rss) }
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

      local procs = {}
      local visited = {}
      local function accumulate(pid)
        if visited[pid] then
          return
        end
        visited[pid] = true
        local info = proc_info(pid)
        if info then
          table.insert(procs, info)
        end
        for _, child in ipairs(children(pid)) do
          accumulate(child)
        end
      end

      accumulate(vim.fn.getpid())

      if #procs == 0 then
        -- 如果读不了 /proc（比如 macOS），退回到 Lua 内存
        return string.format("lua %.1f MB", collectgarbage("count") / 1024)
      end

      table.sort(procs, function(a, b)
        return a.rss > b.rss
      end)

      local parts = {}
      local limit = 4
      for i, p in ipairs(procs) do
        if i > limit then
          table.insert(parts, "...")
          break
        end
        table.insert(parts, string.format("%s %.1f", p.name, p.rss / 1024))
      end

      return "󰍛 " .. table.concat(parts, " │ ") .. " MB"
    end

    _G.lualine_mem_detail = get_mem_detail()

    -- 每 5 秒更新一次内存显示
    vim.fn.timer_start(5000, function()
      _G.lualine_mem_detail = get_mem_detail()
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
        lualine_y = { "progress", { function() return _G.lualine_mem_detail end } },
        lualine_z = { "location" },
      },
    })
  end,
}
