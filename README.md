# HighlightURL

A simple plugin to highlight URLs in your buffer.
Minimal lua port of vim-highlighturl


## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim) in lua

```lua

{"rubiin/highlighturl.nvim"}

```

## Setup
Set `vim.g.highlighturl = true` somewhere in your config(example, init.lua) to enable highlighting.


## Screenshots

### Before

![](./images/before.png)

### After

![]("./images/after.png")



## Extras
Highlighting is controlled through the global `vim.g.highlighturl` variable.
You can add a manipulate the boolean variable to turn off highlighting with some
custom logic.
