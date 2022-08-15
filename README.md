# document-color.nvim 🌈
A colorizer plugin for [tailwindcss](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss) and any lsp servers that support [`textDocument/documentColor`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentColor)!

![document-color.nvim demo](https://user-images.githubusercontent.com/40532058/184640748-8e71ad1e-c300-4040-b4f2-8a5bba3e9588.gif)

## Installation & Usage
```lua
use { 'mrshmllow/document-color.nvim', config = function()
  require("document-color").setup {
    -- Default options
    mode = "background", -- "background" | "foreground"
  }
}
```

<details>
<summary>What does foreground mode look like?</summary>
<br>

![image](https://user-images.githubusercontent.com/40532058/184633209-32427b6b-0f08-468b-ae6f-977950b96000.png)

</details>

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
-- Toggle in current buffer
require("document-color").buf_toggle()

-- Attach to the current buffer (Turn on)
require("document-color").buf_attach()

-- Detach from current buffer (Turn off)
require("document-color").buf_detach()
```

## Notes
- You should probably keep your existing colorizer plugin, this plugin does not replace it
- I am only using "color" and not "colour" because thats what the lsp specs say, not because i believe in such heresy to the queen

## 🔮 A future...
When (or if) [anti-conceal](https://github.com/neovim/neovim/pull/9496) ever gets merged, it may be possible to have something like the tailwindcss vscode extension has

![image](https://user-images.githubusercontent.com/40532058/184592957-99705666-c26f-4ee9-b804-42201db7dd9a.png)

## Credits
- [kabouzeid](https://github.com/kabouzeid) and his great dotfiles. Inspired by his reddit post, chunks of this plugin are from his dotfiles. ❤️
- https://github.com/norcalli/nvim-colorizer.lua
