local config = require("hurl.config")
local tree_sitter_config = require("hurl.tree-sitter-config")
local h = require("hurl.hurl")
local M = {}

M.register_treesitter = tree_sitter_config.register_treesitter
M.hurl = h.hurl
M.hurl_no_color = function ()
    h.hurl(vim.tbl_deep_extend("force", config.config, { color = false }))
end
M.config = config

---@param user_config HurlConfig
function M.setup(user_config)
  config.update_config(user_config)
  vim.filetype.add({
    extension = {
      hurl = "hurl",
    },
    filename = {
      [".hurl"] = "hurl",
    },
  })
  M.register_treesitter()
  vim.api.nvim_create_user_command("Hurl", function()
    h.hurl(config.config)
  end, {})
  vim.api.nvim_create_user_command("HurlNoColor", function()
    h.hurl(vim.tbl_deep_extend("force", config.config, { color = false }))
  end, {})
end

return M
