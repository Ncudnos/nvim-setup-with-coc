set number
set autochdir
set undofile
set ruler
set cursorline
syntax on
filetype plugin indent on
set bs=2
set smartindent
set wildmenu
set relativenumber
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set encoding=UTF-8
set wrap
set mouse=a
set title
set nobackup
set nowb
set nowrap
set ignorecase
set noswapfile
set splitbelow
set splitright
set laststatus=2
set background=dark

""ctags
command! MakeTags !ctags -R .

call plug#begin()
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'ervandew/supertab' 
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/plenary.nvim' 
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } 
Plug 'nvim-lualine/lualine.nvim' 
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'kdheepak/tabline.nvim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lifepillar/vim-solarized8'
" coc-markdown-preview-enhanced
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'rderik/vim-markdown-toc', { 'branch': 'add-anchors-to-headings/drc2r' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

nnoremap <C-s> :w<Enter>
nnoremap <C-a> ggVG
vnoremap <C-c> :'<.'>%y+<Enter>
nnoremap <C-q> :bdelete!<Enter>
nnoremap <C-w> :q!<Enter>
nnoremap <C-z> :u<Enter>
nnoremap <C-d> :%d<Enter>
nnoremap <C-n> :Telescope file_browser<Enter>
nnoremap <C-t> :ToggleTerm direction=float<Enter>
nnoremap <TAB> :bnext<Enter>
nnoremap <C-f> :%s//g<Left><Left>
nnoremap <C-y> :noh<Enter>
nnoremap <silent> vim :e $MYVIMRC<TAB><cr>
nnoremap <silent> ;; :Telescope oldfiles<cr>

vnoremap <silent> J :m '>+1<cr>gv=gv
vnoremap <silent> K :m '<-2<cr>gv=gv

" Find files using Telescope command-line sugar.
nnoremap <silent>;f <cmd>Telescope find_files<cr>
nnoremap <silent>;g <cmd>Telescope live_grep<cr>
nnoremap <silent>;h <cmd>Telescope help_tags<cr>
nnoremap <silent>sf <cmd>Telescope file_browser<cr>


let g:coc_global_extensions = [
\ 'coc-clangd',
\ 'coc-java',
\ 'coc-python',
\ 'coc-html',
\ 'coc-eslint',
\ 'coc-css',
            \ ]


            "" Map Ctrl + Space để show list functions/biến autocomplete
inoremap <silent><expr> <c-space> coc#refresh()

"" Tự động import file của biến/function khi chọn và nhấn Tab
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<TAB>"

"" Go to definition ở tab mới
nmap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')



if exists("&termguicolors") && exists("&winblend")
    syntax enable
    set termguicolors
    set winblend=10
    set wildoptions=pum
    set pumblend=15
    let g:solarized_termtrans=1
    set background=dark
    colorscheme solarized8
endif

lua << EOF
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
    extensions = {
        file_browser = {
            previewer=false,
            theme = "dropdown",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                },
                ["n"] = {
                },
            },
        },
    },
}
require("telescope").load_extension "file_browser"
EOF

lua << EOF
require'tabline'.setup {
    enable = true,
    options = {
        section_separators = {'', ''},
        component_separators = {'', ''},
        max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
        show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
        show_devicons = true, -- this shows devicons in buffer section
        show_bufnr = false, -- this appends [bufnr] to buffer section,
        show_filename_only = true, -- shows base filename only instead of relative path in filename
        modified_icon = "[*]", -- change the default modified icon
        modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
        show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
    }
    }
requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
EOF

lua<<EOF
require("toggleterm").setup{
}
EOF

lua<<EOF
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'solarized_dark',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
        },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff',},
        lualine_c = { {
            'filename',
        } },
        lualine_x = {
            { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
            hint = ' ' } },
            'encoding',
            'filetype',
            'fileformat',
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

EOF

lua << EOF
require 'Comment'.setup{}
EOF

lua << EOF
require 'colorizer'.setup{
      '*'; -- Highlight all files, but customize some others.
}
EOF

lua<<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust", "cpp", "html", "css", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },
  highlight = {
    enable = true,

    disable = { "c", "rust" },
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    additional_vim_regex_highlighting = false,
  },
}
EOF
