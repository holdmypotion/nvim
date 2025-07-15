-- Cyberpunk 2077 Neovim Theme
local M = {}

-- Color Palette
local colors = {
  bg = "#101116",
  fg = "#00d4b1",
  dark_bg = "#0c0c11",
  bright_fg = "#00ffd5",
  comment = "#6766b3",
  selection = "#311b92",  -- Removed alpha
  string = "#76c1ff",
  number = "#fffc58",
  keyword = "#d57bff",
  func = "#00b0ff",
  operator = "#00b0ff",
  type = "#00FF9C",
  variable = "#b4baff",
  error = "#FF5370",
  warning = "#e5ff00",    -- Removed alpha
  info = "#00a589",
  hint = "#cc00ff",
  line_nr = "#b2d101",
  line_nr_active = "#d9ff00",
  git_add = "#00ff40",
  git_change = "#3700ff",
  git_delete = "#6200ff",
  border = "#00d4b1",
  visual = "#311b92",     -- Removed alpha
  cursor_line = "#1f1d4d", -- Removed alpha, adjusted for visibility
  special = "#ff5680",
}

function M.setup()
  local hi = vim.api.nvim_set_hl
  local config = {
    -- Editor
    -- Normal = { fg = colors.fg, bg = colors.bg },
    -- NormalFloat = { fg = colors.fg, bg = colors.dark_bg },
    Normal = { fg = colors.fg, bg = "NONE" },
    NormalFloat = { fg = colors.fg, bg = "NONE" },
    Cursor = { fg = colors.bg, bg = colors.fg },
    CursorLine = { bg = colors.cursor_line },
    CursorLineNr = { fg = colors.line_nr_active },
    LineNr = { fg = colors.line_nr },
    -- SignColumn = { bg = colors.bg },
    SignColumn = { bg = "NONE" },
    VertSplit = { fg = colors.border },
    ColorColumn = { bg = colors.dark_bg },

    -- Syntax
    Comment = { fg = colors.comment, italic = true },
    String = { fg = colors.string },
    Number = { fg = colors.number },
    Float = { fg = colors.number },
    Boolean = { fg = colors.number },
    Function = { fg = colors.func },
    Keyword = { fg = colors.keyword },
    Operator = { fg = colors.operator },
    Type = { fg = colors.type },
    Identifier = { fg = colors.variable },
    Special = { fg = colors.special },
    Statement = { fg = colors.keyword },
    PreProc = { fg = colors.keyword },
    Include = { fg = colors.keyword },
    Define = { fg = colors.keyword },
    Constant = { fg = colors.number },

    -- Visual
    Visual = { bg = colors.visual },
    Search = { bg = colors.selection, fg = colors.bright_fg },
    IncSearch = { bg = colors.selection, fg = colors.bright_fg },
    MatchParen = { bg = colors.selection },

    -- Diagnostics
    DiagnosticError = { fg = colors.error },
    DiagnosticWarn = { fg = colors.warning },
    DiagnosticInfo = { fg = colors.info },
    DiagnosticHint = { fg = colors.hint },

    -- Git
    DiffAdd = { fg = colors.git_add },
    DiffChange = { fg = colors.git_change },
    DiffDelete = { fg = colors.git_delete },

    -- Pmenu (completion)
    Pmenu = { fg = colors.fg, bg = colors.dark_bg },
    PmenuSel = { fg = colors.bright_fg, bg = colors.selection },
    PmenuSbar = { bg = colors.dark_bg },
    PmenuThumb = { bg = colors.border },

    -- Status line
    StatusLine = { fg = colors.fg, bg = colors.dark_bg },
    StatusLineNC = { fg = colors.comment, bg = colors.dark_bg },

    -- Tabline
    TabLine = { fg = colors.comment, bg = colors.dark_bg },
    TabLineFill = { bg = colors.dark_bg },
    TabLineSel = { fg = colors.bright_fg, bg = colors.bg },

    -- Terminal colors
    TermCursor = { fg = colors.bg, bg = colors.bright_fg },
    TermCursorNC = { fg = colors.bg, bg = colors.comment },
    -- TermCursor = { fg = colors.fg },
    -- TermCursorNC = { fg = colors.comment },
  }

  -- Set all highlights
  for group, settings in pairs(config) do
    hi(0, group, settings)
  end

  -- Set terminal colors
  vim.g.terminal_color_0 = "#10d4b0"
  vim.g.terminal_color_1 = "#940303"
  vim.g.terminal_color_2 = "#0059ff"
  vim.g.terminal_color_4 = "#004cf1"
  vim.g.terminal_color_5 = "#94058a"
  vim.g.terminal_color_6 = "#029790"
  vim.g.terminal_color_7 = "#311b92"
  vim.g.terminal_color_8 = "#02adf1"
  vim.g.terminal_color_9 = "#be0000"
  vim.g.terminal_color_10 = "#00ff9c"
  vim.g.terminal_color_11 = "#d0f30c"
  vim.g.terminal_color_12 = "#00a2ff"
  vim.g.terminal_color_13 = "#e215d6"
  vim.g.terminal_color_14 = "#08e1d7"
  vim.g.terminal_color_15 = "#2eb8f8"
end

return M
