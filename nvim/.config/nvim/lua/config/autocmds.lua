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
