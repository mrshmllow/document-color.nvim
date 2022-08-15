# document-color.nvim
A plugin for lsp clients that support [`textDocument/documentColor`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentColor)

## Installation & Usage
```lua
use { 'mrshmllow/document-color.nvim', config = function()
  require("document-color").setup {
    -- Default options
    mode = "background", -- "background" | "foreground"
  }
}
```

For a typical [lspconfig](https://github.com/neovim/nvim-lspconfig) setup...
```lua
local on_attach = function(client)
  ...
  if client.server_capabilities.colorProvider then
    -- Attach document colour support
    require("document-color").buf_attach(bufnr, { mode = "background" })
  end
  ...
end

-- Any lsp server that supports documentColor...
require("lspconfig").tailwindcss.setup{
  on_attach = on_attach
}
```

### Methods

```lua
-- Attach to the current buffer (Turn on)
require("document-color").buf_attach()

-- Detach from current buffer (Turn off)
require("document-color").buf_detach()
```

## 🔮
When (or if) [anti-conceal](https://github.com/neovim/neovim/pull/9496) ever gets merged, it may be possible to have something like this!

![image](https://user-images.githubusercontent.com/40532058/184592957-99705666-c26f-4ee9-b804-42201db7dd9a.png)

## Credits
- [kabouzeid](https://github.com/kabouzeid) and his great dotfiles. Inspired by this reddit post, chunks of this plugin are from him. ❤️
- https://github.com/norcalli/nvim-colorizer.lua
