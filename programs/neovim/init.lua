-- sets the <Leader> "key", which can be used in shortcuts
vim.g.mapleader = ' '

vim.g.have_nerd_font = true

-- [[ vim options, see `:help vim.opt` ]]
-- line numbers
vim.opt.number = true

-- enable mouse
vim.opt.mouse = 'a'

-- save undo history
vim.opt.undofile = true

-- case insensitive search, unless the terms contains uppercase or '\C'
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- save swapfile 250ms after nothing is done
vim.opt.updatetime = 250

-- timeout mapped sequences after 300ms
vim.opt.timeoutlen = 300

-- configure where splits open
vim.opt.splitright = true
vim.opt.splitbelow = true

-- show whitespace characters clearly (see :help 'list')
vim.opt.list = true

-- preview substitutions (:s & :%s) while typing
vim.opt.inccommand = 'split'

-- highlight the line the cursor is on
vim.opt.cursorline = true

-- sync os clipboard and neovim
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)


-- [[ shortcuts, see `:help vim.keymap.set()` ]]
-- hide search results when pressing esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


-- [[ plugin configuration ]]
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
})

vim.cmd.colorscheme("catppuccin-macchiato")

require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
	extensions = { "trouble" },
})
