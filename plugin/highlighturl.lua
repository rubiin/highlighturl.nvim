

vim.api.nvim_set_hl(0, 'HighlightURL', { underline = true })

vim.api.nvim_create_autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  desc = "URL Highlighting",
  callback = function() require("highlighturl").highlight_url() end,
})
