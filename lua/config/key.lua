-- buffers
vim.keymap.set("n", "[b", function()
  vim.cmd([[bprev]])
end, { silent = true })

vim.keymap.set("n", "]b", function()
  vim.cmd([[bnext]])
end, { silent = true })

-- clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
