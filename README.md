# vim-python-runner

A lightweight Vim plugin that allows you to run the current Python script directly in an integrated terminal window.

## Features

- 🔄 **Run scripts without leaving Vim**: Execute the current Python file with a single keystroke.
- 🪟 **Flexible execution modes**:
  - `<F5>`: Runs the script in a horizontally split terminal and switches back to the original window after execution.
  - `<F8>`: Runs the script in a new tab terminal and stays in the terminal after execution.
- 📄 **Auto-save support**: Unsaved files are automatically saved to a temporary `.py` file before execution.
- 🐚 **Terminal compatibility**: Supports common terminals including `cmd.exe`, `powershell`, and `bash`.

## Installation

Copy the function and mappings into your .vimrc or source it from a separate file.

Or, You can install this plugin using any Vim plugin manager, for example:

### With [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'louisliu0816/vim-python-runner'
```
Then reload Vim and run:
```vim
:PlugInstall
```

## Key Mappings
This plugin maps the following keys in normal mode:

`<F5>`: Run current Python file in horizontal terminal.  
`<F8>`: Run current Python file in new terminal tab.

You can change the mappings by editing the lines at the bottom of the script.

## Requirements
Vim 8+ with terminal support (:echo has('terminal') should return 1)

Python installed and accessible via py.exe (Windows) or python3 (Linux/macOS)

One of the supported shells: cmd.exe, powershell, or bash

## Usage
Open a .py file in Vim and press <F5> or <F8>.

If the file is unsaved, a temporary .py file will be generated and executed.

Output will appear in an integrated terminal window.

Cursor focus is automatically managed.

## License
MIT
