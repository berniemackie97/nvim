-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local lint = require("config.lint")

vim.keymap.set("n", "<leader>uM", function()
  local enabled = lint.toggle()
  vim.notify("Lint " .. (enabled and "enabled" or "disabled"))
end, { desc = "Lint (Toggle Global)" })

vim.keymap.set("n", "<leader>uB", function()
  local enabled = lint.toggle(true)
  vim.notify("Lint " .. (enabled and "enabled" or "disabled") .. " (buffer)")
end, { desc = "Lint (Toggle Buffer)" })

vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set(
  "n",
  "<leader>xD",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Buffer Diagnostics (Trouble)" }
)
