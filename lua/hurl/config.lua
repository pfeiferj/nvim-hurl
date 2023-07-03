local M = {}

---@class HurlConfig
---@field color boolean
M.config = {
  color = true,
}

---Combines the config with the given user configuration
---@param user_config HurlConfig
function M.update_config(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config)
end


return M
