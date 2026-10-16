-- Cyberpunk 2077 Neovim Theme
local M = {}

-- Color Palette
local colors = {
  bg = "#101116",
  fg = "#00d4b1",
  dark_bg = "#0c0c11",
  bright_fg = "#00ffd5",
  comment = "#7a7ab8",
  selection = "#311b92",  -- Removed alpha
  string = "#76c1ff",
  string_escape = "#ff9e64",
  number = "#fffc58",
  boolean = "#ff5680",
  constant = "#ff9e64",
  keyword = "#d57bff",
  keyword_ctrl = "#ff6ac1",
  func = "#00b0ff",
  method = "#38c8ff",
  builtin = "#ff5680",
  operator = "#00ffd5",
  type = "#00FF9C",
  type_builtin = "#50fa7b",
  module = "#ffd166",
  variable = "#b4baff",
  parameter = "#ffb86c",
  property = "#7df9ff",
  punctuation = "#89ddff",
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
    Normal = { fg = colors.fg, bg = "NONE" },
    NormalFloat = { fg = colors.fg, bg = "NONE" },
    Cursor = { fg = colors.bg, bg = colors.fg },
    CursorLine = { bg = colors.cursor_line },
    CursorLineNr = { fg = colors.line_nr_active, bold = true },
    LineNr = { fg = colors.line_nr },
    SignColumn = { bg = "NONE" },
    VertSplit = { fg = colors.border },
    WinSeparator = { fg = colors.border },
    ColorColumn = { bg = colors.dark_bg },

    -- Standard Vim Syntax
    Comment = { fg = colors.comment, italic = true },
    String = { fg = colors.string },
    Character = { fg = colors.string },
    Number = { fg = colors.number },
    Float = { fg = colors.number },
    Boolean = { fg = colors.boolean, bold = true },
    Constant = { fg = colors.constant },
    Identifier = { fg = colors.variable },
    Function = { fg = colors.func, bold = true },
    Statement = { fg = colors.keyword },
    Conditional = { fg = colors.keyword_ctrl, bold = true },
    Repeat = { fg = colors.keyword_ctrl, bold = true },
    Label = { fg = colors.property },
    Operator = { fg = colors.operator },
    Keyword = { fg = colors.keyword },
    Exception = { fg = colors.error, bold = true },
    PreProc = { fg = colors.keyword },
    Include = { fg = colors.keyword_ctrl },
    Define = { fg = colors.keyword },
    Macro = { fg = colors.special },
    PreCondit = { fg = colors.keyword },
    Type = { fg = colors.type },
    StorageClass = { fg = colors.keyword },
    Structure = { fg = colors.type, bold = true },
    Typedef = { fg = colors.type },
    Special = { fg = colors.special },
    SpecialChar = { fg = colors.string_escape },
    Tag = { fg = colors.func },
    Delimiter = { fg = colors.punctuation },
    SpecialComment = { fg = colors.comment, bold = true },
    Todo = { fg = colors.bg, bg = colors.warning, bold = true },
    Title = { fg = colors.bright_fg, bold = true },

    -- Treesitter Highlight Groups (Neovim 0.10+ / nvim-treesitter)
    ["@variable"] = { fg = colors.variable },
    ["@variable.builtin"] = { fg = colors.builtin, italic = true },
    ["@variable.parameter"] = { fg = colors.parameter },
    ["@variable.parameter.builtin"] = { fg = colors.builtin, italic = true },
    ["@variable.member"] = { fg = colors.property },

    ["@property"] = { fg = colors.property },
    ["@field"] = { fg = colors.property },

    ["@constant"] = { fg = colors.constant },
    ["@constant.builtin"] = { fg = colors.boolean, bold = true },
    ["@constant.macro"] = { fg = colors.special, bold = true },

    ["@module"] = { fg = colors.module, bold = true },
    ["@module.builtin"] = { fg = colors.module, italic = true },
    ["@namespace"] = { fg = colors.module, bold = true },
    ["@label"] = { fg = colors.property },

    ["@string"] = { fg = colors.string },
    ["@string.documentation"] = { fg = colors.string, italic = true },
    ["@string.regexp"] = { fg = colors.string_escape },
    ["@string.escape"] = { fg = colors.string_escape, bold = true },
    ["@string.special"] = { fg = colors.string_escape },
    ["@string.special.symbol"] = { fg = colors.constant },
    ["@string.special.url"] = { fg = colors.bright_fg, underline = true },
    ["@character"] = { fg = colors.string },
    ["@character.special"] = { fg = colors.string_escape },

    ["@boolean"] = { fg = colors.boolean, bold = true },
    ["@number"] = { fg = colors.number },
    ["@number.float"] = { fg = colors.number },

    ["@type"] = { fg = colors.type },
    ["@type.builtin"] = { fg = colors.type_builtin, italic = true },
    ["@type.definition"] = { fg = colors.type, bold = true },
    ["@type.qualifier"] = { fg = colors.keyword },

    ["@attribute"] = { fg = colors.special },
    ["@attribute.builtin"] = { fg = colors.special, italic = true },

    ["@function"] = { fg = colors.func, bold = true },
    ["@function.builtin"] = { fg = colors.builtin, bold = true },
    ["@function.call"] = { fg = colors.func },
    ["@function.macro"] = { fg = colors.special, bold = true },
    ["@function.method"] = { fg = colors.method, bold = true },
    ["@function.method.call"] = { fg = colors.method },
    ["@method"] = { fg = colors.method, bold = true },
    ["@method.call"] = { fg = colors.method },
    ["@constructor"] = { fg = colors.type, bold = true },

    ["@operator"] = { fg = colors.operator },

    ["@keyword"] = { fg = colors.keyword },
    ["@keyword.coroutine"] = { fg = colors.keyword_ctrl, bold = true },
    ["@keyword.function"] = { fg = colors.keyword, bold = true },
    ["@keyword.operator"] = { fg = colors.keyword_ctrl },
    ["@keyword.import"] = { fg = colors.keyword_ctrl },
    ["@keyword.type"] = { fg = colors.keyword, bold = true },
    ["@keyword.modifier"] = { fg = colors.keyword },
    ["@keyword.repeat"] = { fg = colors.keyword_ctrl, bold = true },
    ["@keyword.return"] = { fg = colors.keyword_ctrl, bold = true },
    ["@keyword.debug"] = { fg = colors.special },
    ["@keyword.exception"] = { fg = colors.error, bold = true },
    ["@keyword.conditional"] = { fg = colors.keyword_ctrl, bold = true },
    ["@keyword.conditional.ternary"] = { fg = colors.operator },
    ["@keyword.directive"] = { fg = colors.special, italic = true },
    ["@keyword.directive.define"] = { fg = colors.special, bold = true },

    ["@punctuation.delimiter"] = { fg = colors.punctuation },
    ["@punctuation.bracket"] = { fg = colors.punctuation },
    ["@punctuation.special"] = { fg = colors.special },

    ["@comment"] = { fg = colors.comment, italic = true },
    ["@comment.documentation"] = { fg = colors.comment, italic = true },
    ["@comment.error"] = { fg = colors.bg, bg = colors.error, bold = true },
    ["@comment.warning"] = { fg = colors.bg, bg = colors.warning, bold = true },
    ["@comment.todo"] = { fg = colors.bg, bg = colors.warning, bold = true },
    ["@comment.note"] = { fg = colors.bg, bg = colors.info, bold = true },

    ["@tag"] = { fg = colors.keyword },
    ["@tag.builtin"] = { fg = colors.special },
    ["@tag.attribute"] = { fg = colors.property },
    ["@tag.delimiter"] = { fg = colors.punctuation },

    ["@markup.heading"] = { fg = colors.bright_fg, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.link"] = { fg = colors.func, underline = true },
    ["@markup.link.url"] = { fg = colors.string, underline = true },
    ["@markup.raw"] = { fg = colors.number },
    ["@markup.list"] = { fg = colors.special },

    -- LSP Semantic Token Groups
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.regexp"] = { link = "@string.regexp" },
    ["@lsp.type.string"] = { link = "@string" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { fg = colors.parameter, italic = true },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.typemod.variable.readonly"] = { link = "@constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },

    -- Visual
    Visual = { bg = colors.visual },
    Search = { bg = colors.selection, fg = colors.bright_fg },
    IncSearch = { bg = colors.selection, fg = colors.bright_fg },
    MatchParen = { bg = colors.selection, fg = colors.bright_fg, bold = true },

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
  }

  -- Set all highlights
  for group, settings in pairs(config) do
    hi(0, group, settings)
  end

  vim.g.terminal_color_4 = "#004cf1"
end

return M
