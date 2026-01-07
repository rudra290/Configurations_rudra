return {
    'willothy/veil.nvim',
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "juansalvatore/git-dashboard-nvim",
    },
    config = function()
    local builtin = require("veil.builtin")
    local git_dash = require('git-dashboard-nvim')

    -- 1. Get raw heatmap
    local heatmap_lines = git_dash.setup({
        branch = 'main',
        days = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'},
        empty_square = '□',
        filled_squares = {'■', '■', '■', '■', '■'},
    })

    if type(heatmap_lines) ~= "table" then heatmap_lines = { "" } end

        -- 2. HELPER: Center text & TRIM TOP PADDING
        local function center_and_trim(lines)
        -- Step A: Remove empty lines from top
        while #lines > 0 and (lines[1] == "" or lines[1]:match("^%s*$")) do
            table.remove(lines, 1)
            end

            -- Step B: Center the remaining lines
            local screen_width = vim.o.columns
            local graph_width = 64
            -- Adjusted padding based on your preference (-35 offset)
            local padding_amount = math.floor((screen_width - graph_width - 35) / 2)
            if padding_amount < 0 then padding_amount = 0 end
                local pad = string.rep(" ", padding_amount)

                local centered = {}
                for _, line in ipairs(lines) do
                    table.insert(centered, pad .. line)
                    end
                    return centered
                    end

                    -- 3. Setup Veil
                    require('veil').setup({
                        sections = {
                            -- Header
                            builtin.sections.animated(builtin.headers.frames_nvim, {
                                hl = { fg = "#5de4c7" },
                            }),

                            -- Buttons
                            builtin.sections.buttons({
                                {
                                    icon = "",
                                    text = "New File",
                                    shortcut = "n",
                                    callback = function() vim.cmd("enew") end
                                },
                                {
                                    icon = "",
                                    text = "Find Files",
                                    shortcut = "f",
                                    callback = function() require('telescope.builtin').find_files() end
                                },
                                {
                                    icon = "",
                                    text = "Recent Files",
                                    shortcut = "r",
                                    callback = function() require('telescope.builtin').oldfiles() end
                                },
                            }),

                            -- Heatmap (Trimmed & Centered)
                    builtin.sections.animated({ center_and_trim(heatmap_lines) }, {
                        hl = { fg = "#6c7a96" }
                    }),
                        },
                    })
                    end,
}
