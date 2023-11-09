-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
--return {
--  -- add pyright to lspconfig
--  {
--    "neovim/nvim-lspconfig",
--    ---@class PluginLspOpts
--    opts = {
--      ---@type lspconfig.options
--      servers = {
--        -- pyright will be automatically installed with mason and loaded with lspconfig
--        pyright = {
--          python = {
--            venvPath = "$HOME/Documents/code/python/",
--            venv = "venv",
--            pythonPath = "$HOME/.env/bin/python3",
--          },
--        },
--      },
--    },
--  },
--
return {
  {
    "neovim/nvim-lspconfig",
    ft = "python",
    opts = {
      servers = {
        pyright = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          on_attach = function(client, _)
            client.server_capabilities.codeActionProvider = false
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
			  venvPath = "/home/questo/Documents/code/python/",
			  venv = "venv",
              analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
          init_options = {
            settings = {
              args = {},
            },
          },
        },
      },
    },
  },
  {
    "raimon49/requirements.txt.vim",
    event = "BufReadPre requirements*.txt",
  },
}
