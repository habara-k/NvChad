local present, dap = pcall(require, "dap")
if not present then
    return
end

require('dap').set_log_level('TRACE')

-- Python: https://github.com/mfussenegger/nvim-dap-python#usage
require('dap-python').setup('~/.asdf/shims/python3')


-- C/C++, Rust: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-vscode',
    name = "lldb"
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
    },
}


-- Go: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#Go
dap.adapters.go = {
    type = "server",
    host = "127.0.0.1",
    port = 38697,
}
dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    }
}
-- Execute in the same directory
-- $ dlv dap -l 127.0.0.1:38697 --log --log-output="dap"

