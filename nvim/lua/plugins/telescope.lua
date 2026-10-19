return {
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },


        opts = {
            pickers = {
                buffers = {
                    previewer = false,
                },
                oldfiles = {
                    previewer = false,
                },
            },

            defaults = {
                mappings = {
                    i = {
                        ["<C-@>"] = function(...)
                            require("telescope.actions.layout").toggle_preview(...)
                        end,
                    },
                    n = {
                        ["<C-@>"] = function(...)
                            require("telescope.actions.layout").toggle_preview(...)
                        end,
                    },
                },

                preview = { treesitter = true },
                color_devicons = true,
                sorting_strategy = "ascending",
                borderchars = {
                    "", -- top
                    "", -- right
                    "", -- bottom
                    "", -- left
                    "", -- top-left
                    "", -- top-right
                    "", -- bottom-right
                    "", -- bottom-left
                },

                path_displays = { "smart" },
                layout_config = {
                    height = 100,
                    width = 400,
                    prompt_position = "bottom",
                    preview_cutoff = 60,
                    preview_width = 0.50,
                },

                file_ignore_patterns = {
                    "%.exe",
                    "%.dll",

                    "%.wav",
                    "%.WAV",
                    "%.mp3",
                    "%.MP3",
                    "%.flac",
                    "%.FLAC",

                    "%.MOV",
                    "%.mov",
                    "%.mkv",
                    "%.mp4",
                    "%.MP4",
                    "%.webm",

                    "%.JPG",
                    "%.jpeg",
                    "%.jpg",
                    "%.DNG",
                    "%.PNG",
                    "%.png",
                    "%photo-edit",

                    "%.tar",
                    "%.rar",

                    "%.pdf",

                    "%.DS_Store",
                    "Thumbs.db",
                },
            },
            extensions = {
                ["ui-select"] = {
                },
            },

        },

        keys = {
            {
                "<leader>g",
                "<cmd>Telescope live_grep<cr>",
                desc = "Live grep",
            },
            {
                "<leader>o",
                "<cmd>Telescope oldfiles<cr>",
                desc = "Telescope oldfiles",
            },
            {
                "<leader>f",
                "<cmd>Telescope find_files<cr>",
                desc = "Telescope find files",
            },
            {
                "<leader>b",
                "<cmd>Telescope buffers<cr>",
                desc = "Telescope list buffers",
            },
        },
    },
}
