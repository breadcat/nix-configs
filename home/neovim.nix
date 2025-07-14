{
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set smartcase
      set nocompatible
      let mapleader =","
      set backspace=indent,eol,start
      set clipboard+=unnamedplus
      set ignorecase
      set linebreak
      set mouse=a
      set nohlsearch
      set number
      set title
      set titlestring=%f\ %m
      set whichwrap+=<,>,h,l,[,]
      set list listchars=nbsp:¬,tab:»·,trail:·,extends:>
      set shiftwidth=2
      set softtabstop=2
      set tabstop=2
      syntax on
      map <C-H> <C-W>
      map <C-Del> X<Esc>ce<del>
      map <F8> :setlocal spell! spelllang=en_gb<CR>
      xnoremap <A-z> :s/^.<CR>gv " alt-z removes first character of line
      nnoremap <A-z> 0x " alt-z in normal mode removes first char
      :iab <expr> _date strftime("%F")
      :iab <expr> _time strftime("%H:%M")
      :iab <expr> _stamp strftime("%F\T%H:%M:00")
      autocmd BufWritePre * %s/\s\+$//e
      autocmd BufWritepre * %s/\n\+\%$//e
      autocmd FileType nix setlocal tabstop=2 shiftwidth=2 expandtab
      autocmd BufWritePre *.nix %s/\s\+$//e | retab
      autocmd BufWritePost *.nix silent! execute '!alejandra -qq %' | edit
    '';
  };
}
