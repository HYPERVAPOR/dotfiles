-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 覆盖 LazyVim 默认的 <leader>gs（Telescope git_status），改为打开 Neogit
vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<cr>", { desc = "Open Neogit" })

-- 恢复 Ctrl+/ 为注释（LazyVim v8 默认把它改成了打开终端）
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Comment line" })
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Comment selection" })

-- （可选）把终端功能挪到 Ctrl+\，这样两个功能都能保留
vim.keymap.set({"n", "t"}, "<C-\\>", function() Snacks.terminal.focus(nil, { cwd = LazyVim.root() }) end, { desc = "Terminal (Root Dir)" })
