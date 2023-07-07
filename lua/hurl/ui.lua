local M = {}
local list_contains = require("hurl.utils").list_contains

local has_nui = nil
local Layout = nil
local Popup = nil
local Split = nil
local event = nil

if pcall(require,"nui.utils") then
  has_nui = true
  Layout = require("nui.layout")
  Popup = require("nui.popup")
  Split = require("nui.split")
  event = require("nui.utils.autocmd").event
end

function M.open(config, flags)
  if has_nui then
    return M.open_nui(config, flags)
  else
    return M.open_fallback(config, flags)
  end
end

function M.open_nui(config, flags)
  local S = {}
  S.win = nil
  if config.win_type == "popup" then
    S.win = Popup(config.win_options)
    -- mount/open the component
    S.win:mount()

    -- unmount component when cursor leaves buffer
    S.win:on(event.BufLeave, function()
      S.win:unmount()
    end)
  elseif config.win_type == "split" then
    S.win = Split(config.win_options)

    -- mount/open the component
    S.win:mount()

    -- unmount component when cursor leaves buffer
    S.win:on(event.BufLeave, function()
      S.win:unmount()
    end)
  else
    return M.open_fallback(config, flags)
  end

  S.width = vim.fn.winwidth(S.win.win_id)

  S.use_term = false
  if list_contains(flags, "--color") then
    S.use_term = true
    S.term = vim.api.nvim_open_term(S.win.bufnr,{})
  end

  function S.write(data)
    if S.use_term then
      vim.api.nvim_chan_send(S.term,table.concat(data, "\r\n"))
    else
      vim.api.nvim_buf_set_lines(S.win.bufnr, -1, -1, false, data)
    end
  end

  function S.close()
    S.win:unmount()
  end

  return S
end

function M.open_fallback(config, flags)
  local S = {}

  S.gheight = vim.api.nvim_list_uis()[1].height
  S.gwidth = vim.api.nvim_list_uis()[1].width
  S.buf = vim.api.nvim_create_buf(false, true)
  S.width = S.gwidth - 10
  S.height = S.gheight - 4
  S.win_id = vim.api.nvim_open_win(S.buf, true, {
    relative = "editor",
    width = S.width,
    height = S.height,
    row = (S.gheight - S.height) * 0.5,
    col = (S.gwidth - S.width) * 0.5,
    style = "minimal",
    border = "rounded",
  })

  S.use_term = false
  if list_contains(flags, "--color") then
    S.use_term = true
    S.term = vim.api.nvim_open_term(S.buf,{})
  end

  -- This ensures the window created is closed instead of covering the editor when a split is created
  vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    desc = "Win Leave Autocmd to close Hurl Output window on leave",
    callback = function(args)
      if args.buf == S.buf then
        vim.api.nvim_win_close(S.win_id, true)
      end
      -- Clean this autocmd up
      return true
    end,
  })


  function S.write(data)
    if S.use_term then
      vim.api.nvim_chan_send(S.term,table.concat(data, "\r\n"))
    else
      vim.api.nvim_buf_set_lines(S.buf, -1, -1, false, data)
    end
  end

  function S.close()
    vim.api.nvim_win_close(S.win_id, true)
  end

  return S
end


return M
