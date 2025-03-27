local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local u = require("null-ls.utils")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local overrides = {
    severities = {
        E = h.diagnostics.severities["error"],      -- Error
        F = h.diagnostics.severities["error"],      -- Pyflakes
        W = h.diagnostics.severities["warning"],    -- Warning
        C = h.diagnostics.severities["information"],-- Convention
        N = h.diagnostics.severities["information"],-- Naming (flake8-naming)
    },
}

return h.make_builtin({
    name = "flake8",
    meta = {
        url = "https://flake8.pycqa.org/",
        description = [[Flake8 is a Python tool that glues together PyFlakes, pycodestyle, and Ned Batchelder’s McCabe script for checking the style and quality of Python code.]],
    },
    method = DIAGNOSTICS,
    filetypes = { "python" },
    generator_opts = {
        command = "flake8",
        args = {
            "--format=%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
            "--stdin-display-name",
            "$FILENAME",
            "-",
        },
        to_stdin = true,
        format = "line",
        check_exit_code = function(code)
            return code <= 1
        end,
        on_output = function(line, params)
            local pattern = "([^:]+):(%d+):(%d+): (%w%d+)%s+(.*)"
            local filename, row, col, code, message = line:match(pattern)
            if not filename then
                return nil
            end

            local severity_map = {
                E = h.diagnostics.severities["error"],
                F = h.diagnostics.severities["error"],
                W = h.diagnostics.severities["warning"],
                C = h.diagnostics.severities["information"],
                N = h.diagnostics.severities["information"],
            }

            local severity = severity_map[code:sub(1, 1)] or h.diagnostics.severities["warning"]

            return {
                row = tonumber(row),
                col = tonumber(col),
                source = "flake8",
                message = message,
                severity = severity,
                code = code,
            }
        end,
        cwd = h.cache.by_bufnr(function(params)
            return u.root_pattern(
                ".flake8",
                "setup.cfg",
                "tox.ini",
                "pyproject.toml"
            )(params.bufname)
        end),
    },
    factory = h.generator_factory,
})
