-- lua/custom/leetcode/ui/search.lua
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local http = require("custom.leetcode.http")

local M = {}

function M.search_problems(opts)
    opts = opts or {}
    
    -- Create picker
    pickers.new(opts, {
        prompt_title = "LeetCode Problems",
        finder = finders.new_dynamic({
            fn = function(query)
                if query and #query > 2 then
                    local results, err = http.graphql(
                        http.queries.problem_search,
                        { keyword = query },
                        require("custom.leetcode.base").config.token
                    )
                    
                    if results and results.data then
                        return results.data.problemsetQuestionList.questions
                    end
                    return {}
                end
                return {}
            end,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = string.format(
                        "%s [%s] (%s)",
                        entry.title,
                        entry.difficulty,
                        entry.acRate and string.format("%.1f%%", entry.acRate) or "N/A"
                    ),
                    ordinal = entry.title,
                }
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                -- Open problem
                require("custom.leetcode.ui.problem").show(selection.value.titleSlug)
            end)
            return true
        end,
    }):find()
end

return M
