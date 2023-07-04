local M = {}

---@param config HurlConfig
function M.hurl(config)
  local gheight = vim.api.nvim_list_uis()[1].height
  local gwidth = vim.api.nvim_list_uis()[1].width
  local file = vim.fn.expand("%")
  local buf = vim.api.nvim_create_buf(true, true)
  local width = gwidth - 10
  local height = gheight - 4
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = (gheight - height) * 0.5,
    col = (gwidth - width) * 0.5,
    style = "minimal",
    border = "rounded",
  })
  local term = vim.api.nvim_open_term(buf,{})

  -- Build arguments list
  local hurl_args_t = {}
  if config.color then
    table.insert(hurl_args_t, "--color")
  else
    table.insert(hurl_args_t, "--no-color")
  end
  local hurl_args = table.concat(hurl_args_t, " ")

  vim.fn.jobstart("hurl " .. file .. " " .. hurl_args, {
    width = width,
    on_stdout = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end,
    on_stderr = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end
  })
end

return M
