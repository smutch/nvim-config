--- This is a copy of the builtin function with the filetype of the floating -
--- buffer changed from `markdown` to that of the parent filetype (see the
--- `ownsyntax` call).
function vim.lsp.util.fancy_floating_markdown(contents, opts)
  vim.validate {
    contents = { contents, 't' };
    opts = { opts, 't', true };
  }
  opts = opts or {}

  local stripped = {}
  local highlights = {}
  do
    local i = 1
    while i <= #contents do
      local line = contents[i]
      -- TODO(ashkan): use a more strict regex for filetype?
      local ft = line:match("^```([a-zA-Z0-9_]*)$")
      -- local ft = line:match("^```(.*)$")
      -- TODO(ashkan): validate the filetype here.
      if ft then
        local start = #stripped
        i = i + 1
        while i <= #contents do
          line = contents[i]
          if line == "```" then
            i = i + 1
            break
          end
          table.insert(stripped, line)
          i = i + 1
        end
        table.insert(highlights, {
          ft = ft;
          start = start + 1;
          finish = #stripped + 1 - 1;
        })
      else
        table.insert(stripped, line)
        i = i + 1
      end
    end
  end
  -- Clean up and add padding
  stripped = vim.lsp.util._trim_and_pad(stripped, opts)

  -- Compute size of float needed to show (wrapped) lines
  opts.wrap_at = opts.wrap_at or (vim.wo["wrap"] and vim.api.nvim_win_get_width(0))
  local width, height = vim.lsp.util._make_floating_popup_size(stripped, opts)

  -- Insert blank line separator after code block
  local insert_separator = opts.separator
  if insert_separator == nil then insert_separator = true end
  if insert_separator then
    for i, h in ipairs(highlights) do
      h.start = h.start + i - 1
      h.finish = h.finish + i - 1
      if h.finish + 1 <= #stripped then
        table.insert(stripped, h.finish + 1, string.rep("─", math.min(width, opts.wrap_at)))
        height = height + 1
      end
    end
  end

  -- Make the floating window.
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, false, vim.lsp.util.make_floating_popup_options(width, height, opts))
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stripped)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  -- Switch to the floating window to apply the syntax highlighting.
  -- This is because the syntax command doesn't accept a target.
  local cwin = vim.api.nvim_get_current_win()
  local csyn = vim.api.nvim_buf_get_option(0, "syntax"):lower()
  local cft = vim.api.nvim_buf_get_option(0, "filetype")
  vim.api.nvim_set_current_win(winnr)

  local syntax = "markdown"
  if csyn == "c" or csyn == "cpp" then syntax = csyn end
  vim.cmd("ownsyntax " .. syntax)

  local idx = 1
  --@private
  local function apply_syntax_to_region(ft, start, finish)
    if ft == '' then ft = cft end
    local name = ft..idx
    idx = idx + 1
    local lang = "@"..ft:upper()
    -- TODO(ashkan): better validation before this.
    if not pcall(vim.cmd, string.format("syntax include %s syntax/%s.vim", lang, ft)) then
      return
    end
    vim.cmd(string.format("syntax region %s start=+\\%%%dl+ end=+\\%%%dl+ contains=%s", name, start, finish + 1, lang))
  end
  -- Previous highlight region.
  -- TODO(ashkan): this wasn't working for some reason, but I would like to
  -- make sure that regions between code blocks are definitely markdown.
  -- local ph = {start = 0; finish = 1;}
  for _, h in ipairs(highlights) do
    -- apply_syntax_to_region('markdown', ph.finish, h.start)
    apply_syntax_to_region(h.ft, h.start, h.finish)
    -- ph = h
  end

  vim.api.nvim_set_current_win(cwin)
  return bufnr, winnr
end
