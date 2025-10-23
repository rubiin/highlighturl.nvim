local M = {}
--------------------------------------------------------------------------------

---@param userConfig? HighLightURL.config
M.setup = function(userConfig) require("highlighturl.config").setup(userConfig) end

local utils = require("highlighturl.utils")

M.highlight_url = utils.highlight_url
M.unhighlight_url = utils.unhighlight_url

--------------------------------------------------------------------------------
return M
