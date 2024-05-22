local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
if not string.find(vim.o.runtimepath, rtp_addition) then
  vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
end

-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
    use ("wbthomason/packer.nvim") -- Have packer manage itself	
  
    use("savq/melange-nvim") -- color scheme

    use("nvim-tree/nvim-tree.lua")
    use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
     requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- набор Lua функций, используется как зависимость в большинстве
    -- плагинов, где есть работа с асинхронщиной
    -- use('nvim-lua/plenary.nvim')
    use('sainnhe/gruvbox-material')

    use("numToStr/Comment.nvim")

    -- autocomplete
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")

    -- lsp
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        requires = {
          { "nvim-treesitter/nvim-treesitter" },
        },
    }) 

    use("antosha417/nvim-lsp-file-operations")
    use("folke/neodev.nvim")

    -- git
    use("lewis6991/gitsigns.nvim")

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
