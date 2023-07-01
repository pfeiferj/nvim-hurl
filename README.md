# nvim-hurl

Syntax highlighting and runner for [Hurl](https://hurl.dev) files.

NOTE: This is an unofficial plugin, visit <https://hurl.dev> for more
information about the project


## Runner

Provides a :Hurl command that runs hurl against the current
file. Opens the results in a floating window.

The :Hurl command creates an nvim terminal to show colorized output from hurl.
Unfortunately when copying from an nvim terminal any linewraps result in a new
line when pasting. The HurlNoColor uses a plain scratch buffer and runs hurl
without color to allow for copying without new lines on line wraps.

```vim
:Hurl
:HurlNoColor
```

```lua
require'hurl'.hurl()                  -- Equivalent to :Hurl
require'hurl'.hurl({ color = false }) -- Equivalent to :HurlNoColor
```

## Setup

### Requirements

This project utilizes [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
to manage the tree-sitter parser for hurl. You must have nvim-treesitter
installed to use this plugin.

To use the :Hurl command you must have hurl installed on your path.

### Instructions

Once you install the plugin it can be setup using the setup function:

``` lua
require("hurl").setup({
  color = true -- Default: true
})
```

Default settings table:
```lua
{
  color = true
}
```

If you would like to modify any of these settings change the corresponding key in the hurl setup function.

The setup function injects the hurl tree-sitter configuration into
nvim-treesitter but does not install the parser. To install the parser you must
either call :TSinstall hurl or add hurl to your nvim-treesitter
ensure\_installed list

Command:

``` vim
:TSInstall hurl
```

nvim-treesitter setup with parser install:

``` lua
require 'nvim-treesitter.config'.setup {
  ensure_installed = { "hurl" },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}
```

### Packer

``` lua
use {
  "nvim-treesitter/nvim-treesitter",
  requires = {
    {
      "pfeiferj/nvim-hurl",
      branch="main",
    }
  },
  config = function()

    require("hurl").setup() -- add hurl to the nvim-treesitter config

    require 'nvim-treesitter.config'.setup {
      ensure_installed = { "hurl" }, -- ensure that hurl gets installed
      highlight = {
        enable = true -- hurl plugin provides tree-sitter highlighting
      },
      indent = {
        enable = true -- hurl plugin provides tree-sitter indenting
      }
    }
  end
};

```
