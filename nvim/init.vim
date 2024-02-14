set number
set autochdir
set undofile
set signcolumn=yes
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
set mouse=a
set title
set ignorecase
set nobackup
set nowb
set noswapfile
set splitbelow
set splitright
set laststatus=2
set background=dark
set nobackup
set nowritebackup
set updatetime=300

""ctags
command! MakeTags !ctags -R .

call plug#begin()

Plug 'ervandew/supertab' 
Plug 'nvim-lua/plenary.nvim' 
Plug 'nvim-telescope/telescope.nvim' 
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons'

Plug 'iamcco/markdown-preview.nvim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'norcalli/nvim-colorizer.lua'

Plug 'tjdevries/colorbuddy.nvim'
Plug 'svrana/neosolarized.nvim'
Plug 'kdheepak/tabline.nvim'

call plug#end()

nnoremap <C-s> :w<Enter>
nnoremap <C-a> ggVG
vnoremap <C-c> :'<.'>%y+<Enter>
nnoremap <C-q> :bdelete!<Enter>
nnoremap <C-w> :q!<Enter>
nnoremap <C-z> :u<Enter>
nnoremap <C-d> :%d<Enter>
nnoremap <C-n> :Telescope file_browser<Enter>
nnoremap <TAB> :bnext<Enter>
nnoremap <C-f> :%s//g<Left><Left>
nnoremap <C-y> :noh<Enter>
nnoremap <silent> vim :e $MYVIMRC<TAB><cr>
nnoremap <silent> ;; :Telescope oldfiles<cr>

" Find files using Telescope command-line sugar.
nnoremap <silent>;g <cmd>Telescope live_grep<cr>
nnoremap <silent>;h <cmd>Telescope help_tags<cr>

if exists("&termguicolors") && exists("&winblend")
    syntax enable
    set termguicolors
    set winblend=10
    set wildoptions=pum
    set pumblend=20
    set background=dark
endif

lua << EOF

local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}

telescope.load_extension("file_browser")


vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)

vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
EOF

lua << EOF
require 'Comment'.setup{}
EOF

lua<<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "cpp", "html", "css", "python" },
  sync_install = false,
  auto_install = true,
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
    additional_vim_regex_highlighting = true,
  },
}
EOF

lua << EOF
require'colorizer'.setup()
EOF

lua << EOF

local status, n = pcall(require, "neosolarized")
if (not status) then return end

n.setup({
  comment_italics = true,
})

local cb = require('colorbuddy.init')
local Color = cb.Color
local colors = cb.colors
local Group = cb.Group
local groups = cb.groups
local styles = cb.styles

Color.new('white', '#ffffff')
Color.new('black', '#000000')
Group.new('Normal', colors.base1, colors.NONE, styles.NONE)
Group.new('CursorLine', colors.none, colors.base03, styles.NONE, colors.base1)
Group.new('CursorLineNr', colors.yellow, colors.black, styles.NONE, colors.base1)
Group.new('Visual', colors.none, colors.base03, styles.reverse)

local cError = groups.Error.fg
local cInfo = groups.Information.fg
local cWarn = groups.Warning.fg
local cHint = groups.Hint.fg

Group.new("DiagnosticVirtualTextError", cError, cError:dark():dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextInfo", cInfo, cInfo:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextWarn", cWarn, cWarn:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextHint", cHint, cHint:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticUnderlineError", colors.none, colors.none, styles.undercurl, cError)
Group.new("DiagnosticUnderlineWarn", colors.none, colors.none, styles.undercurl, cWarn)
Group.new("DiagnosticUnderlineInfo", colors.none, colors.none, styles.undercurl, cInfo)
Group.new("DiagnosticUnderlineHint", colors.none, colors.none, styles.undercurl, cHint)

Group.new("HoverBorder", colors.yellow, colors.none, styles.NONE)

EOF

lua << EOF

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
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
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
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


require'tabline'.setup {
      -- Defaults configuration options
      enable = true,
      options = {
      -- If lualine is installed tabline will use separators configured in lualine by default.
      -- These options can be used to override those settings.
        section_separators = {'', ''},
        component_separators = {'', ''},
        max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
        show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
        show_devicons = true, -- this shows devicons in buffer section
        show_bufnr = false, -- this appends [bufnr] to buffer section,
        show_filename_only = false, -- shows base filename only instead of relative path in filename
        modified_icon = "+ ", -- change the default modified icon
        modified_italic = false, -- set to true by default; this determines whether the filename turns italic if modified
        show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
      }
    }
EOF

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <silent>rn <Plug>(coc-rename)

" Formatting selected code
xmap <silent>f  <Plug>(coc-format-selected)
nmap <silent>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <silent>a  <Plug>(coc-codeaction-selected)
nmap <silent>a  <Plug>(coc-codeaction-selected)

nmap <silent>ac  <Plug>(coc-codeaction-cursor)
nmap <silent>qf  <Plug>(coc-fix-current)
nmap <silent>cl  <Plug>(coc-codelens-action)

