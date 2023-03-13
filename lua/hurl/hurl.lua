local M = {}

function M.hurl()
  local gheight = vim.api.nvim_list_uis()[1].height
  local gwidth = vim.api.nvim_list_uis()[1].width
  local file = vim.fn.expand("%")
  local buf = vim.api.nvim_create_buf(false, true)
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
  local h = vim.fn.jobstart("hurl " .. file .. " --color", {
    width = width,
    on_stdout = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end,
    on_stderr = function(chan, data) vim.api.nvim_chan_send(term,table.concat(data, "\r\n")) end
  })
end

function M.hurl_no_color()
  local gheight = vim.api.nvim_list_uis()[1].height
  local gwidth = vim.api.nvim_list_uis()[1].width
  local h = io.popen("hurl " .. vim.fn.expand("%") .. " 2>&1")
  if h then
    h:flush()
    local output = h:read("*a")
    h:close()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = gwidth - 10
    local height = gheight - 4
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(output, "\n", {plain=true}))
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = (gheight - height) * 0.5,
      col = (gwidth - width) * 0.5,
      style = "minimal",
      border = "rounded",
    })
  end
end

return M
