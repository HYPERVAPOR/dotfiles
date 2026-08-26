-- 基础选项
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.undofile = true

-- 把缓冲区末尾的波浪线 (~) 替换为空格，即隐藏它们
vim.opt.fillchars = { eob = " " }

-- 禁用默认的 netrw，让 oil.nvim 接管目录浏览
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 系统剪贴板同步
vim.opt.clipboard = "unnamedplus"

-- WSL 剪贴板修复（如果你不是 WSL，这段可以删掉）
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = { "win32yank.exe", "-i", "--crlf" },
      ["*"] = { "win32yank.exe", "-i", "--crlf" },
    },
    paste = {
      ["+"] = { "win32yank.exe", "-o", "--lf" },
      ["*"] = { "win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 0,
  }
end
