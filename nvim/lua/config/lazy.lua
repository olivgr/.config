-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local indent = 4
local options = {
    scrolloff = 3,
    tabstop = indent,
    shiftwidth = indent,
    softtabstop = indent,
    expandtab = true,
    number = true,
    --relativenumber = true,
    showtabline = 1,
    laststatus = 2,
    signcolumn = "number",
    clipboard = "unnamedplus",
    winborder = "rounded",
    splitbelow = true,
    splitright = true,
    signcolumn = "auto:2",
    -- mouse = "nv",
    cursorline = true,
    termguicolors = true,
    spell = false,
    spelllang = { "en,de" },

    swapfile = true,
    directory = vim.fn.stdpath("state") .. "/swap//",
    undofile = true,
    undodir = vim.fn.stdpath("state") .. "/undo//",

}

for k, v in pairs(options) do 
    vim.opt[k] = v
end

vim.g.netrw_list_hide = table.concat({
    '\\.DS_Store$',
    '\\.exe$',
    '\\.dll$',
    '\\.wav$',
    '\\.mp3$',
    '\\.MP3$',
}, ',')

vim.g.netrw_hide = 1

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
--vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- import your plugins
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "tokyonight" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
    rocks = { enabled = false },
})
