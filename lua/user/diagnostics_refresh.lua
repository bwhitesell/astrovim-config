local null_ls = require("null-ls")
local methods = require("null-ls.methods")

local M = {}

M.refresh_null_ls_diagnostics = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local params = {
    method = methods.internal.DIAGNOSTICS,
    bufnr = bufnr,
    ft = ft,
  }

  vim.notify("🔁 Forcing null-ls diagnostics for buffer " .. bufnr)

  null_ls._request(methods.internal.DIAGNOSTICS, params, function(err)
    if err then
      vim.notify("null-ls diagnostic error: " .. err, vim.log.levels.ERROR)
    end
  end)
end

return M
