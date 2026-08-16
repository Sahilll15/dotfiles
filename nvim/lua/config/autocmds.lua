-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Live-reload buffers when files change on disk (e.g. Claude Code editing the
-- repo in the pane next door). autoread + a 1s checktime timer means open
-- files refresh and gitsigns gutter marks update without any keypress.
vim.o.autoread = true
vim.fn.timer_start(1000, function()
  if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
    vim.cmd("silent! checktime")
  end
end, { ["repeat"] = -1 })
