local Popup = require("nui.popup")
local Layout = require("nui.layout")

local M = {}

local function create_results_popup(title, results)
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " " .. title .. " ",
                top_align = "left",
            },
        },
        position = "50%",
        size = {
            width = "60%",
            height = "60%",
        },
        buf_options = {
            modifiable = false,
            readonly = true,
        },
    })

    popup:mount()

    -- Format and display results
    local lines = {}
    if type(results) == "table" then
        if results.status_code then
            table.insert(lines, "Status: " .. results.status_msg)
            table.insert(lines, "Runtime: " .. (results.status_runtime or "N/A"))
            table.insert(lines, "Memory Usage: " .. (results.status_memory or "N/A"))
            table.insert(lines, "")
            
            if results.total_correct then
                table.insert(lines, string.format("Test Cases: %d/%d passed", 
                    results.total_correct, results.total_testcases))
            end
            
            if results.compile_error then
                table.insert(lines, "")
                table.insert(lines, "Compile Error:")
                table.insert(lines, results.compile_error)
            end
            
            if results.runtime_error then
                table.insert(lines, "")
                table.insert(lines, "Runtime Error:")
                table.insert(lines, results.runtime_error)
            end
            
            if results.last_testcase then
                table.insert(lines, "")
                table.insert(lines, "Last Test Case:")
                table.insert(lines, "```")
                table.insert(lines, results.last_testcase)
                table.insert(lines, "```")
            end
        else
            for k, v in pairs(results) do
                table.insert(lines, k .. ": " .. tostring(v))
            end
        end
    else
        table.insert(lines, tostring(results))
    end

    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(popup.bufnr, "filetype", "markdown")

    -- Add keymaps
    popup:map("n", "q", function()
        popup:unmount()
    end, { noremap = true })
    
    popup:map("n", "<ESC>", function()
        popup:unmount()
    end, { noremap = true })

    return popup
end

function M.show_test_results(results)
    return create_results_popup("Test Results", results)
end

function M.show_submission_results(results)
    return create_results_popup("Submission Results", results)
end

return M 