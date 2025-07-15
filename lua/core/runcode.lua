local M = {}

-- Function to create output window
local function create_output_window()
    -- Close existing output window if any
    vim.cmd('pclose')
    
    -- Create new window at bottom
    vim.cmd('botright 10new')
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'runner-output')
    
    -- Map q to close in the output window
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = buf, silent = true })
    
    return win, buf
end

-- Get compiler flags for C/C++
local function get_compiler_flags(filetype)
    -- Default flags
    local flags = {
        cpp = "-std=c++17 -Wall -Wextra -O2",
        c = "-std=c11 -Wall -Wextra -O2"
    }
    
    -- Try to read from a config file in the project directory
    local config_file = vim.fn.findfile('.compiler_flags.json', '.;')
    if config_file ~= "" then
        local file = io.open(config_file, "r")
        if file then
            local content = file:read("*all")
            file:close()
            
            local success, config = pcall(vim.fn.json_decode, content)
            if success and config and config[filetype] then
                return config[filetype]
            end
        end
    end
    
    return flags[filetype] or ""
end

-- Function to run code
function M.run_code()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%')
    
    -- Commands for different file types
    local commands = {
        python = string.format('python3 "%s"', filename),
        javascript = string.format('node "%s"', filename),
        typescript = string.format('ts-node "%s"', filename),
        lua = string.format('lua "%s"', filename),
        cpp = function()
            local output = vim.fn.fnamemodify(filename, ':r')
            local flags = get_compiler_flags('cpp')
            return string.format('g++ %s "%s" -o "%s" && "./%s"', flags, filename, output, output)
        end,
        c = function()
            local output = vim.fn.fnamemodify(filename, ':r')
            local flags = get_compiler_flags('c')
            return string.format('gcc %s "%s" -o "%s" && "./%s"', flags, filename, output, output)
        end,
        java = function()
            local classname = vim.fn.fnamemodify(filename, ':r')
            return string.format('javac "%s" && java %s', filename, classname)
        end,
        go = 'go run .',
        rust = function()
            if vim.fn.filereadable('Cargo.toml') == 1 then
                return 'cargo run'
            else
                local output = vim.fn.fnamemodify(filename, ':r')
                return string.format('rustc "%s" -o "%s" && "./%s"', filename, output, output)
            end
        end,
    }
    
    local command = commands[filetype]
    if type(command) == 'function' then
        command = command()
    end
    
    if command then
        -- Create output window
        local win, buf = create_output_window()
        
        -- Add header
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {'[Running] ' .. command, ''})
        
        -- Run command and capture output
        local function on_output(_, data)
            if data then
                vim.schedule(function()
                    -- Filter out empty lines at the end
                    if #data > 1 or (data[1] and #data[1] > 0) then
                        local line_count = vim.api.nvim_buf_line_count(buf)
                        vim.api.nvim_buf_set_lines(buf, line_count, -1, false, data)
                    end
                end)
            end
        end
        
        vim.fn.jobstart(command, {
            on_stdout = on_output,
            on_stderr = on_output,
            stdout_buffered = false,
            stderr_buffered = false,
            on_exit = function(_, exit_code)
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(buf) then
                        local line_count = vim.api.nvim_buf_line_count(buf)
                        local exit_message = exit_code == 0 
                            and '[Finished successfully]' 
                            or '[Finished with error code: ' .. exit_code .. ']'
                        vim.api.nvim_buf_set_lines(buf, line_count, -1, false, {'', exit_message})
                    end
                end)
            end
        })
    else
        print('No run configuration for filetype: ' .. filetype)
    end
end

-- Function to set custom compiler flags for the current filetype
function M.set_compiler_flags()
    local filetype = vim.bo.filetype
    
    if filetype ~= 'c' and filetype ~= 'cpp' then
        print("Custom compiler flags only supported for C and C++")
        return
    end
    
    vim.ui.input({
        prompt = string.format("Enter compiler flags for %s: ", filetype),
        default = get_compiler_flags(filetype)
    }, function(input)
        if input then
            -- Create or update config file
            local config_file = '.compiler_flags.json'
            local config = {}
            
            -- Try to read existing config
            local file = io.open(config_file, "r")
            if file then
                local content = file:read("*all")
                file:close()
                
                local success, existing_config = pcall(vim.fn.json_decode, content)
                if success then
                    config = existing_config
                end
            end
            
            -- Update config
            config[filetype] = input
            
            -- Write updated config
            file = io.open(config_file, "w")
            if file then
                file:write(vim.fn.json_encode(config))
                file:close()
                print(string.format("Compiler flags for %s updated", filetype))
            else
                print("Failed to write config file")
            end
        end
    end)
end

-- Set up keybindings
vim.keymap.set('n', '<leader>rc', M.run_code, { noremap = true, silent = true, desc = "Run code" })
vim.keymap.set('n', '<leader>cf', M.set_compiler_flags, { noremap = true, silent = true, desc = "Set compiler flags" })

return M
