local helpers = require('document-color.helpers')

local M = {}
local NAMESPACE = vim.api.nvim_create_namespace("lsp_documentColor")
local MODE_NAMES = { background = "mb", foreground = "mf" }

local STATE = {
  ATTACHED_BUFFERS = {},
  HIGHLIGHTS = {}
}

local function create_highlight(color, options)
  local mode = options.mode or "background"

  -- This will create something like "mb_d023d9"
  local cache_key = table.concat({ MODE_NAMES[mode], color }, "_")

  if STATE.HIGHLIGHTS[cache_key] then return STATE.HIGHLIGHTS[cache_key] end

  -- This will create something like "lsp_documentColor_mb_d023d9", safe to start adding to neovim
  local highlight_name = table.concat({ "lsp_documentColor", MODE_NAMES[mode], color }, "_")

  if mode == "foreground" then
    vim.cmd(string.format("highlight %s guifg=#%s", highlight_name, color))
  else
    -- TODO: Make this bit less dumb, especially since helpers.lsp_color_to_hex exists
    local r, g, b = color:sub(1, 2), color:sub(3, 4), color:sub(5, 6) -- consider "3b82f6". `r` = "3b"
    r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) -- eg. Change "3b" -> "59"

    vim.cmd(
      string.format(
        "highlight %s guifg=%s guibg=#%s",
        highlight_name,
        -- Choose the right foreground
        helpers.color_is_bright(r, g, b) and "Black" or "White",
        color
      )
    )
  end

  STATE.HIGHLIGHTS[cache_key] = highlight_name

  return highlight_name
end

--- Fetch and update highlights in the buffer
function M.update_highlights(bufnr, options)
  local params = { textDocument = vim.lsp.util.make_text_document_params() }

  vim.lsp.buf_request(bufnr, "textDocument/documentColor", params, function(err, colors, _, _)
    if err == nil and colors ~= nil then -- There is no error and we actually got something back
      -- Clear all our in the buffer highlights
      vim.api.nvim_buf_clear_namespace(bufnr, NAMESPACE, 0, -1)

      -- `_` is a TextDocumentIdentifier, not important
      for _, color_info in pairs(colors) do
        color_info.color = helpers.lsp_color_to_hex(color_info.color)

        local range = color_info.range
        -- Start highlighting range with color inside `bufnr`
        vim.api.nvim_buf_add_highlight(bufnr, NAMESPACE, create_highlight(color_info.color, options), range.start.line, range.start.character, range["end"].character)
      end
    end
  end)
end

function M.buf_attach(bufnr, options)
  bufnr = helpers.get_bufnr(bufnr)

  if STATE.ATTACHED_BUFFERS[bufnr] then return end -- We are already attached to this buffer, ignore
  STATE.ATTACHED_BUFFERS[bufnr] = true -- Attach to this buffer

  -- VSCode extension also does 200ms debouncing
  local trigger_update_highlight, timer = require("defer").debounce_trailing(
    M.update_highlights,
    options.debounce or 200,
    false
  )

  -- for the first request, the server needs some time before it's ready
  -- sometimes 200ms is not enough for this
  -- TODO: figure out when the first request can be send
  trigger_update_highlight(bufnr, options)

  vim.api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      if not STATE.ATTACHED_BUFFERS[bufnr] then
        return true
      end
      trigger_update_highlight(bufnr, options)
    end,
    on_detach = function()
      timer:close()
      STATE.ATTACHED_BUFFERS[bufnr] = nil
    end
  })
end

--- Can be used to detach from the buffer at any time
function M.buf_detach(bufnr)
  bufnr = helpers.get_bufnr(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, NAMESPACE, 0, -1)
  STATE.ATTACHED_BUFFERS[bufnr] = nil
end

return M
