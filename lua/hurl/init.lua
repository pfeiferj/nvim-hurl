local tree_sitter_config = require("hurl.tree-sitter-config")
local h = require("hurl.hurl")
local M = {}

M.register_treesitter = tree_sitter_config.register_treesitter
M.hurl = h.hurl

function M.setup()
  M.register_treesitter()
  vim.api.nvim_create_user_command("Hurl", h.hurl, {})
end

return M
