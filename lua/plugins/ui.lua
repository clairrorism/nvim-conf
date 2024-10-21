return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    noice = true,
                    lsp_trouble = true,
                    illuminate = {
                        enabled = true,
                        lsp = true,
                    },
                    which_key = true,
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
        priority = 1000,
        lazy = false,
    },
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")
        end,
        keys = function()
            local tsb = require("telescope.builtin")

            return {
                { "<leader>ff", tsb.find_files, desc = "List files" },
                { "<leader>fg", tsb.live_grep,  desc = "Search for string in CWD" },
                {
                    "<leader>fG",
                    function()
                        tsb.live_grep({ grep_open_files = true })
                    end,
                    desc = "Search for string in open buffers",
                },
                { "<leader>fo", tsb.oldfiles,                  desc = "List previously open files" },
                { "<leader>fb", tsb.buffers,                   desc = "List open buffers" },
                { "<leader>fq", tsb.quickfix,                  desc = "List quickfix items" },
                { "<leader>F",  tsb.current_buffer_fuzzy_find, desc = "Fuzzy find in current buffer" },
                { "<leader>j",  tsb.jumplist,                  desc = "List jumplist items" },
            }
        end,
    },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs", -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "query",
                "vim",
                "vimdoc",
                "rust",
            },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby" } },
        },
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        config = function()
            vim.diagnostic.config({ virtual_text = false })
            require("tiny-inline-diagnostic").setup()
        end,
    },
    {
        "folke/trouble.nvim",
        event = "LspAttach",
        config = true,
        keys = {
            { "<leader>ud", "<cmd>Trouble diagnostics toggle<cr>",                desc = "Open diagnostics panel" },
            { "<leader>us", "<cmd>Trouble symbols toggle win.position=right<cr>", desc = "Open document symbol panel" },
            {
                "<leader>uh",
                function()
                    vim.cmd([[Trouble lsp_incoming_calls toggle win.type=split win.position=left]])
                    vim.cmd([[Trouble lsp_outgoing_calls toggle win.type=split win.position=left]])
                end,
                desc = "Open call hierarchy",
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        keys = {
            { "<leader>uf", "<cmd>Neotree filesystem reveal float<cr>", desc = "Open file explorer" },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "ColorScheme",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    globalstatus = true,
                },
            })
        end,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "akinsho/bufferline.nvim",
        event = "ColorScheme",
        config = function()
            require("bufferline").setup({
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
                options = {
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = false,
                },
            })
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
    {
        "folke/noice.nvim",
        -- enabled = false,
        opts = {},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 80,
            },
        },
        keys = {
            { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle zen mode." },
        },
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
    },
    {
        "RRethy/vim-illuminate",
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        init = function()
            vim.o.foldcolumn = "0" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = function()
            local ufo = require("ufo")
            vim.keymap.set("n", "zR", ufo.openAllFolds)
            vim.keymap.set("n", "zM", ufo.closeAllFolds)
            ufo.setup()
        end,
        -- enabled = false,
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "utilyre/barbecue.nvim",
        opts = {
            theme = "catppuccin",
        },
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
        enabled = false,
    },
    {
        "stevearc/aerial.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>uo", "<cmd>AerialNavOpen<cr>", desc = "Open code outline" },
        },
    },
    {
        "ziontee113/icon-picker.nvim",
        config = true,
        keys = {
            { "<leader><leader>i", "<cmd>IconPickerNormal<cr>", desc = "Open icon picker" },
        },
    },
}
