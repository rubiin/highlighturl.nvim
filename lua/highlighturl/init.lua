-- lua/url_highlight.lua

local M = {}

-- Define custom highlight style
vim.api.nvim_set_hl(0, "URLHighlight", { fg = "#5fd7ff", underline = true })

-- Advanced URL regex
local url_matcher = "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)"
    .. "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)"
    .. "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|"
    .. "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)"
    .. "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*"
    .. "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

-- Function to highlight URLs dynamically
function M.highlight_urls()
  vim.fn.clearmatches() -- clear previous highlights in buffer
  vim.fn.matchadd("URLHighlight", url_matcher)
end

-- Setup autocmds for dynamic highlighting
function M.setup()
  print("HighlightURL plugin loaded")
  local group = vim.api.nvim_create_augroup("HighlightURLs", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*",
    callback = M.highlight_urls,
  })
end

return M
