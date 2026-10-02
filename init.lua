vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.packadd("matchit")

require("config")
require("lib.pack").setup(require("plugins"))
