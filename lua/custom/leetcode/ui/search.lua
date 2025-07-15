local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local http = require("custom.leetcode.http")
local base = require("custom.leetcode.base")

local M = {}

-- Format problem difficulty with colors
local function format_difficulty(difficulty)
    local colors = {
        Easy = "green",
        Medium = "yellow",
        Hard = "red"
    }
    return string.format("%%#%s#%s%%*", colors[difficulty], difficulty)
end

function M.search_problems()
    -- Check if user is logged in
    if not base.config.token then
        vim.notify("Please login first using :LeetCodeLogin", vim.log.levels.ERROR)
        return
    end

    -- Query problems from LeetCode
    local result, err = http.graphql(http.queries.problem_search, {}, base.config.token)
    if err then
        vim.notify("Failed to fetch problems: " .. err, vim.log.levels.ERROR)
        return
    end

    local problems = result.data.problemsetQuestionList.questions

    pickers.new({}, {
        prompt_title = "LeetCode Problems",
        finder = finders.new_table {
            results = problems,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format(
                        "%s [%s] %s",
                        entry.title,
                        format_difficulty(entry.difficulty),
                        entry.status and "✓" or ""
                    ),
                    ordinal = entry.title,
                }
            end,
        },
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            title = "Problem Details",
            define_preview = function(self, entry)
                local problem = entry.value
                local lines = {
                    "Title: " .. problem.title,
                    "Difficulty: " .. problem.difficulty,
                    "Acceptance Rate: " .. string.format("%.1f%%", problem.acRate),
                    "Status: " .. (problem.status and "Solved" or "Not Solved"),
                    "",
                    "Press Enter to open this problem"
                }
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            end,
        }),
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

return M 