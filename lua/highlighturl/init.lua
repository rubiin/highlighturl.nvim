-- lua/url_highlight.lua

local M = {}

-- Default options
M.opts = {
  ignore_filetypes = { "qf", "help", "NvimTree", "gitcommit" },
  highlight_color = "#5fd7ff",
}

-- Define custom highlight style
vim.api.nvim_set_hl(0, "URLHighlight", { fg = M.opts.highlight_color, underline = true })

-- Advanced URL regex
local url_matcher = "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)"
    .. "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)"
    .. "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|"
    .. "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)"
    .. "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*"
    .. "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

-- Function to highlight URLs dynamically
function M.highlight_urls()
  local ft = vim.bo.filetype
  for _, ignored in ipairs(M.opts.ignore_filetypes) do
    if ft == ignored then
      return       -- skip highlighting
    end
  end
  vim.fn.clearmatches()   -- clear previous highlights
  vim.fn.matchadd("URLHighlight", url_matcher)
end

-- Setup function with optional configuration
function M.setup(opts)
  -- Merge user options
  if opts then
    if opts.ignore_filetypes then
      M.opts.ignore_filetypes = opts.ignore_filetypes
    end
    if opts.highlight_color then
      M.opts.highlight_color = opts.highlight_color
      vim.api.nvim_set_hl(0, "URLHighlight", { fg = M.opts.highlight_color, underline = true })
    end
  end

  -- Create autocmd group
  local group = vim.api.nvim_create_augroup("HighlightURLs", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*",     -- keep *, but we skip unwanted filetypes inside the callback
    callback = M.highlight_urls,
  })
end

return M
