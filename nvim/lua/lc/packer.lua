local function ensure_packer()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }


    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- use('rebelot/kanagawa.nvim')
    use("folke/tokyonight.nvim")

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    --use {
    --    'nvim-tree/nvim-tree.lua',
    --    requires = {
    --        'nvim-tree/nvim-web-devicons', -- optional
    --    },
    --}

    use 'karb94/neoscroll.nvim'

    use 'm4xshen/autoclose.nvim'

    use 'voldikss/vim-floaterm'

    use {
        'simrat39/rust-tools.nvim',
        requires = { { 'neovim/nvim-lspconfig' } }
    }

    use 'lewis6991/gitsigns.nvim'

    use 'ray-x/go.nvim'
    use 'ray-x/guihua.lua'


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    -- if packer_bootstrap then
    --     print('packer syncing from bootstrap')
    --     require("packer").sync()
    -- end

end})
