-- TODO: add this to null-ls, check through contributing guidelines first


local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

local known_dialects = {
    -- default dialects in sqlfluff
    ansi = "ansi",
    bigquery = "bigquery",
    exasol = "exasol",
    hive = "hive",
    mysql = "mysql",
    postgres = "postgres",
    redshift = "redshift",
    snowflake = "snowflake",
    spark3 = "spark3",
    sqlite = "sqlite",
    teradata = "teradata",
    tsql = "tsql",
    -- ftplugin dialects that map to a known sqlfluff dialect
    pgsql = "postgres",
}

local function sql_dialect(bufnr)
    -- The default sql ftplugin uses b:sql_type_override and g:sql_type_default
    -- to set dialects.
    local result, val = pcall(vim.api.nvim_buf_get_var, bufnr, "sql_type_override")
    if not result then
        val = vim.g.sql_type_default
    end
    return known_dialects[val]
end

-- severity adapter, necessary until this issue is resolved and sqlfluff
-- includes its own severities: https://github.com/sqlfluff/sqlfluff/issues/201
local severities = h.diagnostics.severities

local severity_from_code = {
    severity = function(entries, _)
        if "PRS" == entries.code then
            return severities["error"]
        else
            return severities["warning"]
        end
    end,
}

return h.make_builtin({
    -- sqlfluff is somewhat slow, use DIAGNOSTICS_ON_SAVE by default
    method = DIAGNOSTICS_ON_SAVE,
    filetypes = { "sql" },
    generator_opts = {
        command = "sqlfluff",
        args = function(params)
            local args = {
                "lint",
                "--disable_progress_bar",
                "--format",
                "json",
                "-",
            }
            local dialect = sql_dialect(params.bufnr)
            if dialect then
                table.insert(args, "--dialect")
                table.insert(args, dialect)
            end
            return args
        end,
        to_stdin = true,
        from_stderr = true,
        format = "json",
        on_output = function(params)
            local parser = h.diagnostics.from_json({
                attributes = {
                    code = "code",
                    row = "line_no",
                    col = "line_pos",
                    message = "description",
                },
                adapters = { severity_from_code },
            })
            return parser({ output = params.output[1].violations })
        end,
    },
    factory = h.generator_factory,
})
