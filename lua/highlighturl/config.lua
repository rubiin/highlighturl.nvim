local M = {}
--------------------------------------------------------------------------------

---@class HighLightURL.config
local defaultConfig = {
}

M.config = defaultConfig

--------------------------------------------------------------------------------

---@param userConfig? HighLightURL.config
M.setup = function(userConfig)
  M.config = vim.tbl_deep_extend("force", defaultConfig, userConfig or {})
end

--------------------------------------------------------------------------------
return M
