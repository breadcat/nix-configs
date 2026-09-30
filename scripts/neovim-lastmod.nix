{ lib, vimUtils, writeText, runCommand }:

let
  lastmodLua = writeText "lastmod.lua" ''
    local SEARCH_LINES = 10
    local TS_FORMAT = "%Y-%m-%dT%H:%M:%S"
    local TS_PATTERN = "%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:?%d*"

    local group = vim.api.nvim_create_augroup("LastmodPrompt", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = { "*.md", "*.markdown" },
    desc = "Prompt to update lastmod frontmatter field on save",
    callback = function(args)
    local buf = args.buf
    if not vim.bo[buf].modifiable then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, SEARCH_LINES, false)

    for i, line in ipairs(lines) do
      local prefix, old = line:match("^(%s*lastmod:%s*[\"']?)(" .. TS_PATTERN .. ")")
      if old then
        local now = os.date(TS_FORMAT)
        local choice = vim.fn.confirm(
          ("Update lastmod?\n  %s  ->  %s"):format(old, now),
          "&Yes\n&No",
          1 -- defaults to Yes
        )
        if choice == 1 then
          -- Replace only the timestamp, preserving indentation/quotes/trailing text
          local new_line = line:gsub(TS_PATTERN, now, 1)
          vim.api.nvim_buf_set_lines(buf, i - 1, i, false, { new_line })
        end
        return -- only handle the first lastmod field found
      end
    end
    end,
    })

  '';
in
  vimUtils.buildVimPlugin {
    pname = "lastmod";
    version = "1.0.0";

  # buildVimPlugin expects a source tree laid out the way Neovim's
  # runtimepath wants it, so wrap the embedded lua string in lua/.
  src = runCommand "lastmod-src" { } ''
    mkdir -p $out/lua
    cp ${lastmodLua} $out/lua/lastmod.lua
  '';

  nvimRequireCheck = "lastmod";

  meta = {
    description = "Prompts whether Neovim should update the lastmod field in markdown files on save";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
