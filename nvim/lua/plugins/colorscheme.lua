return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,

        opts = {
            options = {
                styles = {
                    comments = "italic",
                    --conditionals = "italic",
                    --keywords = "italic",
                    --functions = "italic",
                    --types = "italic",
                    --variables = "italic",
                },
            },
        },

        config = function(_, opts)
            require("nightfox").setup(opts)
            vim.cmd.colorscheme("nightfox")

            vim.cmd([[
                highlight Normal guibg=none
                highlight NonText guibg=none
                highlight Normal ctermbg=none
                highlight NonText ctermbg=none
            ]])
        end,
    },

    {
        "catppuccin/nvim",
        lazy = true,
    },
}
