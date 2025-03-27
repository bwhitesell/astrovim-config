vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "pyright" then
      vim.notify("💤 Pyright diagnostics overridden")
      client.handlers["textDocument/publishDiagnostics"] = function() end
    end
  end,
})
