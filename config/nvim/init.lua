-- Neovim Configuration
-- Docs: https://neovim.io/doc/user/
-- Lua guide: https://neovim.io/doc/user/lua-guide.html

-- ── Leader ────────────────────────────────────────────────────────
-- https://neovim.io/doc/user/map.html#mapleader
vim.g.mapleader = " "               -- Space as leader key (used as prefix for custom keymaps)
vim.g.maplocalleader = " "          -- Local leader for filetype-specific mappings

-- ── Options ──────────────────────────────────────────────────────
-- https://neovim.io/doc/user/options.html
local opt = vim.opt

-- Line numbers
opt.number = true                   -- Show absolute line number on current line
opt.relativenumber = true           -- Show relative numbers on other lines (faster j/k navigation)

-- Indentation
-- https://neovim.io/doc/user/options.html#'tabstop'
opt.tabstop = 2                     -- Number of spaces a <Tab> counts for
opt.shiftwidth = 2                  -- Number of spaces for each auto-indent step
opt.expandtab = true                -- Convert tabs to spaces
opt.smartindent = true              -- Auto-indent new lines based on syntax
opt.breakindent = true              -- Wrapped lines preserve indentation level

-- Search
-- https://neovim.io/doc/user/options.html#'ignorecase'
opt.ignorecase = true               -- Case-insensitive search by default
opt.smartcase = true                -- Case-sensitive if query contains uppercase
opt.hlsearch = false                -- Don't keep matches highlighted after search
opt.incsearch = true                -- Show matches as you type the search pattern

-- UI
-- https://neovim.io/doc/user/options.html#'termguicolors'
opt.termguicolors = true            -- Enable 24-bit RGB colors (required by most color schemes)
opt.signcolumn = "yes"              -- Always show sign column (prevents layout shift from diagnostics)
opt.scrolloff = 8                   -- Keep 8 lines visible above/below cursor when scrolling
opt.sidescrolloff = 8               -- Keep 8 columns visible left/right when scrolling horizontally
opt.cursorline = true               -- Highlight the line the cursor is on
opt.wrap = false                    -- Don't wrap long lines (scroll horizontally instead)
opt.showmode = false                -- Don't show "-- INSERT --" in cmdline (statusline plugins handle this)
opt.colorcolumn = "120"             -- Show a vertical guide at column 120 (line length reference)
opt.pumheight = 10                  -- Max items shown in completion popup menu
opt.completeopt = { "menuone", "noselect" }  -- Show menu even for one match, don't auto-select

-- System clipboard
-- https://neovim.io/doc/user/options.html#'clipboard'
opt.clipboard = "unnamedplus"       -- Use system clipboard for all yank/put operations

-- Performance
opt.updatetime = 250                -- Trigger CursorHold event after 250ms idle (default: 4000ms)
opt.timeoutlen = 300                -- Time to wait for mapped key sequence (ms)
opt.lazyredraw = true               -- Don't redraw screen during macros (improves performance)

-- Splits
-- https://neovim.io/doc/user/options.html#'splitright'
opt.splitright = true               -- Open vertical splits to the right
opt.splitbelow = true               -- Open horizontal splits below

-- Files
-- https://neovim.io/doc/user/options.html#'undofile'
opt.undofile = true                 -- Persist undo history to disk (survives restart)
opt.swapfile = false                -- Disable swap files (git handles recovery)
opt.backup = false                  -- Disable backup files

-- Whitespace display
-- https://neovim.io/doc/user/options.html#'listchars'
opt.list = true                     -- Show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }  -- Symbols for tab, trailing space, non-breaking space

-- Minimal UI
opt.shortmess:append("cCI")        -- c: suppress completion messages, C: suppress scanning messages, I: skip intro
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }  -- Clean fold/empty line chars

-- ── Keymaps ──────────────────────────────────────────────────────
-- https://neovim.io/doc/user/lua-guide.html#lua-guide-mappings
local map = vim.keymap.set

-- Better movement: use gj/gk on wrapped lines (move visually), normal j/k with count
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation: Ctrl+hjkl to move between splits (instead of Ctrl-w + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resize: Ctrl+Arrow to resize splits
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Buffer navigation: Shift+H/L to cycle buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Move lines in visual mode: select lines then press J/K to move them
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

-- Better indenting: stay in visual mode after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search highlight with Escape
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Centered scrolling: keep cursor in the middle of screen when jumping
map("n", "<C-d>", "<C-d>zz")       -- Half-page down + center
map("n", "<C-u>", "<C-u>zz")       -- Half-page up + center
map("n", "n", "nzzzv")             -- Next search result + center + unfold
map("n", "N", "Nzzzv")             -- Previous search result + center + unfold

-- Don't lose register on paste: delete to black hole register before pasting
map("x", "p", '"_dP')

-- Quick save/quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Diagnostic navigation
-- https://neovim.io/doc/user/diagnostic.html
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- ── Autocommands ─────────────────────────────────────────────────
-- https://neovim.io/doc/user/autocmd.html
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Briefly highlight yanked text for visual feedback
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace before saving any file
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Restore cursor to last edit position when opening a file
autocmd("BufReadPost", {
  group = augroup("last_position", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalize split sizes when terminal window is resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Use 4-space indentation for languages that conventionally prefer it
autocmd("FileType", {
  group = augroup("indent_settings", { clear = true }),
  pattern = { "go", "python", "rust" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ── Diagnostics ──────────────────────────────────────────────────
-- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },  -- Show inline diagnostic with dot prefix
  signs = true,                     -- Show signs in the sign column
  underline = true,                 -- Underline the diagnostic text
  update_in_insert = false,         -- Don't update diagnostics while typing (less distracting)
  severity_sort = true,             -- Sort by severity (errors first)
  float = { border = "rounded", source = true },  -- Floating window with rounded border and source name
})
