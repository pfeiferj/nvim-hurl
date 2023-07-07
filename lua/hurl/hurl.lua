local M = {}
local ui = require("hurl.ui")
local list_contains = require("hurl.utils").list_contains

---@param config HurlConfig
function M.hurl(config)
  local file = vim.fn.expand("%")

  -- Build arguments list
  local hurl_args_t = vim.tbl_deep_extend("force", {}, config.hurl_flags)
  -- If we're missing color flags then set it according to `config.color`
  if not list_contains(hurl_args_t, "--color") and not list_contains(hurl_args_t, "--no-color") then
    if config.color then
      table.insert(hurl_args_t, "--color")
    else
      table.insert(hurl_args_t, "--no-color")
    end
  end

  local win = ui.open(config, hurl_args_t)

  local function output_data(chan, data)
    win.write(data)
  end

  vim.fn.jobstart({"hurl", file, unpack(hurl_args_t)}, {
    width = win.width,
    on_stdout = output_data,
    on_stderr = output_data
  })
end

return M
