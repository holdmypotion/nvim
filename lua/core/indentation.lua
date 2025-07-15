-- lua/core/indentation.lua
-- Language-specific indentation configuration with toggle functionality

local M = {}

-- Default indentation settings
local DEFAULT_INDENT = 2

-- Language-specific indentation preferences
local LANGUAGE_INDENTS = {
  -- 2-space languages (web dev, configs)
  javascript = 2,
  typescript = 2,
  javascriptreact = 2,
  typescriptreact = 2,
  json = 2,
  html = 2,
  css = 2,
  scss = 2,
  sass = 2,
  vue = 2,
  svelte = 2,
  yaml = 2,
  yml = 2,
  ruby = 2,
  
  -- 4-space languages (systems, data)
  python = 4,
  lua = 4,
  java = 4,
  php = 4,
  sql = 4,
  
  -- Special cases
  go = { indent = 4, expandtab = false }, -- Go uses tabs
  make = { indent = 4, expandtab = false }, -- Makefiles use tabs
  gitconfig = { indent = 4, expandtab = false },
}

-- Track current indentation per buffer
local buffer_indents = {}

-- Set global defaults
vim.opt.tabstop = DEFAULT_INDENT
vim.opt.shiftwidth = DEFAULT_INDENT
vim.opt.softtabstop = DEFAULT_INDENT
vim.opt.expandtab = true

-- Apply indentation settings to buffer
local function apply_indent(indent_size, use_tabs)
  use_tabs = use_tabs or false
  
  vim.bo.tabstop = indent_size
  vim.bo.shiftwidth = indent_size
  vim.bo.softtabstop = use_tabs and 0 or indent_size
  vim.bo.expandtab = not use_tabs
  
  -- Store current buffer indentation
  buffer_indents[vim.api.nvim_get_current_buf()] = {
    size = indent_size,
    use_tabs = use_tabs
  }
end

-- Get language configuration
local function get_language_config(filetype)
  local config = LANGUAGE_INDENTS[filetype]
  if type(config) == "number" then
    return config, false -- size, use_tabs
  elseif type(config) == "table" then
    return config.indent, not config.expandtab
  end
  return DEFAULT_INDENT, false
end

-- Toggle between 2 and 4 spaces for current buffer
local function toggle_indent_size()
  local current_size = vim.bo.tabstop
  local new_size = current_size == 2 and 4 or 2
  local use_tabs = not vim.bo.expandtab
  
  apply_indent(new_size, use_tabs)
  
  local tab_type = use_tabs and "tabs" or "spaces"
  vim.notify(string.format("Indentation: %d %s", new_size, tab_type), vim.log.levels.INFO)
end

-- Toggle between tabs and spaces
local function toggle_tab_mode()
  local current_size = vim.bo.tabstop
  local use_tabs = not vim.bo.expandtab
  
  apply_indent(current_size, not use_tabs)
  
  local tab_type = vim.bo.expandtab and "spaces" or "tabs"
  vim.notify(string.format("Indentation: %d %s", current_size, tab_type), vim.log.levels.INFO)
end

-- Set specific indentation
local function set_indent(size, use_tabs)
  apply_indent(size, use_tabs)
  local tab_type = use_tabs and "tabs" or "spaces"
  vim.notify(string.format("Indentation: %d %s", size, tab_type), vim.log.levels.INFO)
end

-- Reset to language default
local function reset_to_language_default()
  local filetype = vim.bo.filetype
  local size, use_tabs = get_language_config(filetype)
  apply_indent(size, use_tabs)
  
  local tab_type = use_tabs and "tabs" or "spaces"
  vim.notify(string.format("Reset to %s default: %d %s", filetype, size, tab_type), vim.log.levels.INFO)
end

-- Show current indentation info
local function show_indent_info()
  local size = vim.bo.tabstop
  local use_tabs = not vim.bo.expandtab
  local filetype = vim.bo.filetype
  local tab_type = use_tabs and "tabs" or "spaces"
  
  local lang_size, lang_use_tabs = get_language_config(filetype)
  local lang_tab_type = lang_use_tabs and "tabs" or "spaces"
  
  vim.notify(string.format(
    "Current: %d %s | %s default: %d %s",
    size, tab_type, filetype, lang_size, lang_tab_type
  ), vim.log.levels.INFO)
end

-- Set up autocommands for language-specific indentation
local function setup_language_indentation()
  local indent_group = vim.api.nvim_create_augroup("LanguageIndentation", { clear = true })
  
  -- Apply language-specific indentation on file type detection
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      local filetype = vim.bo.filetype
      if filetype and filetype ~= "" then
        local size, use_tabs = get_language_config(filetype)
        apply_indent(size, use_tabs)
      end
    end,
    group = indent_group,
  })
end

-- Create commands
local function setup_commands()
  vim.api.nvim_create_user_command("IndentToggle", toggle_indent_size, 
    { desc = "Toggle between 2 and 4 space indentation" })
  vim.api.nvim_create_user_command("IndentTabToggle", toggle_tab_mode, 
    { desc = "Toggle between tabs and spaces" })
  vim.api.nvim_create_user_command("IndentReset", reset_to_language_default, 
    { desc = "Reset to language default indentation" })
  vim.api.nvim_create_user_command("IndentInfo", show_indent_info, 
    { desc = "Show current indentation info" })
  
  -- Commands with arguments
  vim.api.nvim_create_user_command("IndentSet", function(opts)
    local args = vim.split(opts.args, " ")
    local size = tonumber(args[1])
    local use_tabs = args[2] == "tabs"
    
    if size then
      set_indent(size, use_tabs)
    else
      vim.notify("Usage: IndentSet <size> [spaces|tabs]", vim.log.levels.ERROR)
    end
  end, { 
    nargs = "+", 
    desc = "Set indentation: IndentSet <size> [spaces|tabs]",
    complete = function(ArgLead, CmdLine, CursorPos)
      return { "2", "4", "8", "spaces", "tabs" }
    end
  })
end

-- Set up keymaps
local function setup_keymaps()
  local map = require("helpers.keys").map
  
  -- Primary toggle (most common use case)
  map("n", "<leader>ti", toggle_indent_size, "Toggle indent size (2⟷4)")
  
  -- Additional indentation controls
  map("n", "<leader>tt", toggle_tab_mode, "Toggle tabs/spaces")
  map("n", "<leader>tr", reset_to_language_default, "Reset to language default")
  map("n", "<leader>tI", show_indent_info, "Show indent info")
  
  -- Quick set commands
  map("n", "<leader>t2", function() set_indent(2, false) end, "Set 2 spaces")
  map("n", "<leader>t4", function() set_indent(4, false) end, "Set 4 spaces")
  map("n", "<leader>t8", function() set_indent(8, false) end, "Set 8 spaces")
  map("n", "<leader>tT", function() set_indent(4, true) end, "Set 4-wide tabs")
end

-- Setup function
function M.setup()
  setup_language_indentation()
  setup_commands()
  setup_keymaps()
end

-- Export functions for external use
M.toggle_indent_size = toggle_indent_size
M.toggle_tab_mode = toggle_tab_mode
M.set_indent = set_indent
M.reset_to_language_default = reset_to_language_default
M.show_indent_info = show_indent_info

return M
