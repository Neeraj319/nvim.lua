local M = {}
function M.setup()
	local lsp = require("lsp-zero")


	lsp.preset("recommended")

	require('mason').setup({})
	require('mason-lspconfig').setup({
		ensure_installed = {
			'tsserver',
			'rust_analyzer',
			'pyright',
			'clangd',
			'yamlls',
		},
		handlers = {
			lsp.default_setup,
			lua_ls = function()
				local lua_opts = lsp.nvim_lua_ls()
				require('lspconfig').lua_ls.setup(lua_opts)
			end,
		},
	})

	local cmp = require('cmp')

	cmp.setup({
		select = { behavior = cmp.SelectBehavior.Select
		},
		mapping = cmp.mapping.preset.insert({
			['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
			['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
			['<C-y>'] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete(),
			['<Tab>'] = nil,
			['<S-Tab>'] = nil
		}),
	})

	lsp.set_preferences({
		suggest_lsp_servers = false,
		sign_icons = {
			error = 'E',
			warn = 'W',
			hint = 'H',
			info = 'I'
		}
	})

	lsp.on_attach(function(client, bufnr)
		local opts = { buffer = bufnr, remap = false }

		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "gv", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "T", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		vim.keymap.set('n', '<space>lr', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<space>la', vim.lsp.buf.code_action, opts)
	end)

	lsp.setup()

	vim.diagnostic.config({
		virtual_text = true
	})
end

return M
