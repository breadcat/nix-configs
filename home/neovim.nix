{...}: {
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
    extraLuaConfig = ''
      -- Define and register :NixSortIncludes to sort selected Nix includes
      vim.api.nvim_create_user_command('NixSortIncludes', function()
        -- Get the start and end lines of the visual selection
        local start_line = vim.fn.line("'<") - 1
        local end_line = vim.fn.line("'>")

        -- Get the lines from the current buffer
        local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

        -- Function to extract path for sorting
        local function extract_path(line)
          local cleaned = line
          cleaned = cleaned:gsub("^%s*%(", "")           -- remove leading '('
          cleaned = cleaned:gsub("^import%s+", "")       -- remove 'import'
          cleaned = cleaned:gsub("%s+%b{}", "")          -- remove '{...}'
          cleaned = cleaned:gsub("^%s+", "")             -- trim leading spaces
          cleaned = cleaned:gsub("%)+%s*$", "")          -- remove trailing ')'
          return cleaned
        end

        -- Sort lines using the extracted path
        table.sort(lines, function(a, b)
          return extract_path(a) < extract_path(b)
        end)

        -- Replace lines in the buffer
        vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
      end, { range = true })
    '';
  };
}
