local opts = { noremap = true, silent = false }
local term_opts = { silent = true }
local map = vim.keymap.set

map('', '<Space>', '<Nop>', opts)
vim.g.mapleader = " "

-- Terminal
map('t', '<esc><esc>', '<C-\\><C-n>', { silent = true})

-- Disable pgup and pgdown, because i always accidentally press them...
vim.keymap.set({ "n", "i", "v" }, "<PageUp>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<PageDown>", "<Nop>")

-- VASP
local vasp = require('config.vasp')
map('n', '<leader>v', function() vasp.run_exe('vasp64.exe') end, { desc = 'Run VASP executable' })
map('n', '<f1>', function() vasp.run_exe('vasp64.exe') end, { desc = 'Run VASP executable' })
map('n', '<leader>a', function() vasp.run_exe('amp64.exe') end, { desc = 'Run AMP executable' })
map('n', '<f2>', function() vasp.run_exe('amp64.exe') end, { desc = 'Run AMP executable' })
map('n', '<leader>u', function() vasp.run_exe('uc64.exe') end, { desc = 'Run UC executable' })

map('n', '<C-h>', '<cmd>bp<CR>', { desc = 'Previous Buffer' })
map('n', '<C-l>', '<cmd>bn<CR>', { desc = 'Next Buffer' })
map('n', '<leader>d', '<cmd>bd<CR>', { desc = 'Delete Buffer' })

-- Emacs style navigation in insert mode
map('i', '<C-f>', '<Right>', { desc = 'Move forward' })
map('i', '<C-b>', '<Left>', { desc = 'Move backward' })

-- Switch background
vim.keymap.set("n", "<leader>r", function()
    if vim.o.background == "light" then
        vim.o.background = "dark"
    else
        vim.o.background = "light"
    end
end, {
    desc = "Toggle light/dark theme",
})

-- Oil
map('n', '<leader>e', '<cmd>Oil<CR>', { desc = 'Oil' })

-- nvim-tree
map('n', '<leader>t', '<cmd>NvimTreeToggle<CR>', { desc = 'NvimTreeToggle' })
map('n', '<leader>q', '<cmd>NvimTreeFocus<CR>', { desc = 'NvimTreeFocus' })


-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep in cwd' })
map('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>o', builtin.oldfiles, { desc = 'Telescope previously open files' })
map('n', '<leader>b', builtin.buffers, { desc = 'Telescope list open buffers' })
map('n', '<leader>i', builtin.grep_string, { desc = 'Telescope grep string under cursor in cwd' })
map('n', '<leader>m', builtin.man_pages, { desc = 'Telescope search man pages' })
map('n', '<leader>s', builtin.current_buffer_fuzzy_find, { desc = 'Telescope live fuzzy find in current buffer' })
map('n', '<leader>p', builtin.builtin, { desc = 'Telescope lists builtin pickers' })
map('n', '<leader>k', builtin.keymaps, { desc = 'Telescope lists normal mode keymappings' })
map('n', '<leader>c', builtin.git_bcommits, { desc = 'Telescope lists git commits and checks them out on <cr>' })

