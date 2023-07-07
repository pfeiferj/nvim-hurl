local M = {}

---Checks if a value exists in a given table
---@param list table
---@param value any
---@return boolean
function M.list_contains(list, value)
  for _, lv in ipairs(list) do
    if lv == value then
      return true
    end
  end

  return false
end

return M
