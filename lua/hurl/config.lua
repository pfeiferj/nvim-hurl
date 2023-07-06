local M = {}

---@class HurlConfig
---@field color boolean
---@field hurl_flags string[]
M.config = {
  color = true,
  hurl_flags = {},
}

---Combines the config with the given user configuration
---@param user_config HurlConfig
function M.update_config(user_config)
  if user_config == nil then
    return
  end
  M.config = vim.tbl_deep_extend("force", M.config, user_config)
end


return M
