# HighlightURL

A simple plugin to highlight URLs in your buffer.
Minimal lua port of vim-highlighturl

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim) in lua

```lua

{
"rubiin/highlighturl.nvim",
init = function()
  vim.g.highlighturl = true
end
}
```

## Screenshots

### Before

![before](./images/before.png)

### After

![after](./images/after.png)

### EXAMPLES

Do not load this plugin. 
```vim.g.highlighturl = true```
