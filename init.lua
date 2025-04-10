-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,euc-jp,cp932"

vim.api.nvim_set_keymap("i", "<C-c>", 'copilot#Accept("<TAB>")', { expr = true, silent = true, noremap = true })

require("lspconfig").ruby_lsp.setup {
  cmd = { "ruby-lsp" },
  filetypes = { "ruby", "eruby" },
  root_dir = (require "lspconfig.util").root_pattern("Gemfile", ".git"),
  init_options = {
    formatter = "auto",
  },
  single_file_support = true,
}

local map = vim.keymap.set
local neotest = require "neotest"

-- テスト実行関連
map("n", "<leader>rt", function() neotest.run.run() end, { desc = "Run nearest test" })
map("n", "<leader>rf", function() neotest.run.run(vim.fn.expand "%") end, { desc = "Run file tests" })
map("n", "<leader>rl", function() neotest.run.run_last() end, { desc = "Run last test" })
map("n", "<leader>rs", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
map("n", "<leader>ro", function() neotest.output.open { enter = true } end, { desc = "Open test output" })
map("n", "<leader>rd", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
