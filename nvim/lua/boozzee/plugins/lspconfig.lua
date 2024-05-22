
-- Инициализация плагинов
local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Настройка способностей LSP для cmp
local function config(_config)
  return vim.tbl_deep_extend('force', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  }, _config or {})
end

-- Функция для установки ключевых привязок
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

cmp.setup({
    snippet = {
        expand = function(args)
            -- Пустая функция, так как вы не используете сниппеты
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Подтверждение автодополнения на Enter
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- Функция для настройки lsp
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', bufopts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', bufopts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', bufopts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', bufopts)
    buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', bufopts)
    buf_set_keymap('n', '<leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', bufopts)
    buf_set_keymap('n', '<leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', bufopts)
    buf_set_keymap('n', '<leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', bufopts)
    buf_set_keymap('n', '<leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', bufopts)
    buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', bufopts)
    buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', bufopts)
    buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', bufopts)
    buf_set_keymap('n', '<leader>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', bufopts)
end

vim.lsp.set_log_level("debug")

lspconfig.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
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
    handlers = {
        ['window/logMessage'] = function(err, method, params, client_id)
            print(method, vim.inspect(params))
        end,
        ['window/showMessage'] = function(err, method, params, client_id)
            print(method, vim.inspect(params))
        end,
    },
}
