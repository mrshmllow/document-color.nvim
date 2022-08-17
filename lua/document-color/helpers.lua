local M = {}

--- Resolve bufnr
function M.get_bufnr(bufnr)
  if bufnr == 0 or bufnr == nil then
    return vim.api.nvim_get_current_buf()
  end

  return bufnr
end

-- Determine whether to use black or white text
-- Ref: https://stackoverflow.com/a/1855903/837964
-- https://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
-- Credit: https://github.com/kabouzeid/dotfiles/blob/main/config/nvim/lua/lsp-documentcolors.lua
function M.color_is_bright(r, g, b)
  -- Counting the perceptive luminance - human eye favors green color
  local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  if luminance > 0.5 then
    return true -- Bright colors, black font
  else
    return false -- Dark colors, white font
  end
end

--- Convert lsp `Color` (https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#color) to a hex code
--- Credit: https://github.com/kabouzeid/dotfiles/blob/main/config/nvim/lua/lsp-documentcolors.lua
function M.lsp_color_to_hex(color)
  -- Lsp returns colour values 0-1
  local function to256(c)
    return math.floor(c * color.alpha * 255)
  end

  return bit.tohex(
    bit.bor(bit.lshift(to256(color.red), 16), bit.lshift(to256(color.green), 8), to256(color.blue)),
    6
  )
end

--- Merge two tables
function M.merge(...)
  local res = {}
  for i = 1, select("#", ...) do
    local o = select(i, ...)
    for k, v in pairs(o) do
      res[k] = v
    end
  end
  return res
end

return M
