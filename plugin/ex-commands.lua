local highlight = require("highlighturl")

-- Create a user command for toggling
vim.api.nvim_create_user_command("URLHighlightToggle", function()
  highlight.toggle()
end, { desc = "Toggle URL highlighting" })
