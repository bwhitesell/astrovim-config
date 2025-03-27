---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  init = function()
    -- prevent AstroNvim from setting up null-ls for us
    require("astrocore").plugin_opts("nvimtools/none-ls.nvim", { enabled = false })
  end,
  config = function()
    local null_ls = require("null-ls")
    local flake8 = require("./null_ls_sources.flake8")

    null_ls.setup({
      debug = true,
      autostart = true, -- ✅ 100% guaranteed to apply
      sources = {
        flake8,
        null_ls.builtins.diagnostics.mypy.with({
          extra_args = { "--strict" },
        }),
      },
    })
  end,
}
