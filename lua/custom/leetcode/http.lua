-- lua/leetcode/http.lua
local curl = require('plenary.curl')

local M = {}

-- Base URL for LeetCode API
M.base_url = "https://leetcode.com/api"

-- GraphQL endpoint
M.graphql_url = "https://leetcode.com/graphql"

-- Debug function
local function debug_response(response)
    vim.notify("Response Status: " .. tostring(response.status), vim.log.levels.DEBUG)
    vim.notify("Response Headers:", vim.log.levels.DEBUG)
    for k, v in pairs(response.headers or {}) do
        vim.notify("  " .. k .. ": " .. tostring(v), vim.log.levels.DEBUG)
    end
    vim.notify("Response Body: " .. tostring(response.body), vim.log.levels.DEBUG)
end

-- Common headers
local function get_headers(token)
    return {
        ["Content-Type"] = "application/json",
        ["Cookie"] = "LEETCODE_SESSION=" .. token,
        ["User-Agent"] = "leetcode-nvim",
        ["Referer"] = "https://leetcode.com",
        ["Origin"] = "https://leetcode.com"
    }
end

-- Safe JSON decode
local function safe_json_decode(str)
    if not str then return nil, "No data to decode" end
    
    local ok, result = pcall(vim.json.decode, str)
    if not ok then
        return nil, "Failed to decode JSON: " .. tostring(result)
    end
    
    return result
end

-- GET request wrapper
function M.get(endpoint, token)
    local response = curl.get(M.base_url .. endpoint, {
        headers = get_headers(token)
    })
    
    debug_response(response)
    
    if response.status == 200 then
        return safe_json_decode(response.body)
    end
    return nil, "Request failed with status: " .. response.status
end

-- POST request wrapper
function M.post(endpoint, data, token)
    local response = curl.post(M.base_url .. endpoint, {
        headers = get_headers(token),
        body = vim.json.encode(data)
    })
    
    debug_response(response)
    
    if response.status == 200 then
        return safe_json_decode(response.body)
    end
    return nil, "Request failed with status: " .. response.status
end

-- GraphQL query wrapper
function M.graphql(query, variables, token)
    local response = curl.post(M.graphql_url, {
        headers = get_headers(token),
        body = vim.json.encode({
            query = query,
            variables = variables
        })
    })
    
    debug_response(response)
    
    if response.status ~= 200 then
        return nil, "GraphQL query failed with status: " .. response.status
    end
    
    local result, err = safe_json_decode(response.body)
    if not result then
        return nil, "Failed to parse GraphQL response: " .. tostring(err)
    end
    
    if result.errors then
        local error_msg = vim.inspect(result.errors)
        return nil, "GraphQL errors: " .. error_msg
    end
    
    return result
end

-- Problem search query
M.queries = {
    problem_search = [[
        query problemsetQuestionList($keyword: String) {
            problemsetQuestionList: questionList(
                keyword: $keyword
                limit: 50
            ) {
                questions {
                    titleSlug
                    title
                    difficulty
                    acRate
                    status
                }
            }
        }
    ]],
    
    daily_problem = [[
        query dailyCodingChallenge {
            activeDailyCodingChallengeQuestion {
                date
                link
                question {
                    titleSlug
                    title
                    difficulty
                    content
                    topicTags {
                        name
                    }
                }
            }
        }
    ]],
    
    company_problems = [[
        query companyTag($slug: String!) {
            companyTag(slug: $slug) {
                name
                questions {
                    titleSlug
                    title
                    difficulty
                    frequency
                }
            }
        }
    ]]
}

return M
