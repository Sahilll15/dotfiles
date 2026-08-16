-- Inside VS Code, LazyVim's plugins fight VS Code's own LSP, finder and UI. Load a slim config there.
if vim.g.vscode then
  require("config.vscode")
else
  require("config.lazy")
end
