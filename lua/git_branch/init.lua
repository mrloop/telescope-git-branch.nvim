local git_branch = {}

local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local putils = require "telescope.previewers.utils"
local utils = require('telescope.utils')

local function git(args, cwd)
  table.insert(args, 1, "git")
  return utils.get_os_command_output(args, cwd)[1]
end

local function merge_base(cwd)
  local main_branch = git({ "--no-pager", "branch", "-l", "main", "master", "--format", "%(refname:short)" }, cwd)
  local current_branch = git({ "branch", "--show-current" }, cwd)
  return git({ "merge-base", current_branch, main_branch }, cwd)
end

local get_branch_file_diff = function(opts)
  return previewers.new_buffer_previewer {
    title = "Git Branch File Diff Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,
    define_preview = function(self, entry, status)
      putils.job_maker({ "git", "--no-pager", "diff", merge_base(opts.cwd), "--", entry.value }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            putils.regex_highlighter(bufnr, "diff")
          end
        end,
      })
    end,
  }
end

git_branch.files = function(opts)
  opts = opts or {}

  -- show untracked files as well
  git({ "add", "--intent-to-add", "." }, opts.cwd)

  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_file(opts))
  opts.finder_command = vim.F.if_nil(opts.finder_command, { "git", "--no-pager", "diff", merge_base(opts.cwd), "--name-only" })

  pickers.new(opts, {
    prompt_title = "Git Branch Files",
    finder = finders.new_oneshot_job(
      opts.finder_command,
      opts
    ),
    previewer = get_branch_file_diff(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return git_branch
