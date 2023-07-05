local M = {}

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
  if not vim.list_contains(hurl_args_t, "--include") then
    table.insert(hurl_args_t, "--include")
  end
  -- If we're missing color flags then set it according to `config.color`
  if not vim.list_contains(hurl_args_t, { "--color" }) or not vim.list_contains(hurl_args_t, { "--no-color" }) then
    if config.color then
      table.insert(hurl_args_t, "--color")
    else
      table.insert(hurl_args_t, "--no-color")
    end
  end

  -- Append the hurl file to target
  table.insert(hurl_args_t, file)
  -- Insert the hurl command as the first element of the table. This avoids bugs where the hurl command is in the
  -- wrong position within the table causing `vim.system` to fail
  table.insert(hurl_args_t, 1, "hurl")
  vim.system(
    hurl_args_t,
    { text = true },
    ---@param cmd SystemCompleted
    function(cmd)
      vim.schedule(function()
        local term = vim.api.nvim_open_term(buf, {})
        vim.api.nvim_chan_send(term, table.concat(vim.split(cmd.stdout, "\n"), "\r\n"))
        vim.api.nvim_chan_send(term, table.concat(vim.split(cmd.stderr, "\n"), "\r\n"))
      end)
    end
  )
end

return M
