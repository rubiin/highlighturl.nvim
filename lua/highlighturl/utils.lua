local M = {}

--- Delete the syntax matching rules for URLs/URIs if set.
function M.unhighlight_url()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighLightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
end

--- Add syntax matching rules for highlighting URLs/URIs.
function M.highlight_url()
  --- regex used for matching a valid URL/URI string
  local url_matcher = "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)"
    .. "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)"
    .. "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|"
    .. "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)"
    .. "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*"
    .. "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

  M.unhighlight_url()
  if vim.g.highlighturl then
    vim.fn.matchadd("HighLightURL", url_matcher, 15)
  end
end

return M
