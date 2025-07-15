local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local http = require("custom.leetcode.http")
local base = require("custom.leetcode.base")

local M = {}

-- Debug function
local function debug_print(data, prefix)
    prefix = prefix or ""
    if type(data) == "table" then
        for k, v in pairs(data) do
            if type(v) == "table" then
                vim.notify(prefix .. k .. ": (table)", vim.log.levels.DEBUG)
                debug_print(v, prefix .. "  ")
            else
                vim.notify(prefix .. k .. ": " .. tostring(v), vim.log.levels.DEBUG)
            end
        end
    else
        vim.notify(prefix .. tostring(data), vim.log.levels.DEBUG)
    end
end

-- List of major companies
local companies = {
    { name = "Google", slug = "google" },
    { name = "Amazon", slug = "amazon" },
    { name = "Microsoft", slug = "microsoft" },
    { name = "Facebook", slug = "meta" },  -- Updated slug for Facebook/Meta
    { name = "Apple", slug = "apple" },
    { name = "Bloomberg", slug = "bloomberg" },
    { name = "Uber", slug = "uber" },
    { name = "LinkedIn", slug = "linkedin" },
    { name = "Twitter", slug = "twitter" },
    { name = "Adobe", slug = "adobe" },
}

-- Custom previewer for company problems
local problem_previewer = previewers.new_buffer_previewer({
    title = "Problem Details",
    define_preview = function(self, entry)
        local lines = {
            "Title: " .. entry.value.title,
            "Difficulty: " .. entry.value.difficulty,
            entry.value.frequency and ("Frequency: " .. string.format("%.1f%%", entry.value.frequency * 100)) or "Frequency: N/A",
            "",
            "Press Enter to open this problem"
        }
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    end
})

-- Custom previewer for companies
local company_previewer = previewers.new_buffer_previewer({
    title = "Company Info",
    define_preview = function(self, entry)
        local lines = {
            "Company: " .. entry.value.name,
            "",
            "Press Enter to view company problems"
        }
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    end
})

local function show_company_problems(company)
    -- Check if user is logged in
    if not base.config.token then
        vim.notify("Please login first using :LeetCodeLogin", vim.log.levels.ERROR)
        return
    end

    -- Query company problems
    local query = http.queries.company_problems
    local result, err = http.graphql(query, { slug = company.slug }, base.config.token)
    
    if err then
        vim.notify("Failed to fetch company problems: " .. err, vim.log.levels.ERROR)
        return
    end

    -- Debug response
    if not result then
        vim.notify("No response from LeetCode API", vim.log.levels.ERROR)
        return
    end

    -- Debug print the response
    vim.notify("API Response received", vim.log.levels.INFO)
    debug_print(result)

    -- Parse the response carefully
    local problems = {}
    if type(result) == "table" and result.data and type(result.data) == "table" then
        local company_tag = result.data.companyTag
        if type(company_tag) == "table" and company_tag.questions then
            problems = company_tag.questions
        else
            vim.notify("Company tag data not found in response", vim.log.levels.ERROR)
            debug_print(result.data)
            return
        end
    else
        vim.notify("Invalid response structure from API", vim.log.levels.ERROR)
        return
    end

    if #problems == 0 then
        vim.notify("No problems found for " .. company.name, vim.log.levels.WARN)
        return
    end

    -- Create picker
    pickers.new({}, {
        prompt_title = company.name .. " Problems",
        finder = finders.new_table {
            results = problems,
            entry_maker = function(entry)
                local freq_display = ""
                if entry.frequency then
                    freq_display = string.format(" (Frequency: %.1f%%)", entry.frequency * 100)
                end
                
                return {
                    value = entry,
                    display = string.format(
                        "%s [%s]%s",
                        entry.title,
                        entry.difficulty,
                        freq_display
                    ),
                    ordinal = entry.title,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = problem_previewer,
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                -- Create solution file and open problem
                base.files.create(selection.value.titleSlug, base.config.language)
                require("custom.leetcode.ui.problem").show_problem(selection.value.titleSlug)
            end)
            return true
        end,
    }):find()
end

function M.show_companies()
    -- Check if user is logged in
    if not base.config.token then
        vim.notify("Please login first using :LeetCodeLogin", vim.log.levels.ERROR)
        return
    end

    pickers.new({}, {
        prompt_title = "LeetCode Companies",
        finder = finders.new_table {
            results = companies,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = company_previewer,
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                show_company_problems(selection.value)
            end)
            return true
        end,
    }):find()
end

return M 