{ lib, vimUtils, writeText, runCommand }:

let
  sortblockLua = writeText "sortblock.lua" ''
    -- sortblock.lua
    -- Sort + dedupe marked blocks of text on save.
    --
    -- Wrap lines in markers:
    --   # sort:start
    --   cat
    --   dog
    --   # sort:end
    --
    -- Also supports flags, eh: sort:start reverse nodedupe case
      start_marker = "sort:start",
    local M = {}
    M.config = {
      end_marker = "sort:end",
      pattern = "*",
      ignorecase = true,
      dedupe = true,
      reverse = false,
      strip_blanks = true,
    }

    -- Flags accepted on the start-marker line, mapped to config overrides.
    local FLAGS = {
      case = { ignorecase = false },
      nocase = { ignorecase = true },
      reverse = { reverse = true },
      nodedupe = { dedupe = false },
      dedupe = { dedupe = true },
      keepblanks = { strip_blanks = false },
    }

    local function opts_for_block(base, tail)
      local opts = vim.tbl_extend("force", {}, base)
      for word in (tail or ""):gmatch("%S+") do
        local override = FLAGS[word:lower()]
        if override then opts = vim.tbl_extend("force", opts, override) end
      end
      return opts
    end

    local function key_of(line, opts)
      local k = vim.trim(line)
      if opts.ignorecase then k = k:lower() end
      return k
    end

    -- Take the raw lines of a block, return the sorted/deduped version.
    local function transform(lines, opts)
      local out, seen = {}, {}
      for _, line in ipairs(lines) do
        local trimmed = vim.trim(line)
        if not (opts.strip_blanks and trimmed == "") then
          local k = key_of(line, opts)
          if not (opts.dedupe and seen[k]) then
            seen[k] = true
            out[#out + 1] = line
          end
        end
      end

      table.sort(out, function(a, b)
        local ka, kb = key_of(a, opts), key_of(b, opts)
        if ka == kb then return vim.trim(a) < vim.trim(b) end -- stable-ish tiebreak
        if opts.reverse then return ka > kb end
        return ka < kb
      end)

      return out
    end

    local function same(a, b)
      if #a ~= #b then return false end
      for i = 1, #a do
        if a[i] ~= b[i] then return false end
      end
      return true
    end

    -- Find all blocks, returns list
    local function find_blocks(lines, cfg)
      local blocks, open, open_opts = {}, nil, nil
      for i, line in ipairs(lines) do
        local s, e = line:find(cfg.start_marker, 1, true)
        if s and not open then
          open = i
          open_opts = opts_for_block(cfg, line:sub(e + 1))
        elseif line:find(cfg.end_marker, 1, true) and open then
          if i > open + 1 then
            blocks[#blocks + 1] = { first = open, last = i - 2, opts = open_opts }
          end
          open, open_opts = nil, nil
        end
      end
      return blocks
    end

    function M.sort_buffer(bufnr)
      bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
      if not vim.api.nvim_buf_is_loaded(bufnr) then return end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local blocks = find_blocks(lines, M.config)
      if #blocks == 0 then return end

      -- Remember cursor positions
      local views = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == bufnr then
          views[win] = vim.api.nvim_win_get_cursor(win)
        end
      end

      -- Apply backwards so line numbers are valid
      for i = #blocks, 1, -1 do
        local b = blocks[i]
        local original = vim.list_slice(lines, b.first + 1, b.last + 1)
        local sorted = transform(original, b.opts)
        if not same(original, sorted) then
          vim.api.nvim_buf_set_lines(bufnr, b.first, b.last + 1, false, sorted)
        end
      end

      local count = vim.api.nvim_buf_line_count(bufnr)
      for win, pos in pairs(views) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_set_cursor(win, { math.min(pos[1], count), pos[2] })
        end
      end
    end

    function M.setup(user_config)
      M.config = vim.tbl_extend("force", M.config, user_config or {})

      local group = vim.api.nvim_create_augroup("SortBlockOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        pattern = M.config.pattern,
        callback = function(args) M.sort_buffer(args.buf) end,
      })

      vim.api.nvim_create_user_command("SortBlocks", function()
        M.sort_buffer(0)
      end, { desc = "Sort and dedupe all marked blocks in this buffer" })
    end

    return M
  '';
in
vimUtils.buildVimPlugin {
  pname = "sortblock";
  version = "1.0.0";

  # buildVimPlugin expects a source tree laid out the way Neovim's
  # runtimepath wants it, so wrap the embedded lua string in lua/.
  src = runCommand "sortblock-src" { } ''
    mkdir -p $out/lua
    cp ${sortblockLua} $out/lua/sortblock.lua
  '';

  # Fails the build if `require("sortblock")` errors — catches syntax
  # mistakes at rebuild time instead of at startup.
  # Remove this if your nixpkgs is older than 24.05.
  nvimRequireCheck = "sortblock";

  meta = {
    description = "Sort and dedupe marked blocks of text on save";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
