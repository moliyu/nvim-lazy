return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vue",
        "scss",
        "nix",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local util = require("lspconfig.util")
      local configs = require("lspconfig.configs")
      configs.uno = {
        default_config = {
          cmd = { "unocss-lsp", "--stdio" },
          -- cmd = { "node", "--inspect", "/Users/doudou/work/unocss/packages/lsp-unocss/out/index.js", "--stdio" },
          filetypes = {
            "html",
            "javascriptreact",
            "rescript",
            "typescriptreact",
            "vue",
            "svelte",
          },
          root_dir = function(fname)
            return util.root_pattern("unocss.config.js", "unocss.config.ts", "uno.config.js", "uno.config.ts")(fname)
          end,
        },
      }
      require("lspconfig").uno.setup({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "windwp/nvim-autopairs",
      opts = {},
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      })
    end,
  },
}
