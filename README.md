# 🚀 Neovim Configuration - A Complete Development Environment

<div align="center">

![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

_A modern, feature-rich Neovim configuration designed for productivity and aesthetics_

</div>

## 🌟 Overview

This Neovim configuration provides a comprehensive development environment with modern features, AI-powered assistance, and custom integrations. Built with **Lua** and managed by **Lazy.nvim**, it offers a fast, extensible, and beautiful coding experience.

### ✨ Key Features

- 🎨 **Custom Cyberpunk 2077 Theme** - Visually striking custom colorscheme
- 🤖 **AI Integration** - Multiple AI assistants (Avante, ChatGPT, CodeCompanion, Codeium)
- 🔍 **Advanced Search** - Telescope with fuzzy finding and live grep
- 📝 **Smart Completion** - Intelligent autocompletion with LSP support
- 🌳 **Syntax Highlighting** - Treesitter-powered syntax highlighting
- 🚀 **Custom LeetCode Integration** - Built-in LeetCode problem solver
- 📁 **File Management** - Neo-tree and Mini-files for efficient navigation
- 🎯 **Project Templates** - Quick project scaffolding
- 📊 **Dashboard** - Beautiful startup screen with quick actions

## 📋 Prerequisites

Before installation, ensure you have the following dependencies installed:

### Required Dependencies

- **Neovim** (>= 0.9.0) - The extensible text editor
- **Git** - Version control system
- **Ripgrep** - Ultra-fast text search tool
- **Node.js** - JavaScript runtime for LSP servers
- **Python** - For Python LSP and tools
- **Make** - Build system for native extensions

### Optional Dependencies

- **Lazygit** - Terminal UI for Git commands
- **tmux** - Terminal multiplexer (for session management)
- **Nerd Font** - For proper icon display
- **fd** - Alternative to find command
- **fzf** - Command-line fuzzy finder

## 🛠️ Installation

### Quick Install

```bash
# Backup existing configuration
mv ~/.config/nvim ~/.config/nvim.backup

# Clone the repository
git clone https://github.com/holdmypotion/nvim ~/.config/nvim

# Install Neovim
# For macOS:
brew install neovim

# For Ubuntu/Debian:
sudo apt-get install neovim

# Install dependencies
# For macOS:
brew install ripgrep fd lazygit make node

# For Ubuntu/Debian:
sudo apt-get install ripgrep fd-find lazygit make nodejs npm
```

### System-Specific Installation

#### macOS

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all dependencies
brew install neovim ripgrep fd lazygit make node python3
```

#### Ubuntu/Debian

```bash
# Update package list
sudo apt-get update

# Install dependencies
sudo apt-get install neovim ripgrep fd-find lazygit make nodejs npm python3 python3-pip

# Install additional LSP servers
sudo npm install -g @fsouza/prettierd
pip3 install black pylsp-rope
```

#### Arch Linux

```bash
# Install dependencies
sudo pacman -S neovim ripgrep fd lazygit make nodejs npm python python-pip

# Install AUR packages (using yay)
yay -S prettierd
```

## 🎨 Configuration Structure

```
nvim/
├── init.lua                  # Entry point
├── lua/
│   ├── core/                # Core Neovim configurations
│   │   ├── autocmds.lua     # Auto-commands
│   │   ├── indentation.lua  # Language-specific indentation
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Plugin manager setup
│   │   ├── options.lua      # Neovim options
│   │   └── runcode.lua      # Code execution
│   ├── custom/              # Custom integrations
│   │   ├── cyberpunk.lua    # Custom theme
│   │   ├── leetcode/        # LeetCode integration
│   │   └── templates.lua    # Project templates
│   ├── helpers/             # Helper utilities
│   │   ├── buffers.lua      # Buffer management
│   │   ├── colorscheme.lua  # Theme helpers
│   │   └── keys.lua         # Key mapping helpers
│   └── plugins/             # Plugin configurations
│       ├── lsp.lua          # Language Server Protocol
│       ├── telescope.lua    # Fuzzy finder
│       ├── treesitter.lua   # Syntax highlighting
│       ├── cmp.lua          # Completion
│       └── ... (30+ plugins)
├── spell/                   # Custom spell check dictionary
└── lazy-lock.json          # Plugin version lock
```

## 🔧 Plugin Ecosystem

### 🧠 AI & Assistance

- **[Avante](https://github.com/yetone/avante.nvim)** - AI-powered code assistant
- **[ChatGPT](https://github.com/jackmort/chatgpt.nvim)** - OpenAI ChatGPT integration
- **[CodeCompanion](https://github.com/olimorris/codecompanion.nvim)** - AI coding companion
- **[Codeium](https://github.com/Exafunction/codeium.vim)** - Free AI code completion

### 🔍 Search & Navigation

- **[Telescope](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder with live grep
- **[Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)** - Modern file explorer
- **[Mini.files](https://github.com/echasnovski/mini.files)** - Minimal file manager
- **[Trouble](https://github.com/folke/trouble.nvim)** - Diagnostics and references

### 📝 Language Support

- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configurations
- **[Mason](https://github.com/williamboman/mason.nvim)** - LSP server manager
- **[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Syntax highlighting
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Completion engine
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine

### 🎨 UI & Aesthetics

- **[Alpha](https://github.com/goolord/alpha-nvim)** - Customizable dashboard
- **[Lualine](https://github.com/nvim-lualine/lualine.nvim)** - Status line
- **[Noice](https://github.com/folke/noice.nvim)** - Enhanced UI messages
- **[Notify](https://github.com/rcarriga/nvim-notify)** - Notification system
- **Custom Cyberpunk Theme** - Original Cyberpunk 2077 inspired colorscheme

### 🛠️ Development Tools

- **[Git Integration](https://github.com/lewis6991/gitsigns.nvim)** - Git signs and blame
- **[Lazygit](https://github.com/kdheepak/lazygit.nvim)** - Terminal Git UI
- **[Toggleterm](https://github.com/akinsho/toggleterm.nvim)** - Terminal management
- **[Obsidian](https://github.com/epwalsh/obsidian.nvim)** - Note-taking integration
- **[Zen Mode](https://github.com/folke/zen-mode.nvim)** - Distraction-free coding

## ⌨️ Key Bindings

### Leader Key

**Space** (` `) is the leader key

### General Navigation

| Key           | Action            | Description          |
| ------------- | ----------------- | -------------------- |
| `<leader>fw`  | `:w`              | Write file           |
| `<leader>fa`  | `:wa`             | Write all files      |
| `<leader>qq`  | `:q`              | Quit                 |
| `<leader>qa`  | `:qa!`            | Quit all             |
| `<C-h/j/k/l>` | Window navigation | Move between windows |
| `<S-h/l>`     | Buffer navigation | Previous/next buffer |

### File Management

| Key          | Action               | Description     |
| ------------ | -------------------- | --------------- |
| `<leader>e`  | Neo-tree toggle      | File explorer   |
| `<leader>ff` | Telescope find_files | Find files      |
| `<leader>fg` | Telescope live_grep  | Search in files |
| `<leader>fb` | Telescope buffers    | Find buffers    |
| `<leader>fr` | Telescope oldfiles   | Recent files    |

### AI & Code Assistance

| Key          | Action         | Description          |
| ------------ | -------------- | -------------------- |
| `<leader>at` | Avante toggle  | AI code assistant    |
| `<leader>ac` | Avante chat    | AI chat              |
| `<leader>am` | Avante prompt  | Custom AI prompt     |
| `<Tab>`      | Codeium accept | Accept AI suggestion |

### LeetCode Integration

| Key           | Action          | Description       |
| ------------- | --------------- | ----------------- |
| `<leader>lcl` | LeetCode login  | Login to LeetCode |
| `<leader>lcs` | LeetCode search | Search problems   |
| `<leader>lcd` | LeetCode daily  | Daily problem     |
| `<leader>lct` | LeetCode test   | Run tests         |
| `<leader>lcu` | LeetCode submit | Submit solution   |

### LSP & Diagnostics

| Key          | Action              | Description        |
| ------------ | ------------------- | ------------------ |
| `gd`         | LSP goto definition | Go to definition   |
| `gr`         | LSP references      | Show references    |
| `K`          | LSP hover           | Show documentation |
| `<leader>ca` | LSP code action     | Code actions       |
| `<leader>rn` | LSP rename          | Rename symbol      |
| `gx`         | Diagnostic float    | Show diagnostics   |

### Tmux Integration

| Key           | Action           | Description      |
| ------------- | ---------------- | ---------------- |
| `<C-f>`       | Tmux sessionizer | New tmux session |
| `<M-h/t/n/s>` | Tmux sessions    | Switch sessions  |

## 🎯 Language Support

### Supported Languages

- **Python** - Full LSP support with pylsp
- **Lua** - Native Neovim support with lua_ls
- **JavaScript/TypeScript** - Complete web development setup
- **Go** - Full Go development environment
- **Rust** - Rust analyzer integration
- **Ruby** - Ruby LSP support
- **C/C++** - Clangd integration
- **Java** - Java development tools
- **Markdown** - Enhanced markdown editing

### LSP Servers (Auto-installed)

- `lua_ls` - Lua language server
- `pylsp` - Python LSP server
- `gopls` - Go language server
- `rust_analyzer` - Rust language server
- `ruby_lsp` - Ruby language server
- `clangd` - C/C++ language server
- `tsserver` - TypeScript/JavaScript server

## 🚀 Custom Features

### Cyberpunk 2077 Theme

A custom-built theme inspired by Cyberpunk 2077:

- **Neon colors** - Bright cyan, purple, and yellow highlights
- **Transparent background** - Works with terminal transparency
- **Custom highlights** - Tailored for all UI elements
- **Terminal colors** - Consistent color scheme

### LeetCode Integration

Built-in LeetCode problem solving:

- **Problem search** - Browse and search problems
- **Daily challenges** - Fetch daily problems
- **Company filters** - Filter by company
- **Multi-language** - Support for Python, C++, Java, JavaScript
- **Testing** - Run test cases locally
- **Submission** - Submit solutions directly

### Project Templates

Quick project scaffolding:

- **Language templates** - Pre-configured project structures
- **Best practices** - Following language conventions
- **Dependencies** - Automatic dependency management

### Smart Indentation

Language-specific indentation:

- **Auto-detection** - Detect file type and apply rules
- **Toggle function** - Switch between 2 and 4 spaces
- **Language rules** - Specific rules for each language

## 📚 Usage Examples

### Getting Started

1. **First Launch**: Open Neovim and plugins will auto-install
2. **Dashboard**: Use the Alpha dashboard for quick actions
3. **File Navigation**: Use `<leader>ff` to find files
4. **AI Assistance**: Press `<leader>at` to start AI chat

### LeetCode Workflow

```lua
-- Login to LeetCode
:LeetCodeLogin

-- Search for problems
:LeetCodeSearch

-- Get daily problem
:LeetCodeDaily

-- Run tests
:LeetCodeTest

-- Submit solution
:LeetCodeSubmit
```

### Development Workflow

```lua
-- Open project
:Telescope find_files

-- Navigate with LSP
gd                    -- Go to definition
gr                    -- Show references
K                     -- Show documentation

-- AI assistance
<leader>at            -- Start AI chat
<Tab>                 -- Accept AI suggestion

-- Git operations
<leader>gg            -- Open Lazygit
<leader>gb            -- Git blame
```

## 🔧 Customization

### Changing Theme

```lua
-- In lua/custom/cyberpunk.lua
local colors = {
  bg = "#your_bg_color",
  fg = "#your_fg_color",
  -- ... customize colors
}
```

### Adding Custom Keymaps

```lua
-- In lua/core/keymaps.lua
local map = require("helpers.keys").map

map("n", "<leader>custom", "<cmd>YourCommand<cr>", "Your Description")
```

### Plugin Configuration

```lua
-- In lua/plugins/your-plugin.lua
return {
  "plugin/name",
  config = function()
    -- Your configuration
  end,
}
```

## 🐛 Troubleshooting

### Common Issues

#### LSP Not Working

```bash
# Check LSP status
:LspInfo

# Install missing servers
:Mason
```

#### Telescope Not Finding Files

```bash
# Install ripgrep
brew install ripgrep  # macOS
sudo apt install ripgrep  # Ubuntu
```

#### Theme Not Loading

```bash
# Check if theme is loading
:lua print(vim.g.colors_name)

# Reload theme
:lua require("custom.cyberpunk").setup()
```

#### Performance Issues

```lua
-- Disable heavy plugins temporarily
vim.g.loaded_plugin_name = 1
```

### Log Files

- **Neovim logs**: `~/.cache/nvim/log`
- **LSP logs**: `:LspLog`
- **Plugin logs**: `~/.local/share/nvim/lazy/`

## 📖 Documentation

### Plugin Documentation

- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Telescope](https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md) - Fuzzy finder
- [LSP Config](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) - LSP servers
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter#readme) - Syntax highlighting

### Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Plugin Development](https://neovim.io/doc/user/lua-guide.html#lua-guide-plugin)

## 🤝 Contributing

### Bug Reports

1. Check existing [issues](https://github.com/holdmypotion/nvim/issues)
2. Create detailed bug report with:
   - System information
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs

### Feature Requests

1. Open a feature request issue
2. Describe the feature in detail
3. Explain use cases and benefits
4. Suggest implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/nvim.git

# Create development branch
git checkout -b feature/your-feature

# Make changes and test
nvim --clean -u minimal_init.lua

# Commit and push
git commit -m "feat: your feature description"
git push origin feature/your-feature
```

## 🙏 Acknowledgments

- [Neovim Team](https://neovim.io/) - For the amazing editor
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - For the plugin manager
- [All Plugin Authors](https://github.com/holdmypotion/nvim/blob/master/lazy-lock.json) - For their incredible work
- [Cyberpunk 2077](https://www.cyberpunk.net/) - For the visual inspiration

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For questions, suggestions, or support:

- 📧 Email: [holdmypotion@gmail.com](mailto:holdmypotion@gmail.com)
- 🐛 Issues: [GitHub Issues](https://github.com/holdmypotion/nvim/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/holdmypotion/nvim/discussions)

---

<div align="center">

**Made with ❤️ for the Neovim community**

_Happy coding! 🚀_

</div>
