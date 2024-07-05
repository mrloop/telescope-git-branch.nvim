# telescope-git-branch

*Telescope Git Branch* is a [Telescope](https://github.com/nvim-telescope/telescope.nvim) extension that searches a Git branch for files which are different from the default branch, previews a diff of the changes and allows you to open files that are different from the default branch.

The [telescope-git-branch.nvim](https://github.com/mrloop/telescope-git-branch.nvim) extension is great for working with feature branches, where you want to easily see the differences between the default branch and the feature branch. It lets you search for differences across multiple commits on the same branch.

## Installation 

You can install these plugin using your favorite vim package manager, e.g.
[vim-plug](https://github.com/junegunn/vim-plug) and
[lazy](https://github.com/folke/lazy.nvim).

**lazy**:
```lua
{
    'mrloop/telescope-git-branch.nvim'
}
```

**vim-plug**
```VimL
Plug 'https://gitlab.com/mrloop/telescope-git-branch.nvim'
```


## Usage

Activate the custom Telescope commands and `git_branch` extension by adding

```lua
require('telescope').load_extension('git_branch')
```

somewhere after your `require('telescope').setup()` call.
This is typically all you need to configure the plugin.

The following `Telescope` extension commands are provided:

```VimL
:Telescope git_branch
```

These commands can also be used from your `init.lua`.

For example, to bind `files` to `<leader>gf` use:

```lua
-- Search for the files with differences to default branch.
vim.keymap.set({'n', 'v'}, '<leader>gf', function()
    require('git_branch').files()
end)
```
