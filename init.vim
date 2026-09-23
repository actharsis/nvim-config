:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set smarttab
:set softtabstop=4

let mapleader = " "

set clipboard+=unnamedplus

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/terryma/vim-multiple-cursors'
Plug 'https://github.com/preservim/tagbar'
Plug 'https://github.com/rafi/awesome-vim-colorschemes'
Plug 'https://github.com/nvim-lua/plenary.nvim'
Plug 'https://github.com/nvim-telescope/telescope.nvim'
Plug 'kdheepak/lazygit.nvim'
Plug 'https://github.com/neovim/nvim-lspconfig'

call plug#end()

colorscheme nord

nnoremap <Leader>n :NERDTree<CR>
nnoremap <Leader>m :NERDTreeToggle<CR>
nnoremap <Leader>t :TagbarOpenAutoClose<CR>
nnoremap <Leader>f :Telescope live_grep<CR>
nnoremap <Leader>g :Telescope find_files<CR>
nnoremap <Leader>l :LazyGit<CR>

lua << EOF

-- You can pass LSP settings to the server:
vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        },
    },
})

-- You can enable different LSP features
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        -- Inlay hints display inferred types, etc.
        if client:supports_method("inlayHint/resolve") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
        -- Completion can be invoked via ctrl+x ctrl+o. It displays a list of
        -- names inferred from the context (e.g. method names, variables, etc.)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { })
        end
		vim.diagnostic.config({ virtual_text = true })
    end,
})

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('pyright')
EOF
