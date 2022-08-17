# document-color.nvim 🌈
A colorizer plugin for [tailwindcss](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss) and any lsp servers that support [`textDocument/documentColor`](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentColor)!

For example [tailwindcss](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss), [cssls](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls), and [dart](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dartls) support documentColor!

![document-color.nvim demo](https://user-images.githubusercontent.com/40532058/184640748-8e71ad1e-c300-4040-b4f2-8a5bba3e9588.gif)

## Installation & Usage
```lua
use { 'mrshmllow/document-color.nvim', config = function()
  require("document-color").setup {
    -- Default options
    mode = "background", -- "background" | "foreground" | "single"
  }
  end
}
```

<details>
<summary>What is "single" mode?</summary>
<br>

For people who don't like large bright chunks of their buffer un-colorschemed, `single` column mode is a compromise until anti-conceal.

!["single" mode](https://user-images.githubusercontent.com/40532058/184829642-e6f83acc-dece-4ee0-b17f-86e119a4f966.png)
---

</details>

<details>
<summary>What does foreground mode look like?</summary>
<br>

![image](https://user-images.githubusercontent.com/40532058/184633209-32427b6b-0f08-468b-ae6f-977950b96000.png)
---

</details>

For a typical [lspconfig](https://github.com/neovim/nvim-lspconfig) setup...
```lua
local on_attach = function(client)
  ...
  if client.server_capabilities.colorProvider then
    -- Attach document colour support
    require("document-color").buf_attach(bufnr)
  end
  ...
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- You are now capable!
capabilities.textDocument.colorProvider = true

-- Lsp servers that support documentColor
require("lspconfig").tailwindcss.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
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

## Tips & Tricks

- Disable [nvim-colorizer.nvim](https://github.com/norcalli/nvim-colorizer.lua) in places its now redundent
```lua
-- Colorize
use { 'norcalli/nvim-colorizer.lua', config = function ()
  require('colorizer').setup({
    '*';
    -- An example
    '!css';
    '!html';
    '!tsx';
    '!dart';
  })
end }
```

## Notes
- You should probably keep your existing colorizer plugin, this plugin does not replace it in many cases
- I am only using "color" and not "colour" because thats what the lsp specs say, not because i believe in such heresy to the queen

## 🔮 A future...
When (or if) [anti-conceal](https://github.com/neovim/neovim/pull/9496) ever gets merged, it may be possible to have something like the tailwindcss vscode extension has

![image](https://user-images.githubusercontent.com/40532058/184592957-99705666-c26f-4ee9-b804-42201db7dd9a.png)

for now, we only have `mode = "single"`

## Credits
- [kabouzeid](https://github.com/kabouzeid) and his great dotfiles. Inspired by his reddit post, chunks of this plugin are from his dotfiles. ❤️
- https://github.com/norcalli/nvim-colorizer.lua
