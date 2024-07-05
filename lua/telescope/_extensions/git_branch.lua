local git_branch = require('git_branch')

return require("telescope").register_extension {
  exports = {
    git_branch = git_branch.files
  },
}
