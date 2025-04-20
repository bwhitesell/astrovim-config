vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "pyright" then
      vim.notify "💤 Pyright diagnostics overridden"
      client.handlers["textDocument/publishDiagnostics"] = function() end
    end

    if client.name == "kotlin_language_server" then
      vim.schedule(function()
        client.server_capabilities.documentFormattingProvider = false
        vim.notify("💥 Kotlin formatting forcibly disabled", vim.log.levels.INFO)
      end)
    end
  end,
})
