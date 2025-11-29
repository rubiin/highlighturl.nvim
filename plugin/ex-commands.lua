local highlight = require("highlighturl")

-- Create a user command for toggling
vim.api.nvim_create_user_command("URLHighlightToggle", function()
  highlight.toggle()
end, { desc = "Toggle URL highlighting globally" })

vim.api.nvim_create_user_command("URLHighlightDisable", function()
  highlight.disable_for_buffer()
end, { desc = "Disable URL highlighting for current buffer" })

vim.api.nvim_create_user_command("URLHighlightEnable", function()
  highlight.enable_for_buffer()
end, { desc = "Enable URL highlighting for current buffer" })
