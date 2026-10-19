return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",

        opts = {
            delay = function(ctx)
                return ctx.plugin and 0 or 300
            end,
            icons = { mappings = true },
            preset = "helix",
        },
    },
}
