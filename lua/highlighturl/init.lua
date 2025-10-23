-- lua/url_highlight.lua

local M = {}

---@class HighlightURLs.config
local defaultConfig = {
  ignore_filetypes = { "qf", "help", "NvimTree", "gitcommit" },
  highlight_color = "#5fd7ff",
}

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
      return -- skip highlighting
    end
  end
  vim.fn.clearmatches() -- clear previous highlights
  vim.fn.matchadd("URLHighlight", url_matcher)
end

-- Setup function with optional configuration
--- @param opts? HighlightURLs.config
function M.setup(opts)
  -- Merge user options

  M.opts = vim.tbl_deep_extend("force", defaultConfig, opts or {})

  vim.api.nvim_set_hl(0, "URLHighlight", { fg = M.opts.highlight_color, underline = true })

  -- Create autocmd group
  local group = vim.api.nvim_create_augroup("HighlightURLs", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*", -- keep *, but we skip unwanted filetypes inside the callback
    callback = M.highlight_urls,
  })
end

return M
