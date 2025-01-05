" this is how a comment looks like in ~/.vimrc

" https://zenn.dev/yano/articles/vim_frontend_development_2021
" Install Plugin
call plug#begin('~/.vim/plugged')

Plug 'vim-jp/vimdoc-ja'
Plug 'junegunn/fzf', {'dir': '~/.fzf_bin', 'do': './install --all'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/fern.vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'shaunsingh/nord.nvim'
Plug 'lukas-reineke/indent-blankline.nvim' " indent-highlight
Plug 'ellisonleao/glow.nvim'

if system('uname') =~ 'Darwin'
  " macOS 用の設定
  Plug 'ikmnjrd/vim-im-select'
elseif system('uname') =~ 'Linux'
  " Linux 用の設定
endif

call plug#end()

" set options
set termguicolors
set number
set clipboard=unnamedplus "クリップボードへの登録
set shell=/bin/zsh "コマンド実行にzshを使う
set history=200 "Exコマンド履歴保持数
set incsearch "検索入力時からマッチ
set nrformats=octal,hex,alpha "インクリメント対象にアルファベットを追加
"" Indent
set autoindent
set breakindent " 行を折り返すときにインデントを考慮
set expandtab "タブの入力にスペース
set nostartofline
set tabstop=2 "タブに変換されるサイズ
set shiftwidth=2
set smartindent

"" vim-im-select
if system('uname') =~ 'Darwin'
  " macOS 用の設定
  let g:im_select_default = 'com.apple.inputmethod.Kotoeri.RomajiTyping.Roman'
elseif system('uname') =~ 'Linux'
  " Linux 用の設定
  augroup fcitx5_integration
  autocmd!
  autocmd InsertLeave * :call system('fcitx5-remote -c')
  augroup END
endif


" map prefix
let g:mapleader = "\<Space>"
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
nnoremap [dev]    <Nop>
xnoremap [dev]    <Nop>
nmap     m        [dev]
xmap     m        [dev]
nnoremap [ff]     <Nop>
xnoremap [ff]     <Nop>
nmap     z        [ff]
xmap     z        [ff]

"" カーソル位置による表示の調整
""" https://dackdive.hateblo.jp/entry/2014/05/20/183756
nnoremap <silent> [ff]. z.
nnoremap <silent> [ff]z zz
nnoremap <silent> [ff]t zt
nnoremap <silent> [ff]<CR> z<CR>
nnoremap <silent> [ff]b zb
nnoremap <silent> [ff]- z-

if exists('g:vscode')
  " VSCode extension
else
  " ordinary Neovim
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

  inoremap <silent> <expr>  <C-Space> coc#refresh()
  nnoremap <silent> K       :<C-u>call <SID>show_documentation()<CR>
  nmap     <silent> [dev]rn <Plug>(coc-rename)
  nmap     <silent> [dev]a  <Plug>(coc-codeaction-selected)iw
  nmap     <silent> gd      <Plug>(coc-definition)
  nmap     <silent> [dev]f  <Plug>(coc-format)
  nmap     <silent> gi      <Plug>(coc-implementation)

  function! s:coc_typescript_settings() abort
    nnoremap <silent> <buffer> [dev]f :<C-u>CocCommand eslint.executeAutofix<CR>:CocCommand prettier.formatFile<CR>
  endfunction

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

  "" fzf-preview
  nnoremap <silent> <C-p>  :<C-u>CocCommand fzf-preview.FromResources buffer project_mru project<CR>
  nnoremap <silent> [ff]s  :<C-u>CocCommand fzf-preview.GitStatus<CR>
  nnoremap <silent> [ff]gg :<C-u>CocCommand fzf-preview.GitActions<CR>
  nnoremap <silent> [ff]u  :<C-u>CocCommand fzf-preview.Buffers<CR>
  nnoremap          [ff]f  :<C-u>CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>
  xnoremap          [ff]f  "sy:CocCommand fzf-preview.ProjectGrep --add-fzf-arg=--exact --add-fzf-arg=--no-sort<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"

  nnoremap <silent> [ff]q  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<CR>
  nnoremap <silent> [ff]rf :<C-u>CocCommand fzf-preview.CocReferences<CR>
  nnoremap <silent> [ff]d  :<C-u>CocCommand fzf-preview.CocDefinition<CR>
  nnoremap <silent> [ff]i  :<C-u>CocCommand fzf-preview.CocTypeDefinition<CR>
  nnoremap <silent> [ff]o  :<C-u>CocCommand fzf-preview.CocOutline --add-fzf-arg=--exact --add-fzf-arg=--no-sort<CR>

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

  "" ビルトインプラグイン
  set nocompatible
  filetype plugin on
  runtime macros/matchit.vim
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

