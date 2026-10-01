---@type LazySpec
return {
  "Vigemus/iron.nvim",
  cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide", "IronAttach" },
  keys = {
    { "<Leader>ir", "<Cmd>IronRepl<CR>", desc = "Toggle REPL" },
    { "<Leader>iR", "<Cmd>IronRestart<CR>", desc = "Restart REPL" },
    { "<Leader>if", "<Cmd>IronFocus<CR>", desc = "Focus REPL" },
    { "<Leader>ih", "<Cmd>IronHide<CR>", desc = "Hide REPL" },
    -- the send/mark keys below are registered by iron.setup()
    { "<Leader>is", desc = "Send to REPL", mode = { "n", "v" } },
    { "<Leader>im", desc = "Marks" },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = { ["<Leader>i"] = { desc = "REPL (iron)" } },
          v = { ["<Leader>i"] = { desc = "REPL (iron)" } },
        },
      },
    },
  },
  config = function()
    local iron = require "iron.core"
    local view = require "iron.view"
    local common = require "iron.fts.common"

    iron.setup {
      config = {
        scratch_repl = true, -- REPL buffer is discarded when closed
        repl_definition = {
          sh = { command = { "zsh" } },
          python = {
            -- use { "uv", "run", "ipython", "--no-autoindent" } to run inside the project venv
            command = { "ipython", "--no-autoindent" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
          lua = { command = { "lua" } },
        },
        repl_open_cmd = view.split.vertical.botright(0.4),
      },
      keymaps = {
        send_motion = "<Leader>isc",
        visual_send = "<Leader>isc",
        send_file = "<Leader>isf",
        send_line = "<Leader>isl",
        send_paragraph = "<Leader>isp",
        send_until_cursor = "<Leader>isu",
        send_mark = "<Leader>ism",
        send_code_block = "<Leader>isb",
        send_code_block_and_move = "<Leader>isn",
        mark_motion = "<Leader>imc",
        mark_visual = "<Leader>imc",
        remove_mark = "<Leader>imd",
        cr = "<Leader>is<CR>",
        interrupt = "<Leader>is<Space>",
        exit = "<Leader>isq",
        clear = "<Leader>icl",
      },
      highlight = { italic = true },
      ignore_blank_lines = true,
    }
  end,
}
