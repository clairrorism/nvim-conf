local hex2color = function(color)
  local rv = {
    red = 0,
    green = 0,
    blue = 0
  }
  local offset = 1
  if not (math.fmod(#color, 2) == 0) then
    offset = offset + 1
  end
  rv.red = tonumber(string.sub(color, offset, offset + 1), 16)
  rv.green = tonumber(string.sub(color, offset + 2, offset + 3), 16)
  rv.blue = tonumber(string.sub(color, offset + 4, offset + 5), 16)

  return rv
end

local blend = function(color1, color2, amount)
  local c1 = hex2color(color1)
  local c2 = hex2color(color2)

  local newcolor = {
    red = c1.red - ((c1.red - c2.red) * amount),
    green = c1.green - ((c1.green - c2.green) * amount),
    blue = c1.blue - ((c1.blue - c2.blue) * amount),
  }

  return string.format("#%02X%02X%02X", newcolor.red, newcolor.green, newcolor.blue)
end

return {
  {
    "rebelot/heirline.nvim",
    dependencies = { "Zeioth/heirline-components.nvim" },
    opts = {},
    config = function()
      local heirline = require("heirline")
      local hlc = require("heirline-components.all")

      hlc.init.subscribe_to_events()
      heirline.load_colors(hlc.hl.get_colors())
      heirline.setup({
        statusline = {
          hl = { fg = "fg", bg = "bg" },
          hlc.component.mode({ mode_text = { pad_text = "center" } }),
          hlc.component.git_branch(),
          hlc.component.file_info(),
          hlc.component.git_diff(),
          hlc.component.diagnostics(),
          hlc.component.fill(),
          hlc.component.cmd_info(),
          hlc.component.fill(),
          hlc.component.lsp(),
          hlc.component.compiler_state(),
          hlc.component.nav(),
        },
      })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 0.9,
        width = function()
          if vim.bo.filetype == "markdown" then
            return 70
          else
            return 110
          end
        end,
        height = 0.9,
      },
    },
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local tsb = require("telescope.builtin")

      return {
        { "<leader>ff", tsb.find_files, desc = "List files" },
        { "<leader>fg", tsb.live_grep,  desc = "List grep results" },
        { "<leader>fb", tsb.buffers,    desc = "List buffers" },
        { "<leader>fo", tsb.oldfiles,   desc = "List old files" },
        { "<leader>fj", tsb.jumplist,   desc = "List jumplist entries" },
      }
    end,
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
      { "<leader>uf", "<cmd>Neotree float<cr>", desc = "Open FS tree" },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
        aerial = true,
        leap = true,
        mason = true,
        noice = true,
        lsp_trouble = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        local blendhl = function(color)
          return { fg = blend(colors.text, color, 0.125), bg = blend(colors.base, color, 0.75) }
        end

        return {
          PmenuSel = { bg = colors.surface1, fg = "NONE" },
          Pmenu = { fg = colors.text, bg = colors.surface0 },


          CmpItemAbbrDeprecated = { fg = colors.red, bg = "NONE", strikethrough = true },
          CmpItemAbbrMatch = { fg = colors.sky, bg = "NONE", bold = true },
          CmpItemAbbrMatchFuzzy = { fg = colors.sky, bg = "NONE", bold = true },
          CmpItemMenu = { fg = colors.mauve, bg = "NONE", italic = true },

          CmpItemKindField = blendhl(colors.red),
          CmpItemKindProperty = blendhl(colors.red),
          CmpItemKindEvent = blendhl(colors.red),

          CmpItemKindText = blendhl(colors.green),
          CmpItemKindEnum = blendhl(colors.green),
          CmpItemKindKeyword = blendhl(colors.green),

          CmpItemKindConstant = blendhl(colors.yellow),
          CmpItemKindConstructor = blendhl(colors.yellow),
          CmpItemKindReference = blendhl(colors.yellow),

          CmpItemKindFunction = blendhl(colors.mauve),
          CmpItemKindStruct = blendhl(colors.mauve),
          CmpItemKindClass = blendhl(colors.mauve),
          CmpItemKindModule = blendhl(colors.mauve),
          CmpItemKindOperator = blendhl(colors.mauve),

          CmpItemKindVariable = blendhl(colors.overlay0),
          CmpItemKindFile = blendhl(colors.overlay0),

          CmpItemKindUnit = blendhl(colors.peach),
          CmpItemKindSnippet = blendhl(colors.peach),
          CmpItemKindFolder = blendhl(colors.peach),

          CmpItemKindMethod = blendhl(colors.blue),
          CmpItemKindValue = blendhl(colors.blue),
          CmpItemKindEnumMember = blendhl(colors.blue),

          CmpItemKindInterface = blendhl(colors.teal),
          CmpItemKindColor = blendhl(colors.teal),
          CmpItemKindTypeParameter = blendhl(colors.teal),
        }
      end
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd [[colorscheme catppuccin]]
    end
  },
  { "RRethy/vim-illuminate" },
  { "HiPhish/rainbow-delimiters.nvim" },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    after = "catppuccin",
    config = function()
      require("bufferline").setup({
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
        options = {
          numbers = "buffer_id",
          always_show_bufferline = false,
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  -- TODO: neogit
  {
    "stevearc/overseer.nvim",
    opts = {},
    keys = {
      { "<leader>ur", "<cmd>OverseerRun<cr>",    desc = "Task runner" },
      { "<leader>ut", "<cmd>OverseerToggle<cr>", desc = "Task list" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "echasnovski/mini.icons",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("alpha").setup(require("alpha.themes.theta").config)
    end,
  },
  {
    "folke/which-key.nvim",
    config = true
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "stevearc/dressing.nvim",
    opts = {}
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {}
  }
}
