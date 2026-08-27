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
