local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }, _config or {})
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  -- стандартные горячие клавиши для LSP, больше в документации
  -- https://github.com/neovim/nvim-lspconfig
  map('n', 'gD', vim.lsp.buf.declaration, bufopts)
  map('n', 'gd', vim.lsp.buf.definition, bufopts)
  map('n', 'K', vim.lsp.buf.hover, bufopts)
  map('n', 'gi', vim.lsp.buf.implementation, bufopts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  map('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  map('n', 'gr', vim.lsp.buf.references, bufopts)
  map('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end


lspconfig["gopls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      directoryFilters = { "-.git", "-node_modules" },
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        fieldalignment = true,
        nilness = true,
        useany = true,
      },
      codelenses = {
        generate = true,
        run_govulncheck = true,
        tidy = true,
        upgrade_dependency = true,
      },
      hints = {
        constantValues = true
      },
      staticcheck = true,
      gofumpt = true,
      semanticTokens = true,
    },
  },
})
