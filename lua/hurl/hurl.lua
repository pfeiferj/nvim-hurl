local M = {}
local gheight = vim.api.nvim_list_uis()[1].height
local gwidth = vim.api.nvim_list_uis()[1].width
function M.hurl()
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
--let buf = nvim_create_buf(v:false, v:true)
--call nvim_buf_set_lines(buf, 0, -1, v:true, ["test", "text"])
--let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
--\ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
--let win = nvim_open_win(buf, 0, opts)
--" optional: change highlight, otherwise Pmenu is used
--call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
end
return M
