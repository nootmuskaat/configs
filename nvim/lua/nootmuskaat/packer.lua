-- check packer docs to setup before fresh nvim setup
-- followed by `PackerSync` to install packages
return require("packer").startup(
    function()
        use("wbthomason/packer.nvim")

        use("nvim-lua/plenary.nvim")
        use("nvim-telescope/telescope.nvim")

        use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
        use("nvim-treesitter/nvim-treesitter-context")
        -- tree sitter plugins
        use("andymass/vim-matchup")
        -- setup = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
        use("p00f/nvim-ts-rainbow")

        use("neovim/nvim-lspconfig")

        use("numToStr/Comment.nvim")

        -- language specific
        use("simrat39/rust-tools.nvim")
        -- use("rust-lang/rust.vim")  -- was not working
        use("VidocqH/data-viewer.nvim")

        -- auto completion
        use("ms-jpq/coq_nvim", { branch = "coq" })
        use("ms-jpq/coq.artifacts", { branch = "artifacts" })
        --  lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
        --  Need to **configure separately**
        use("ms-jpq/coq.thirdparty", { branch = "3p" })

        -- status line
        -- requires fonts from https://github.com/ryanoasis/nerd-fonts
        -- which must be also set in terminal settings
        use({
          "nvim-lualine/lualine.nvim",
          requires = { "kyazdani42/nvim-web-devicons", opt = true }
        })
        -- color scheme
        use("navarasu/onedark.nvim")

        -- git diff viewer
        use({
            "sindrets/diffview.nvim",
            requires = "nvim-lua/plenary.nvim"
        })

        use("ThePrimeagen/harpoon")
    end
)
