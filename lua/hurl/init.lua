local tree_sitter_config = require("hurl.tree-sitter-config")
local h = require("hurl.hurl")
local M = {}

M.register_treesitter = tree_sitter_config.register_treesitter
M.hurl = h.hurl
M.hurl_no_color = h.hurl_no_color

function M.setup()
  vim.filetype.add({
	  extension = {
	    hurl = "hurl",
	  },
	  filename = {
	    [".hurl"] = "hurl",
	  }
	})
  M.register_treesitter()
  vim.api.nvim_create_user_command("Hurl", h.hurl, {})
  vim.api.nvim_create_user_command("HurlNoColor", h.hurl_no_color, {})
end

return M
