-- sets the <Leader> "key", which can be used in shortcuts
vim.g.mapleader = ","

vim.g.have_nerd_font = true

-- [[ vim options, see `:help vim.opt` ]]
-- line numbers
vim.opt.number = true

-- enable mouse
vim.opt.mouse = "a"

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
vim.opt.inccommand = "split"

-- highlight the line the cursor is on
vim.opt.cursorline = true

-- set default tab size
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- disable netrw to avoid conflicts with neotree
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- sync os clipboard and neovim
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- [[ shortcuts, see `:help vim.keymap.set()` ]]
-- hide search results when pressing esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- open neo-tree
vim.keymap.set("n", "<leader>t", "<Cmd>Neotree reveal<CR>")

-- global search
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>rg", telescope.live_grep)

-- lsp keybindings
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float)
vim.keymap.set("n", "<M-CR>", require("actions-preview").code_actions)

-- indent/dedent lines in visual mode
vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<S-tab>", "<gv")

-- show lsp messages inline
vim.diagnostic.config({
	virtual_text = true,
})

-- [[ neovide configuration ]]
if vim.g.neovide then
	vim.o.guifont = "IosevkaTerm Nerd Font:h12"
end

-- [[ plugin configuration ]]
require("catppuccin").setup({
	flavour = "auto",
	background = {
		light = "latte",
		dark = "mocha",
	},
})

-- setup must be called before colorscheme
vim.cmd.colorscheme("catppuccin")

-- tree-sitter, stolen from getchoo
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function(args)
		local ft = args.match or vim.bo[args.buf].filetype
		local language = vim.treesitter.language.get_lang(ft) or ft

		if vim.treesitter.language.add(language) then
			vim.treesitter.start(args.buf, language)
			vim.bo[args.buf].syntax = "ON"
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("lualine").setup({
	options = {
		theme = "catppuccin",
	},
	extensions = { "trouble" },
})

local npairs = require("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
npairs.setup({
	check_ts = true,
})

local cmp = require("cmp")
local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		-- accept completion with enter
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "async_path" },
		{ name = "buffer" },
		{ name = "nvim_lsp" },
	},
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- LSP
local lspformat = require("lsp-format")
lspformat.setup({})

vim.lsp.config("nixd", {
	on_attach = lspformat.on_attach,
	capabilities = cmp_caps,
	settings = {
		["nixd"] = {
			formatting = {
				command = { "nixfmt" },
			},
		},
	},
})
vim.lsp.enable("nixd")

vim.lsp.config("rust_analyzer", {
	on_attach = lspformat.on_attach,
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("zls", { on_attach = lspformat.on_attach })
vim.lsp.enable("zls")

require("gitsigns").setup()

require("fidget").setup()

require("neo-tree").setup({
	close_if_last_window = true,
	window = {
		mappings = {
			["Z"] = "expand_all_nodes",
		},
	},
})
