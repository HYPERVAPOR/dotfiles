-- ==========================================
-- 文件路径: ~/.config/nvim/lua/config/options.lua
-- ==========================================

-- 启用系统剪贴板同步
vim.opt.clipboard = "unnamedplus"

-- WSL2 环境下挂载 Windows 剪贴板工具，修复中文乱码问题
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      -- 写入 Windows 剪贴板，自动处理换行符
      ['+'] = { 'win32yank.exe', '-i', '--crlf' },
      ['*'] = { 'win32yank.exe', '-i', '--crlf' },
    },
    paste = {
      -- 从 Windows 剪贴板读取，自动把 CRLF 转成 LF（去掉 ^M）
      ['+'] = { 'win32yank.exe', '-o', '--lf' },
      ['*'] = { 'win32yank.exe', '-o', '--lf' },
    },
    cache_enabled = 0,
  }
end
