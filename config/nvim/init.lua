-- Neovim minimal config
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.cursorline = true

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Faster update time
vim.opt.updatetime = 250

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
