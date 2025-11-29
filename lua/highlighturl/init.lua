local M = {}

-- Pre-cache vim APIs for faster access
local api = vim.api
local fn = vim.fn
local bo = vim.bo
local uv = vim.uv or vim.loop

---@class HighlightURLs.config
local defaultConfig = {
  ignore_filetypes = { "qf", "help", "NvimTree", "gitcommit" },
  highlight_color = "#5fd7ff",
  debounce_ms = 100, -- debounce time for TextChanged events
}

-- Advanced URL regex (pre-computed, reused)
local url_matcher = "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)"
  .. "%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)"
  .. "[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|"
  .. "[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)"
  .. "|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*"
  .. "|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

-- Internal state
M.enabled = true

-- Cached ignore_filetypes set for O(1) lookup
local ignore_filetypes_set = {}

-- Debounce state
local debounce_timer = nil
local match_id = nil -- track our match id to avoid clearing others

-- Build set from list for O(1) lookup
local function build_ignore_set(list)
  local set = {}
  for _, ft in ipairs(list) do
    set[ft] = true
  end
  return set
end

-- Clear only our URL matches (not all matches)
local function clear_url_matches()
  if match_id then
    pcall(fn.matchdelete, match_id)
    match_id = nil
  end
end

-- Core highlight logic (no debounce)
local function do_highlight()
  if not M.enabled then
    return
  end

  local ft = bo.filetype
  if ignore_filetypes_set[ft] then
    return
  end

  -- Skip empty/unloaded buffers
  local bufnr = api.nvim_get_current_buf()
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end

  -- Clear previous URL match and add new one
  clear_url_matches()
  match_id = fn.matchadd("URLHighlight", url_matcher)
end

-- Debounced highlight for TextChanged events
local function highlight_debounced()
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end
  debounce_timer = uv.new_timer()
  debounce_timer:start(M.opts.debounce_ms, 0, vim.schedule_wrap(function()
    if debounce_timer then
      debounce_timer:stop()
      debounce_timer:close()
      debounce_timer = nil
    end
    do_highlight()
  end))
end

-- Public: highlight URLs (immediate, for BufEnter)
function M.highlight_urls()
  do_highlight()
end

-- Toggle highlight state
function M.toggle()
  M.enabled = not M.enabled

  if M.enabled then
    vim.notify("URL highlighting enabled", vim.log.levels.INFO)
    do_highlight()
  else
    clear_url_matches()
    vim.notify("URL highlighting disabled", vim.log.levels.WARN)
  end
end

-- Setup function with optional configuration
---@param opts? HighlightURLs.config
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", defaultConfig, opts or {})

  -- Build ignore set for O(1) lookup
  ignore_filetypes_set = build_ignore_set(M.opts.ignore_filetypes)

  api.nvim_set_hl(0, "URLHighlight", { fg = M.opts.highlight_color, underline = true })

  local group = api.nvim_create_augroup("HighlightURLs", { clear = true })

  -- Immediate highlight on BufEnter
  api.nvim_create_autocmd("BufEnter", {
    group = group,
    pattern = "*",
    callback = do_highlight,
  })

  -- Debounced highlight on text changes
  api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*",
    callback = highlight_debounced,
  })
end

return M
