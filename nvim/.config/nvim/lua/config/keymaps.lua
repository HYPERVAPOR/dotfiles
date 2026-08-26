-- 让单独按空格变成“什么都不做”（防止光标乱跑）
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

-- 清除搜索高亮
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- visual 模式下粘贴时，先把选中内容删到黑洞寄存器，避免覆盖剪贴板
vim.keymap.set("x", "p", '"_dP', { noremap = true, silent = true })
vim.keymap.set("x", "P", '"_dP', { noremap = true, silent = true })

-- 只有 y 能修改系统剪贴板；d/x/c 默认删到黑洞寄存器
-- 需要真正剪切时，显式用 "+d / "+x / "+c
local black_hole_ops = { "d", "D", "x", "X", "c", "C", "s", "S" }
for _, key in ipairs(black_hole_ops) do
  vim.keymap.set({ "n", "x" }, key, '"_' .. key, { noremap = true, silent = true })
end
