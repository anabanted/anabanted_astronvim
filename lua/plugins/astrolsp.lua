-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
          "lua",
          "typescript",
          "javascript",
          "typescriptreact",
          "javascriptreact",
          "json",
          "yaml",
          "markdown",
          "html",
          "css",
          "python",
          "rust",
          "c",
          "cpp",
          "haskell",
          "go",
          "purescript",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      lua_ls = {
        settings = {
          Lua = {
            hint = { enable = true },
          },
        },
      },
      tsserver = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifierPreference = "non-relative",
            },
            inlayHints = {
              variableTypes = {
                enabled = true,
              },
            },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              loadOutDirsFromCheck = true,
            },
            checkOnSave = true,
            check = {
              command = "clippy",
              extraArgs = {
                "--",
                "-D",
                "clippy::unwrap_used",
              },
            },
            procMacro = {
              enable = true,
            },
            inlayHints = {
              typeHints = {
                chainingHints = true,
                parameterHints = true,
                maxLength = 120,
              },
            },
          },
        },
      },
      -- pylyzer = {
      --   settings = {
      --     python = {
      --       diagnostic = true,
      --       hint = true,
      --     },
      --   },
      -- },

      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "strict",
              reportIncompatibleMethodOverride = true,
            },
            hint = {
              enabled = true,
            },
          },
        },
      },
      -- pylsp = {
      --   settings = {
      --     plusgins = {
      --       pylsp_mypy = {
      --
      --         enabled = true,
      --         live_mode = false,
      --         strict = true,
      --         dmypy = true,
      --       },
      --       pyflakes = { enabled = false },
      --       pycodestyle = { enabled = false },
      --
      --       jedi_completion = {
      --         fuzzy = true,
      --         include_params = true,
      --         include_class_objects = true,
      --       },
      --       jedi_hover = {
      --         enabled = true,
      --         include_class_objects = true,
      --       },
      --       jedi_signature_help = {
      --         enabled = true,
      --         include_class_objects = true,
      --       },
      --       jedi_signature = {
      --         enabled = true,
      --         include_return_annotation = true,
      --       },
      --       jedi_symbols = {
      --         enabled = true,
      --         all_scopes = true,
      --         include_imports = true,
      --       },
      --     },
      --   },
      -- },
      -- ruff_lsp = {
      --   init_options = {
      --     settings = {},
      --   },
      -- },

      purescriptls = {
        settings = {
          purescript = {
            addSpagoSources = true,
            formatter = "purs-tidy",
            formatOnImportSort = true,
            formatOnImportFormat = true,
            diagnostic = {
              virtual_text = true,
            },
            hint = {
              enabled = true,
            },
          },
        },
      },
    },
    -- customize language server configuration passed to `vim.lsp.config`
    -- client specific configuration can also go in `lsp/` in your configuration root (see `:h lsp-config`)
    config = {
      -- ["*"] = { capabilities = {} }, -- modify default LSP client settings such as capabilities
    },
    -- customize how language servers are attached
    handlers = {
      -- a function with the key `*` modifies the default handler, functions takes the server name as the parameter
      -- ["*"] = function(server) vim.lsp.enable(server) end

      -- the key is the server that is being setup with `vim.lsp.config`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        K = { function() vim.lsp.buf.hover() end, desc = "Hover" },
        gd = { function() vim.lsp.buf.definition() end, desc = "Go to definition" },
        gr = { function() vim.lsp.buf.references() end, desc = "Go to references" },
        ga = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lsp-attach`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
