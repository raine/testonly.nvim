# TestOnly.nvim

TestOnly.nvim is a plugin designed to enhance JavaScript and TypeScript testing
workflow. It provides a simple way to toggle exclusivity for `it` and `describe`
test blocks, i.e. change them to `it.only` and `describe.only` and vice versa.

![](https://github.com/raine/testonly.nvim/blob/gh-pages/testonly_demo.gif?raw=true)

## Requirements

- Neovim version that supports Treesitter
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter#installation)
- Language parser installed for nvim-treesitter
  - For example, `:TSInstall javascript`

## Installation

Install the plugin using your favorite package manager. For example, with
[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'raine/testonly.nvim'
```

## Usage

The plugin operates based on the position of the cursor. When you run a command,
the plugin will look for an `it` or `describe` block where the cursor is located
and apply the operation to that block.

The following commands are available after installing the plugin:

- Toggle current `it` test block: `<Plug>(testonly-toggle-it)`
- Toggle current `describe` test block: `<Plug>(testonly-toggle-describe)`
- Reset all exclusive tests: `<Plug>(testonly-reset)`

You can map these commands to your preferred keyboard shortcuts in your init.vim
or init.lua. For example:

```vim
nmap <leader>ti <Plug>(testonly-toggle-it)
nmap <leader>td <Plug>(testonly-toggle-describe)
nmap <leader>tr <Plug>(testonly-reset)
```

## Contributing

Feel free to open an issue if you encounter any problems or have improvements to
suggest.

## License

MIT
