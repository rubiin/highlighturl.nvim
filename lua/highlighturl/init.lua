local M = {}

-- Pre-cache vim APIs for faster access
local api = vim.api
local fn = vim.fn
local bo = vim.bo
local uv = vim.uv or vim.loop

local namespace = "HighlightURLs"

---@class HighlightURLs.config
local defaultConfig = {
  ignore_filetypes = { "qf", "help", "NvimTree", "gitcommit" },
  highlight_color = "#5fd7ff",
  debounce_ms = 100, -- debounce time for TextChanged events
  underline = true,
  silent = false,
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

-- Track match IDs per window (matches are window-local in Vim)
local win_match_ids = {}

-- Track last buffer changedtick per window to skip redundant updates
local win_last_tick = {}

-- Build set from list for O(1) lookup
local function build_ignore_set(list)
  local set = {}
  for _, ft in ipairs(list) do
    set[ft] = true
  end
  return set
end

-- Get current window's match id
local function get_win_match_id()
  local win = api.nvim_get_current_win()
  return win_match_ids[win]
end

-- Set current window's match id
local function set_win_match_id(id)
  local win = api.nvim_get_current_win()
  win_match_ids[win] = id
end

-- Clear only our URL matches for current window
local function clear_url_matches()
  local match_id = get_win_match_id()
  if match_id then
    pcall(fn.matchdelete, match_id)
    set_win_match_id(nil)
  end
end

-- Core highlight logic (no debounce)
local function do_highlight()
  if not M.enabled then
    return
  end

  local bufnr = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()

  -- Check buffer-local disable flag
  if vim.b[bufnr].highlighturl_disabled then
    clear_url_matches()
    return
  end

  local ft = bo[bufnr].filetype
  if ignore_filetypes_set[ft] then
    return
  end

  -- Skip special buffer types (terminal, nofile, prompt, etc.)
  local buftype = bo[bufnr].buftype
  if buftype ~= "" then
    return
  end

  -- Skip unloaded buffers
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end

  -- Skip hidden/background buffers (not displayed in any window)
  if fn.bufwinid(bufnr) == -1 then
    return
  end

  -- Skip if buffer hasn't changed and we already have a match
  local tick = api.nvim_buf_get_changedtick(bufnr)
  local key = bufnr .. ":" .. win
  if win_match_ids[win] and win_last_tick[key] == tick then
    return
  end
  win_last_tick[key] = tick

  -- Clear previous URL match and add new one
  clear_url_matches()
  local new_match_id = fn.matchadd(namespace, url_matcher)
  set_win_match_id(new_match_id)
end

-- Debounced highlight for TextChanged events
local function highlight_debounced()
  -- Early return before using timer
  if not M.enabled then
    return
  end

  -- Create timer once, reuse it
  if not debounce_timer then
    debounce_timer = uv.new_timer()
  end

  -- Stop any pending callback and restart
  debounce_timer:stop()
  debounce_timer:start(
    M.opts.debounce_ms,
    0,
    vim.schedule_wrap(do_highlight)
  )
end

-- Public: highlight URLs (immediate, for BufEnter)
function M.highlight_urls()
  do_highlight()
end

function M.notify(text)
  if not M.opts.silent then
    vim.notify(text, vim.log.levels.INFO)
  end
end
-- Toggle highlight state
function M.toggle()
  M.enabled = not M.enabled

  if M.enabled then
    do_highlight()
    M.notify("URL highlighting enabled")
  else
    clear_url_matches()
    M.notify("URL highlighting disabled")
  end
end

--- Disable URL highlighting for a specific buffer
---@param bufnr? number Buffer number (defaults to current buffer)
function M.disable_for_buffer(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  vim.b[bufnr].highlighturl_disabled = true
  if bufnr == api.nvim_get_current_buf() then
    clear_url_matches()
  end
end

--- Enable URL highlighting for a specific buffer
---@param bufnr? number Buffer number (defaults to current buffer)
function M.enable_for_buffer(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  vim.b[bufnr].highlighturl_disabled = false
  if bufnr == api.nvim_get_current_buf() then
    do_highlight()
  end
end

-- Setup function with optional configuration
---@param opts? HighlightURLs.config
function M.setup(opts)
  -- Cancel existing timer on reload to prevent leaks
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end

  M.opts = vim.tbl_deep_extend("force", defaultConfig, opts or {})

  -- Build ignore set for O(1) lookup
  ignore_filetypes_set = build_ignore_set(M.opts.ignore_filetypes)

  api.nvim_set_hl(0, namespace, { fg = M.opts.highlight_color, underline = M.opts.underline })

  local group = api.nvim_create_augroup(namespace, { clear = true })

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

  -- Cleanup match IDs when window closes to prevent memory leak
  api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = "*",
    callback = function(ev)
      local win = tonumber(ev.match)
      if win then
        win_match_ids[win] = nil
        -- Cleanup tick cache for this window
        for key in pairs(win_last_tick) do
          if key:match(":" .. win .. "$") then
            win_last_tick[key] = nil
          end
        end
      end
    end,
  })
end

return M
