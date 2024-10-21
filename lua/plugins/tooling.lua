local function capa()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.tbl_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
  capabilities.dynamicRegistration = false
  capabilities.lineFoldingOnly = true
  return { capabilities = capabilities }
end

return {
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      local f = nls.builtins.formatting
      local d = nls.builtins.diagnostics
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      return {
        sources = {
          d.codespell,
          d.selene,
          f.black,
          f.clang_format,
          f.gleam_format,
          f.just,
          f.prettierd,
          f.rustywind,
          f.stylua,
          nls.builtins.hover.dictionary,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "astro",
        "eslint",
        "htmx",
        "tsserver",
        "lua_ls",
        "markdown_oxide",
        "pyright",
        "taplo",
        "zls",
        "wgsl_analyzer",
        "svelte",
      },
      automatic_installation = true,
      handlers = {
        function(sv)
          require("lspconfig")[sv].setup(capa())
        end,
        ["rust_analyzer"] = function() end,
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", {
              buffer = bufnr,
              desc = "Rust Runnables",
            })
            vim.keymap.set({ "n", "v" }, "<leader>J", "<cmd>RustLsp joinLines<cr>", {
              buffer = bufnr,
              desc = "Join Lines",
            })
            vim.keymap.set("n", "<leader>r<up>", "<cmd>RustLsp moveItem up<cr>", {
              buffer = bufnr,
              desc = "Move Item Up",
            })
            vim.keymap.set("n", "<leader>r<down>", "<cmd>RustLsp moveItem down<cr>", {
              buffer = bufnr,
              desc = "Move Item Down",
            })
            vim.keymap.set("n", "<leader>re", "<cmd>RustLsp explainError<cr>", {
              buffer = bufnr,
              desc = "Explain Error",
            })
            vim.keymap.set("n", "<leader>a", "<cmd>RustLsp codeAction<cr>", {
              buffer = bufnr,
              desc = "Code Action",
            })
            vim.keymap.set("n", "<leader>R", function()
              local action_map = {
                openDocs = "Open Docs",
                openCargo = "Open Cargo.toml",
                parentModule = "Open Parent Module",
                renderDiagnostic = "Open Diagnostics",
                flyCheck = "Run Cargo Check",
                syntaxTree = "Open Syntax Tree",
                expandMacro = "Expand Macro",
                testables = "Run Tests",
              }
              vim.ui.select(vim.tbl_keys(action_map), {
                prompt = "Rust Menu",
                format_item = function(item)
                  return action_map[item]
                end,
              }, function(selection)
                vim.cmd.RustLsp(selection)
              end)
            end)
          end,
        },
      }
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
