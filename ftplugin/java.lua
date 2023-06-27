local function progress_report(_, result, ctx)
    local lsp = vim.lsp
    local info = {
        client_id = ctx.client_id,
    }

    local kind = "report"
    if result.complete then
        kind = "end"
    elseif result.workDone == 0 then
        kind = "begin"
    elseif result.workDone > 0 and result.workDone < result.totalWork then
        kind = "report"
    else
        kind = "end"
    end

    local percentage = 0
    if result.totalWork > 0 and result.workDone >= 0 then
        percentage = result.workDone / result.totalWork * 100
    end

    local msg = {
        token = result.id,
        value = {
            kind = kind,
            percentage = percentage,
            title = result.subTask,
            message = result.subTask,
        },
    }
    -- print(vim.inspect(result))

    lsp.handlers["$/progress"](nil, msg, info)
end

local config = function ()
    local config = {
        cmd = {
            '/usr/bin/jdtls',
            '--jvm-arg=-javaagent:/home/subwave/.config/nvim/deps/lombok.jar',
            '--jvm-arg=-Xbootclasspath/a:/home/subwave/.config/nvim/deps/lombok.jar'
        },

        root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
        handlers = {
            ["language/progressReport"] = progress_report,
        },

        init_options = {
            extendedClientCapabilities = {
                progressReportProvider = false,
            },
            bundles = {
                vim.fn.glob("/home/subwave/soft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
            }
        }

        -- on_attach = function(client, bufnr)
            --     local wk = require("which-key")
            --     wk.register({
                --         K = { vim.lsp.buf.hover, "Hover actions for Java" }
                --     }, {
                    --         buffer = bufnr
                    --     })
                    -- end
    }
    config['on_attach'] = function(client, bufnr)
        -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
        -- you make during a debug session immediately.
        -- Remove the option if you do not want that.
        -- You can use the `JdtHotcodeReplace` command to trigger it manually
        require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    end
    config.settings = {
        java = {
            signatureHelp = { enabled = true },
        }
    }
    require('jdtls').start_or_attach(config)

end

config()
