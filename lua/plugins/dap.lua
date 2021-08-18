local present, dap = pcall(require, "dap")
if not present then
    return
end

require('dap').set_log_level('TRACE')

-- Python
require('dap-python').setup('~/.asdf/shims/python3')

-- C++
dap.adapters.cpp = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb-vscode',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}

dap.configurations.cpp = {
    {
        name = "lldb",
        type = "cpp",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        externalTerminal = false,
        stopOnEntry = false,
        args = {}
    },
}

-- Rust
dap.adapters.rust = dap.adapters.cpp

dap.configurations.rust = {
    {
        type = "rust",
        name = "Debug",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    }
}

-- Go
dap.adapters.go = function(callback, config)
    local handle
    local pid_or_err
    local port = 38697
    handle, pid_or_err =
    vim.loop.spawn(
    "dlv",
    {
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
    },
    function(code)
        handle:close()
        print("Delve exited with exit code: " .. code)
    end
    )
    ----should we wait for delve to start???
    --vim.defer_fn(
    --function()
    --dap.repl.open()
    --callback({type = "server", host = "127.0.0.1", port = port})
    --end,
    --100)
    dap.repl.open()
    callback({type = "server", host = "127.0.0.1", port = port})
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}"
    }
}

-- start delve in DAP mode manually from your project folder by running the following command before start debugging.
-- dlv dap -l 127.0.0.1:38697 --log --log-output="dap"

