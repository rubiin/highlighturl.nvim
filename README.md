# HighlightURL

A lightweight Neovim plugin that automatically highlights URLs in your buffers. Minimal Lua port of [vim-highlighturl](https://github.com/itchyny/vim-highlighturl).

## ✨ Features

- 🔗 Automatic URL detection and highlighting (http, https, ftp, file, ssh, git, and more)
- ⚡ Performance optimized with debounced updates and cached lookups
- 🎨 Customizable highlight color
- 📁 Filetype ignore list to skip specific buffer types
- 🔒 Buffer-local disable/enable control
- 🌐 Global toggle to quickly turn highlighting on/off

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "rubiin/highlighturl.nvim",
  event = "VeryLazy",
  config = true,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "rubiin/highlighturl.nvim",
  config = function()
    require("highlighturl").setup()
  end
}
```

## ⚙️ Configuration

The plugin works out of the box with sensible defaults. Call `setup()` only if you want to customize:

```lua
require("highlighturl").setup({
  -- Filetypes to skip highlighting
  ignore_filetypes = { "qf", "help", "NvimTree", "gitcommit" },

  -- URL highlight color (supports hex colors)
  highlight_color = "#5fd7ff",

  -- Debounce delay (ms) for TextChanged events (improves performance)
  debounce_ms = 100,
})
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `ignore_filetypes` | `table` | `{ "qf", "help", "NvimTree", "gitcommit" }` | List of filetypes where URL highlighting is disabled |
| `highlight_color` | `string` | `"#5fd7ff"` | Hex color for highlighted URLs |
| `debounce_ms` | `number` | `100` | Milliseconds to wait before updating highlights after text changes |

## 🎮 Commands

| Command | Scope | Description |
|---------|-------|-------------|
| `:URLHighlightToggle` | Global | Toggle URL highlighting on/off for all buffers |
| `:URLHighlightDisable` | Buffer | Disable URL highlighting for the current buffer only |
| `:URLHighlightEnable` | Buffer | Re-enable URL highlighting for the current buffer |

## 💻 Lua API

You can also control highlighting programmatically:

```lua
local highlighturl = require("highlighturl")

-- Global toggle
highlighturl.toggle()

-- Buffer-local control
highlighturl.disable_for_buffer()      -- disable for current buffer
highlighturl.disable_for_buffer(bufnr) -- disable for specific buffer
highlighturl.enable_for_buffer()       -- re-enable for current buffer
highlighturl.enable_for_buffer(bufnr)  -- re-enable for specific buffer

-- Manual highlight refresh
highlighturl.highlight_urls()
```

You can also set the buffer variable directly:

```lua
vim.b.highlighturl_disabled = true  -- disable for current buffer
vim.b.highlighturl_disabled = false -- re-enable
```

## 🔗 Supported URL Schemes

- `http://`, `https://`
- `ftp://`
- `file://`
- `ssh://`
- `git://`
- `user@host.domain:` (SCP-style)

## 📸 Screenshots

### Before

![before](./images/before.png)

### After

![after](./images/after.png)

## 📄 License

MIT
