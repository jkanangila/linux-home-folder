---@module "oil-cspell"

local M = {}

local oil = require "oil"

local namespace = vim.api.nvim_create_namespace "oil-cspell"

local ignored_names = {
  ["."] = true,
  [".."] = true,

  [".git"] = true,
  [".gitignore"] = true,
  [".gitmodules"] = true,

  [".env"] = true,
  [".envrc"] = true,

  [".cspell.json"] = true,

  ["package-lock.json"] = true,
  ["pnpm-lock.yaml"] = true,
  ["yarn.lock"] = true,
  ["uv.lock"] = true,
}

---@class OilCSpellIssue
---@field word string
---@field offset integer
---@field length integer
---@field suggestions string[]

---@class OilCSpellState
---@field bufnr integer
---@field line integer
---@field entry_name string
---@field name string
---@field issue OilCSpellIssue

---@type OilCSpellState?
local last_issue = nil

local function notify(message, level)
  vim.notify(message, level, {
    title = "Oil CSpell",
  })
end

---@param name string
---@param cwd string
---@param callback fun(result: vim.SystemCompleted)
local function check_name(name, cwd, callback)
  vim.system({
    "cspell",
    "stdin",
    "--no-progress",
    "--no-summary",
    "--show-suggestions",
    "--reporter",
    "@cspell/cspell-json-reporter",
  }, {
    cwd = cwd,
    text = true,
    stdin = name,
  }, function(result)
    vim.schedule(function() callback(result) end)
  end)
end

---@return OilCSpellIssue[]
local function parse_result(result)
  local output = vim.trim(result.stdout or "")

  if output == "" then return {} end

  local ok, data = pcall(vim.json.decode, output)

  if not ok or type(data) ~= "table" then
    notify("Could not parse CSpell JSON output", vim.log.levels.ERROR)

    return {}
  end

  local issues = {}

  for _, issue in ipairs(data.issues or {}) do
    table.insert(issues, {
      word = issue.text,
      offset = issue.offset,
      length = issue.length,
      suggestions = issue.suggestions or {},
    })
  end

  return issues
end

---@param entry table
---@return string
local function spellcheck_name(entry)
  local name = entry.name

  -- For files, spellcheck the filename without its extension.
  --
  --   applicaiton.py
  --
  -- becomes:
  --
  --   applicaiton
  if entry.type == "file" then name = vim.fn.fnamemodify(name, ":r") end

  return name
end

---@return OilCSpellState?
local function get_current_issue()
  if not last_issue then return nil end

  if not vim.api.nvim_buf_is_valid(last_issue.bufnr) then
    last_issue = nil
    return nil
  end

  if vim.api.nvim_get_current_buf() ~= last_issue.bufnr then return nil end

  local entry = oil.get_cursor_entry()

  if not entry then
    last_issue = nil
    return nil
  end

  if entry.name ~= last_issue.entry_name then
    last_issue = nil
    return nil
  end

  return last_issue
end

function M.check_current()
  if vim.bo.filetype ~= "oil" then
    notify("CSpell filename checking is only available in Oil", vim.log.levels.WARN)

    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  local cwd = oil.get_current_dir()
  local entry = oil.get_cursor_entry()

  if not cwd or not entry then
    notify("No Oil entry under cursor", vim.log.levels.WARN)

    return
  end

  if ignored_names[entry.name] then
    vim.diagnostic.reset(namespace, bufnr)
    last_issue = nil
    return
  end

  local name = spellcheck_name(entry)

  local original_entry_name = entry.name
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1

  vim.diagnostic.reset(namespace, bufnr)
  last_issue = nil

  check_name(name, cwd, function(result)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    if vim.api.nvim_get_current_buf() ~= bufnr then return end

    local current_entry = oil.get_cursor_entry()

    if not current_entry then return end

    if current_entry.name ~= original_entry_name then return end

    local issues = parse_result(result)

    if #issues == 0 then
      notify(("✓ %s"):format(name), vim.log.levels.INFO)

      return
    end

    local diagnostics = {}

    for _, issue in ipairs(issues) do
      local message

      if #issue.suggestions > 0 then
        message = ("Spelling: %s → %s"):format(issue.word, table.concat(issue.suggestions, ", "))
      else
        message = ("Unknown word: %s"):format(issue.word)
      end

      table.insert(diagnostics, {
        lnum = line,
        col = 0,
        end_col = #entry.name,

        severity = vim.diagnostic.severity.WARN,

        message = message,

        source = "cspell",
      })
    end

    vim.diagnostic.set(namespace, bufnr, diagnostics)

    last_issue = {
      bufnr = bufnr,
      line = line,
      entry_name = original_entry_name,
      name = name,
      issue = issues[1],
    }
  end)
end

---@param new_word string
local function rename_current_entry(new_word)
  local state = get_current_issue()

  if not state then
    notify("No CSpell issue under cursor", vim.log.levels.WARN)
    return
  end

  local bufnr = state.bufnr

  if not vim.api.nvim_buf_is_valid(bufnr) then
    notify("Oil buffer is no longer valid", vim.log.levels.ERROR)
    return
  end

  local entry = oil.get_cursor_entry()

  if not entry then
    notify("No Oil entry under cursor", vim.log.levels.WARN)
    return
  end

  -- Make sure the entry has not changed since CSpell checked it.
  if entry.name ~= state.entry_name then
    notify("Oil entry changed; rename cancelled", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, state.line, state.line + 1, false)

  local line = lines[1]

  if not line then
    notify("Could not locate Oil entry line", vim.log.levels.ERROR)
    return
  end

  ----------------------------------------------------------------------
  -- Oil renders something like:
  --
  --     󰦪  frenc-receipes.txt
  --
  -- entry.name is:
  --
  --     frenc-receipes.txt
  --
  -- Find the filename at the end of the rendered line.
  ----------------------------------------------------------------------

  local old_name = state.entry_name

  local rendered_name = line:sub(-#old_name)

  if rendered_name ~= old_name then
    notify(('Could not find "%s" at the end of the Oil line'):format(old_name), vim.log.levels.ERROR)
    return
  end

  local prefix = line:sub(1, #line - #old_name)

  ----------------------------------------------------------------------
  -- IMPORTANT:
  --
  -- CSpell's suggestion is a replacement for the MISSPELLED WORD,
  -- not a replacement for the entire filename.
  --
  -- Example:
  --
  --     filename:  frenc-receipes.txt
  --     bad word:  frenc
  --     suggestion: french
  --
  -- Result:
  --
  --     french-receipes.txt
  ----------------------------------------------------------------------

  local issue = state.issue

  local word = issue.word

  if word == "" then
    notify("CSpell returned an empty word", vim.log.levels.ERROR)
    return
  end

  ----------------------------------------------------------------------
  -- Find the CSpell word inside the actual filename.
  --
  -- CSpell's offset is based on the text that we passed to CSpell.
  -- For files, that text does not contain the extension.
  ----------------------------------------------------------------------

  local word_start, word_end = old_name:find(vim.pesc(word), 1, false)

  if not word_start then
    notify(('Could not find CSpell word "%s" in "%s"'):format(word, old_name), vim.log.levels.ERROR)
    return
  end

  ----------------------------------------------------------------------
  -- Replace ONLY the misspelled word.
  --
  -- Example:
  --
  --     old_name = "frenc-receipes.txt"
  --     word     = "frenc"
  --     new_word = "french"
  --
  -- produces:
  --
  --     french-receipes.txt
  ----------------------------------------------------------------------

  local corrected_name = old_name:sub(1, word_start - 1) .. new_word .. old_name:sub(word_end + 1)

  if corrected_name == old_name then
    notify("The suggested name is already the current name", vim.log.levels.INFO)
    return
  end

  ----------------------------------------------------------------------
  -- Replace only the filename in the Oil buffer.
  ----------------------------------------------------------------------

  vim.api.nvim_buf_set_lines(bufnr, state.line, state.line + 1, false, {
    prefix .. corrected_name,
  })

  ----------------------------------------------------------------------
  -- Let Oil perform the filesystem mutation.
  ----------------------------------------------------------------------

  oil.save {
    confirm = true,
  }

  ----------------------------------------------------------------------
  -- Clean up CSpell state.
  ----------------------------------------------------------------------

  vim.diagnostic.reset(namespace, bufnr)

  last_issue = nil

  notify(('Renamed "%s" → "%s"'):format(old_name, corrected_name), vim.log.levels.INFO)
end
function M.code_actions()
  local state = get_current_issue()

  if not state then
    notify("No CSpell issue under cursor", vim.log.levels.WARN)

    return
  end

  local suggestions = state.issue.suggestions

  if #suggestions == 0 then
    notify(('No suggestions for "%s"'):format(state.issue.word), vim.log.levels.INFO)

    return
  end

  vim.ui.select(suggestions, {
    prompt = ('Replace "%s" with:'):format(state.issue.word),

    format_item = function(item) return ("✓ %s"):format(item) end,
  }, function(choice)
    if not choice then return end

    rename_current_entry(choice)
  end)
end

function M.clear()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.diagnostic.reset(namespace, bufnr)

  last_issue = nil
end

return M
