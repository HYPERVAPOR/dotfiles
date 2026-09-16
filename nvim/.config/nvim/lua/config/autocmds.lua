-- 复制后高亮一下选中的文本
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- 没有参数启动时直接打开 oil
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("startup_oil", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.o.diff then
      vim.cmd("Oil")
    end
  end,
})

-- 外部进程（AI、别的编辑器）改了磁盘上的文件后自动重载
-- nvim 只在这几种时机比对时间戳：FocusGained、执行 shell 命令、:checktime
-- 焦点事件没送到（AI 跑在 nvim 自己的 terminal buffer 里）就会一直显示旧内容
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload", { clear = true }),
  callback = function()
    if vim.fn.mode():find("^[crt!i]") then return end -- 官方配方：这些模式下不刷新
    if vim.bo.buftype ~= "" or vim.bo.modified then return end -- oil 等 buffer 跳过；自己有改动时不覆盖
    vim.cmd("checktime")
  end,
})

-- 折叠兜底：既没有 treesitter parser、也没有支持 foldingRange 的 LSP 时，按缩进折叠
-- （vim.treesitter.foldexpr() 在无 parser 时返回 '0'，一个折都不会有）
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_fold_fallback", { clear = true }),
  callback = function()
    if pcall(vim.treesitter.get_parser, 0) then return end
    if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/foldingRange" }) > 0 then return end
    vim.opt_local.foldmethod = "indent"
  end,
})
