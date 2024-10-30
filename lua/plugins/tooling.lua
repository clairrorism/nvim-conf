local lspset = function(bind, callback, bufnr, desc)
  vim.keymap.set("n", bind, callback, {
    desc = desc,
    buffer = bufnr,
  })
end

local make_on_attach = function(after)
  return function(_, bufnr)
    local tsb = require("telescope.builtin")
    lspset("gd", tsb.lsp_definitions, bufnr, "Go to definition")
    lspset("gI", tsb.lsp_implementations, bufnr, "Go to implementation")
    lspset("gD", tsb.lsp_type_definitions, bufnr, "Go to type definition")
    lspset("<leader>lr", tsb.lsp_references, bufnr, "List references")
    lspset("<leader>li", tsb.lsp_incoming_calls, bufnr, "List incoming calls")
    lspset("<leader>lo", tsb.lsp_outgoing_calls, bufnr, "List outgoing calls")
    lspset("<leader>lw", tsb.lsp_workspace_symbols, bufnr, "List workspace symbols")
    lspset("<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, bufnr, "Format current buffer.")
    lspset("<leader>lR", vim.lsp.buf.rename, bufnr, "Rename item")
    after(bufnr)
  end
end

local server_settings = function(after)
  return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = make_on_attach(after),
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local servers = {
        "eslint",
        "gleam",
        "glsl_analyzer",
        "kotlin_language_server",
        "gradle_ls",
        "marksman",
        -- "ocamllsp",
        "pyright",
        "sourcekit",
        "taplo",
        "tinymist",
        "ts_ls",
        "lua_ls",
      }
      local settings = server_settings(function(bufnr)
        lspset("<leader>a", vim.lsp.buf.code_action, bufnr, "Code action")
      end)
      for i, sv in pairs(servers) do
        require("lspconfig")[sv].setup(settings)
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = {
        exclude = { "rust_analyzer" },
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    init = function()
      vim.g.rustaceanvim = {
        server = server_settings(function(bufnr)
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
        end),
      }
    end,
  }
}
