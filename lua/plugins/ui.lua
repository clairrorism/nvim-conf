local hex2color = function(color)
  local rv = {
    red = 0,
    green = 0,
    blue = 0,
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
    config = function()
      local heirline = require("heirline")
      local hlc = require("heirline-components.all")

      hlc.init.subscribe_to_events()
      heirline.load_colors(hlc.hl.get_colors())
      heirline.setup({
        statuscolumn = {
          hlc.component.foldcolumn(),
          hlc.component.numbercolumn(),
          hlc.component.signcolumn(),
        },
      })
      vim.opt.foldcolumn = "1"
    end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 1.0,
        width = function()
          if vim.bo.filetype == "markdown" or vim.bo.filetype == "typst" then
            return 70
          else
            return 110
          end
        end,
        height = 0.9,
      },
      plugins = {
        twilight = { enabled = false },
      },
    },
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
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
        { "<leader>fg", tsb.live_grep, desc = "List grep results" },
        { "<leader>fb", tsb.buffers, desc = "List buffers" },
        { "<leader>fo", tsb.oldfiles, desc = "List old files" },
        { "<leader>fj", tsb.jumplist, desc = "List jumplist entries" },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
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
      transparent_background = true,
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
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  { "RRethy/vim-illuminate" },
  { "HiPhish/rainbow-delimiters.nvim" },
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
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      { "<leader>ug", "<cmd>Neogit<cr>", desc = "Open FS tree" },
    },
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
    config = true,
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
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = false,
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "sschleemilch/slimline.nvim",
    opts = {
      style = "fg",
    },
  },
}
