vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.md", "*.mdx", "*.txt" },
	callback = function()
		vim.opt.wrap = true
		vim.opt.spell = true
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.go",
	callback = function()
		vim.opt.expandtab = false
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.tsx", "*.jsx", "*.css", "*.scss", "*.sass", "*.html", "*.lua" },
	callback = function()
		vim.opt.tabstop = 2
	end,
})
