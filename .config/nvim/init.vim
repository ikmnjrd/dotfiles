" Install Plugin
call plug#begin('~/.vim/plugged')
if system('uname') =~ 'Darwin'
  Plug 'ikmnjrd/vim-im-select'
elseif system('uname') =~ 'Linux'
endif

if exists('g:vscode')
else
  Plug 'vim-jp/vimdoc-ja'
  Plug 'junegunn/fzf', {'dir': '~/.fzf_bin', 'do': './install --all'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'lambdalisue/gina.vim'
  Plug 'lambdalisue/fern.vim'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'shaunsingh/nord.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim' " indent-highlight
  Plug 'ellisonleao/glow.nvim'
endif
call plug#end()

" 共通設定
"" set options
set termguicolors
set number
set clipboard=unnamedplus "クリップボードへの登録
set shell=/bin/zsh "コマンド実行にzshを使う
set history=200 "Exコマンド履歴保持数
set incsearch "検索入力時からマッチ
set nrformats=octal,hex,alpha "インクリメント対象にアルファベットを追加
set nocompatible
filetype plugin on
runtime macros/matchit.vim

"" map prefix
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
""" ヤンクに入れないで削除
nnoremap <Leader>d "_d
xnoremap <Leader>d "_d

" vim-im-select
if system('uname') =~ 'Darwin'
  let g:im_select_default = 'com.apple.keylayout.ABC'
elseif system('uname') =~ 'Linux'
  augroup fcitx5_integration
  autocmd!
  autocmd InsertLeave * :call system('fcitx5-remote -c')
  augroup END
endif

" for Mac python provider(:pyx command)
if system('uname') =~ 'Darwin'
  let g:python3_host_prog = expand('~/.local/nvim-venv/bin/python3')
endif


if exists('g:vscode')
  " VSCode extension
else
  " ordinary Neovim
  "" set options
  set autoindent
  set breakindent " 行を折り返すときにインデントを考慮
  set expandtab "タブの入力にスペース
  set nostartofline
  set tabstop=2 "タブに変換されるサイズ
  set shiftwidth=2
  set smartindent

  "" disable languages surpport
  let g:loaded_ruby_provider = 0
  let g:loaded_perl_provider = 0

  "" if you use volta(node version manager)
  "" https://github.com/volta-cli/volta/issues/866
  if executable('volta')
    let g:node_host_prog = trim(system("volta which neovim-node-host"))
  endif

  "" coc.nvim
  let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-eslint8',
    \ 'coc-prettier',
    \ 'coc-git',
    \ 'coc-fzf-preview',
    \ 'coc-lists',
    \ 'coc-snippets',
    \ 'coc-prisma',
    \ 'coc-rust-analyzer',
    \ 'coc-deno',
    \ ]

  augroup coc_ts
    autocmd!
    autocmd FileType typescript,typescriptreact call <SID>coc_typescript_settings()
  augroup END

  function! s:show_documentation() abort
    if index(['vim','help'], &filetype) >= 0
      execute 'h ' . expand('<cword>')
    elseif coc#rpc#ready()
      call CocActionAsync('doHover')
    endif
  endfunction

  "" fern
  nnoremap <silent> <Leader>e :<C-u>Fern . -drawer<CR>
  nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -reveal=%<CR>
  let g:fern#default_hidden=1 "show dotfiles

  " Example config in Vim-Script
  let g:nord_contrast = v:true
  let g:nord_borders = v:false
  let g:nord_disable_background = v:true
  let g:nord_italic = v:false
  let g:nord_uniform_diff_background = v:true

  " Load the colorscheme
  colorscheme nord
endif

lua <<EOF
if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  -- treesitter
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      "typescript",
      "tsx",
      "prisma",
      "rust"
    },
    highlight = {
      enable = true,
    },
  }
  -- for Todo.txt
  local function change_priority()
    ---- Vim の input() 関数をLuaから呼び出して、対話的に入力を受け取る
    local oldPri = vim.fn.input('Old Priority (e.g. A): ')
    local newPri = vim.fn.input('New Priority (e.g. B): ')

    ---- A～Z の一文字だけかどうかチェック
    if string.match(oldPri, '^[A-Z]$') and string.match(newPri, '^[A-Z]$') then
      ---- ここでグローバルコマンドを使い、「- [x]」を含む行は除外して置換を実行
      ---- 例えば "(A)" を "(B)" に置き換える
      local cmd = string.format("g!/- \\[x\\]/ s/(%s)/(%s)/g", oldPri, newPri)
      vim.cmd(cmd)

      print(
        string.format("Replaced priority from (%s) to (%s) (excluding lines that have - [x])", oldPri, newPri)
      )
    else
      print("Invalid priority input!")
    end
  end
  ---- Luaでユーザーコマンドを作成
  vim.api.nvim_create_user_command(
    'ChangePriority',
    function()
      change_priority()
    end,
    {}
  )

  -- indent_blankline
  vim.opt.list = true
  vim.opt.listchars:append "space:⋅"
  vim.opt.listchars:append "eol:↴"
  require("ibl").setup {}

end
EOF

