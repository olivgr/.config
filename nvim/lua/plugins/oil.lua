-- Show CWD in the winbar
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

local detail = false

return {
    {
        "stevearc/oil.nvim",
        lazy = false,

        opts = {
            -- Toggle file detail view
            keymaps = {
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
            },
            win_options = {
                winbar = "%!v:lua.get_oil_winbar()",
                signcolumn = "auto:2",
            },
            columns = {
                "icon",
                -- "mtime",
            },
            delete_to_trash = true,
        },

     -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    },
}
