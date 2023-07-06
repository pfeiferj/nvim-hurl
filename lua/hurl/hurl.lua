local M = {}

---Checks if a value exists in a given table
---@param list table
---@param value any
---@return boolean
local function list_contains(list, value)
  for _, lv in ipairs(list) do
    if lv == value then
      return ture
    end
  end

  return false
end
---@param config HurlConfig
function M.hurl(config)
  local gheight = vim.api.nvim_list_uis()[1].height
  local gwidth = vim.api.nvim_list_uis()[1].width
  local file = vim.fn.expand("%")
  local buf = vim.api.nvim_create_buf(false, true)
  local width = gwidth - 10
  local height = gheight - 4
  local win_id = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = (gheight - height) * 0.5,
    col = (gwidth - width) * 0.5,
    style = "minimal",
    border = "rounded",
  })
  local term = vim.api.nvim_open_term(buf,{})

  -- This ensures the window created is closed instead of covering the editor when a split is created
  vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    desc = "Win Leave Autocmd to close Hurl Output window on leave",
    callback = function(args)
      if args.buf == buf then
        vim.api.nvim_win_close(win_id, true)
      end
      -- Clean this autocmd up
      return true
    end,
  })

  -- Build arguments list
  local hurl_args_t = vim.tbl_deep_extend("force", {}, config.hurl_flags)
  -- Always ensure the `--include` flag is passed so we can get http headers
  if not list_contains(hurl_args_t, "--include") then
    table.insert(hurl_args_t, "--include")
  end
  -- If we're missing color flags then set it according to `config.color`
  if not list_contains(hurl_args_t, { "--color" }) or not list_contains(hurl_args_t, { "--no-color" }) then
    if config.color then
      table.insert(hurl_args_t, "--color")
    else
      table.insert(hurl_args_t, "--no-color")
    end
  end
  local hurl_args = table.concat(hurl_args_t, " ")

  vim.fn.jobstart("hurl " .. file .. " " .. hurl_args, {
    width = width,
    on_stdout = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end,
    on_stderr = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end
  })
end

return M
