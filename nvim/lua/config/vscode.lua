-- Neovim config used ONLY inside VS Code (vim.g.vscode is set by asvetliakov.vscode-neovim).
-- No plugins, no LSP, no statusline — VS Code already provides all of that.
-- Terminal Neovim still loads the full LazyVim setup; this file does not touch it.

local opt = vim.opt
local map = vim.keymap.set

-- ── options ────────────────────────────────────────────────────────────────
opt.clipboard = "unnamedplus" -- y and p use the system clipboard
opt.ignorecase = true
opt.smartcase = true -- a capital letter in the search makes it case-sensitive
opt.timeoutlen = 300 -- how long a mapping like jj waits for its second key
opt.scrolloff = 8

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ── the one you asked for ──────────────────────────────────────────────────
map("i", "jj", "<Esc>", { desc = "exit insert mode" })
map("i", "jk", "<Esc>", { desc = "exit insert mode" })

-- ── VS Code command bridge ─────────────────────────────────────────────────
-- Calls a VS Code command from Neovim. Falls back silently outside VS Code.
local function vsc(command)
  return function()
    local ok, vscode = pcall(require, "vscode")
    if ok then
      vscode.action(command)
    end
  end
end

-- ── navigation: let VS Code do it, it is better at it here ─────────────────
map({ "n", "v" }, "gd", vsc("editor.action.revealDefinition"), { desc = "go to definition" })
map({ "n", "v" }, "gD", vsc("editor.action.revealDeclaration"), { desc = "go to declaration" })
map({ "n", "v" }, "gr", vsc("editor.action.goToReferences"), { desc = "references" })
map({ "n", "v" }, "gI", vsc("editor.action.goToImplementation"), { desc = "implementation" })
map("n", "K", vsc("editor.action.showHover"), { desc = "hover docs" })
map("n", "[d", vsc("editor.action.marker.prev"), { desc = "prev problem" })
map("n", "]d", vsc("editor.action.marker.next"), { desc = "next problem" })

-- ── editing ────────────────────────────────────────────────────────────────
map({ "n", "v" }, "gcc", vsc("editor.action.commentLine"), { desc = "toggle comment" })
map("v", "gc", vsc("editor.action.commentLine"), { desc = "toggle comment" })
map("n", "<leader>rn", vsc("editor.action.rename"), { desc = "rename symbol" })
map("n", "<leader>ca", vsc("editor.action.quickFix"), { desc = "code action" })
map("n", "<leader>cf", vsc("editor.action.formatDocument"), { desc = "format file" })

-- ── files and search ───────────────────────────────────────────────────────
map("n", "<leader><leader>", vsc("workbench.action.quickOpen"), { desc = "find file" })
map("n", "<leader>ff", vsc("workbench.action.quickOpen"), { desc = "find file" })
map("n", "<leader>fg", vsc("workbench.action.findInFiles"), { desc = "grep in files" })
map("n", "<leader>e", vsc("workbench.view.explorer"), { desc = "explorer" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "save" })
map("n", "<leader>q", vsc("workbench.action.closeActiveEditor"), { desc = "close editor" })
map("n", "<leader>p", vsc("workbench.action.showCommands"), { desc = "command palette" })

-- ── splits and terminal ────────────────────────────────────────────────────
map("n", "<leader>sv", vsc("workbench.action.splitEditorRight"), { desc = "split right" })
map("n", "<leader>sh", vsc("workbench.action.splitEditorDown"), { desc = "split down" })
map("n", "<leader>t", vsc("workbench.action.terminal.toggleTerminal"), { desc = "toggle terminal" })

-- ── quality of life ────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "clear search highlight" })
map("v", "<", "<gv", { desc = "outdent and keep selection" })
map("v", ">", ">gv", { desc = "indent and keep selection" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })
map("n", "<C-d>", "<C-d>zz", { desc = "half page down, centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up, centred" })
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- Paste over a selection without losing the yanked text.
map("v", "p", '"_dP')
