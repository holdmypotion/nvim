-- lua/custom/leetcode/ui/problem.lua
local Popup = require("nui.popup")
local Layout = require("nui.layout")
local http = require("custom.leetcode.http")
local base = require("custom.leetcode.base")

local M = {}

-- Convert HTML to markdown-like format
local function html_to_markdown(html)
    -- Basic HTML to markdown conversion
    local md = html:gsub("<pre>", "```"):gsub("</pre>", "```")
    md = md:gsub("<code>", "`"):gsub("</code>", "`")
    md = md:gsub("<strong>", "**"):gsub("</strong>", "**")
    md = md:gsub("<em>", "*"):gsub("</em>", "*")
    md = md:gsub("<p>", ""):gsub("</p>", "\n\n")
    md = md:gsub("<ul>", ""):gsub("</ul>", "\n")
    md = md:gsub("<li>", "* "):gsub("</li>", "\n")
    md = md:gsub("<br/>", "\n")
    -- Remove any remaining HTML tags
    md = md:gsub("<[^>]+>", "")
    return md
end

-- Safe buffer modification
local function set_buffer_lines(bufnr, start_idx, end_idx, lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(bufnr, start_idx, end_idx, false, lines)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
end

function M.show_problem(titleSlug)
    -- Check if user is logged in
    if not base.config.token then
        vim.notify("Please login first using :LeetCodeLogin", vim.log.levels.ERROR)
        return
    end

    -- Fetch problem details
    local query = [[
        query questionData($titleSlug: String!) {
            question(titleSlug: $titleSlug) {
                title
                content
                difficulty
                hints
                sampleTestCase
                topicTags {
                    name
                }
            }
        }
    ]]
    
    local result, err = http.graphql(query, { titleSlug = titleSlug }, base.config.token)
    if err then
        vim.notify("Failed to fetch problem: " .. err, vim.log.levels.ERROR)
        return
    end

    if not result or not result.data or not result.data.question then
        vim.notify("Invalid problem data received", vim.log.levels.ERROR)
        return
    end

    local problem = result.data.question
    local content = html_to_markdown(problem.content)

    -- Create the main popup
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " " .. problem.title .. " [" .. problem.difficulty .. "] ",
                top_align = "left",
            },
        },
        position = "50%",
        size = {
            width = "80%",
            height = "80%",
        },
        buf_options = {
            modifiable = true,
            readonly = false,
        },
    })

    -- Mount and setup the popup
    popup:mount()
    
    -- Prepare all content
    local lines = vim.split(content, "\n", { plain = true })
    
    -- Add topic tags if available
    if problem.topicTags and #problem.topicTags > 0 then
        table.insert(lines, "")
        table.insert(lines, "Topics:")
        for _, tag in ipairs(problem.topicTags) do
            table.insert(lines, "* " .. tag.name)
        end
    end

    -- Add test cases section
    if problem.sampleTestCase then
        table.insert(lines, "")
        table.insert(lines, "Sample Test Cases:")
        table.insert(lines, "```")
        table.insert(lines, problem.sampleTestCase)
        table.insert(lines, "```")
    end

    -- Add hints section
    if problem.hints and #problem.hints > 0 then
        table.insert(lines, "")
        table.insert(lines, "Hints:")
        for _, hint in ipairs(problem.hints) do
            table.insert(lines, "* " .. hint)
        end
    end

    -- Set all content at once
    set_buffer_lines(popup.bufnr, 0, -1, lines)
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(popup.bufnr, "filetype", "markdown")
    vim.api.nvim_buf_set_option(popup.bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_option(popup.bufnr, "swapfile", false)
    
    -- Add keymaps
    popup:map("n", "q", function()
        popup:unmount()
    end, { noremap = true })
    
    popup:map("n", "<ESC>", function()
        popup:unmount()
    end, { noremap = true })

    -- Return the popup for chaining
    return popup
end

return M
