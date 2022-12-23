local tree_sitter_config = require("hurl.tree-sitter-config")
local M = {}

M.register_treesitter = tree_sitter_config.register_treesitter

function M.setup()
  M.register_treesitter()
end

return M
