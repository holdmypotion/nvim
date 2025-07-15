-- plugin/leetcode.lua
local M = {}

-- Plugin configuration
M.config = {
    directory = vim.fn.getcwd(), -- Default to current directory
    language = "python",         -- Default language
    token = nil,                -- LeetCode session token
    browser_command = "open"    -- Default browser command for macOS
}

-- Load saved token if exists
local function load_token()
    local config_dir = vim.fn.stdpath("data") .. "/leetcode-nvim"
    local token_file = io.open(config_dir .. "/token", "r")
    if token_file then
        M.config.token = token_file:read("*all")
        token_file:close()
    end
end

-- Core authentication module
M.auth = {
    login = function()
        -- Open browser for login
        local auth_url = "https://leetcode.com/accounts/login"
        os.execute(M.config.browser_command .. " " .. auth_url)
        
        -- Create input prompt for token
        vim.ui.input({
            prompt = "Paste your LeetCode session token: ",
        }, function(token)
            if token then
                M.config.token = token
                -- Save token securely
                local config_dir = vim.fn.stdpath("data") .. "/leetcode-nvim"
                vim.fn.mkdir(config_dir, "p")
                local file = io.open(config_dir .. "/token", "w")
                if file then
                    file:write(token)
                    file:close()
                    vim.notify("LeetCode: Successfully logged in!", vim.log.levels.INFO)
                end
            end
        end)
    end,
}

-- Problem search functionality
M.problems = {
    search = function()
        require("custom.leetcode.ui.search").search_problems()
    end,
    
    fetch_daily = function()
        local http = require("custom.leetcode.http")
        local query = http.queries.daily_problem
        local result, err = http.graphql(query, {}, M.config.token)
        
        if err then
            vim.notify("Failed to fetch daily problem: " .. err, vim.log.levels.ERROR)
            return
        end

        local problem = result.data.activeDailyCodingChallengeQuestion.question
        M.files.create(problem.titleSlug, M.config.language)
        require("custom.leetcode.ui.problem").show_problem(problem.titleSlug)
    end,
}

-- File creation and management
M.files = {
    create = function(problem_slug, language)
        local template = M.templates[language] or ""
        local filename = string.format("%s/%s.%s", 
            M.config.directory,
            problem_slug,
            M.file_extensions[language] or "txt"
        )
        
        local file = io.open(filename, "w")
        if file then
            file:write(template)
            file:close()
            vim.cmd("edit " .. filename)
        end
    end,
}

-- Test runner
M.test = {
    run = function()
        local http = require("custom.leetcode.http")
        local current_file = vim.fn.expand("%:t:r") -- Get current file name without extension
        local code = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        
        -- Submit test request
        local result, err = http.post("/problems/" .. current_file .. "/interpret_solution/", {
            data_input = "",  -- Use default test case
            lang = M.config.language,
            question_id = current_file,
            typed_code = code
        }, M.config.token)
        
        if err then
            vim.notify("Failed to run tests: " .. err, vim.log.levels.ERROR)
            return
        end
        
        require("custom.leetcode.ui.results").show_test_results(result)
    end,
}

-- Submit functionality
M.submit = {
    solution = function()
        local http = require("custom.leetcode.http")
        local current_file = vim.fn.expand("%:t:r") -- Get current file name without extension
        local code = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        
        -- Submit solution
        local result, err = http.post("/problems/" .. current_file .. "/submit/", {
            lang = M.config.language,
            question_id = current_file,
            typed_code = code
        }, M.config.token)
        
        if err then
            vim.notify("Failed to submit solution: " .. err, vim.log.levels.ERROR)
            return
        end
        
        require("custom.leetcode.ui.results").show_submission_results(result)
    end,
}

-- Company problems view
M.company = {
    show = function()
        require("custom.leetcode.ui.company").show_companies()
    end,
}

-- Language templates
M.templates = {
    python = [[
class Solution:
    def solve(self):
        pass
    
# Test cases
if __name__ == "__main__":
    solution = Solution()
    # Add test cases here
]],
    cpp = [[
class Solution {
public:
    
};

// Test cases
int main() {
    Solution solution;
    // Add test cases here
    return 0;
}
]],
    java = [[
class Solution {
    
}

// Test cases
class Main {
    public static void main(String[] args) {
        Solution solution = new Solution();
        // Add test cases here
    }
}
]],
    javascript = [[
/**
 * @param {*} params
 * @return {*}
 */
var solution = function(params) {
    
};

// Test cases
// Add test cases here
]],
}

-- File extensions mapping
M.file_extensions = {
    python = "py",
    cpp = "cpp",
    java = "java",
    javascript = "js",
}

-- Setup function
function M.setup(opts)
    -- Merge configurations
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    
    -- Load saved token
    load_token()
    
    -- Create commands
    local commands = {
        LeetCodeLogin = M.auth.login,
        LeetCodeSearch = M.problems.search,
        LeetCodeDaily = M.problems.fetch_daily,
        LeetCodeTest = M.test.run,
        LeetCodeSubmit = M.submit.solution,
        LeetCodeCompany = M.company.show,
    }
    
    for command_name, command_fn in pairs(commands) do
        vim.api.nvim_create_user_command(command_name, function()
            command_fn()
        end, {})
    end
    
    -- Return the module for chaining
    return M
end

return M
