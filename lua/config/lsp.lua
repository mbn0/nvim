        local lsp_zero = require('lsp-zero')
        local cmp = require('cmp')
        local lspconfig = require('lspconfig')

        -- Mason setup and ensuring servers are installed
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'omnisharp', 'cssls', 'html', 'ts_ls', 'clangd', 'pyright', 
                'lua_ls', 'lemminx', 'dockerls', 'yamlls'
            },
        })

        -- Basic capabilities and on_attach function
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_attach = function(client, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
        end

        -- Set up handlers for LSP servers
        require('mason-lspconfig').setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = lsp_attach,
                })
            end,
        })

        -- Specific setup for Angular Language Server
        lspconfig.angularls.setup({
            capabilities = capabilities,
            on_attach = lsp_attach,
            filetypes = { 'typescript', 'typescriptreact', 'html' },
            settings = {
                angular = {
                    experimental = { templateInterpolationService = true },
                },
            },
        })

        -- Configure nvim-cmp with snippet support
        cmp.setup({
            sources = { { name = 'nvim_lsp' } },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- Using LuaSnip for snippet expansion
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<Enter>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
        })

