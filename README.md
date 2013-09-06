Vim Ultimate Colorscheme Utility, version 0.2.2
=======================================

Vim plugin that enables colorscheme and font browsing, choosing favorites, and
automatic/manual scheme switching based on the current filetype. You no longer
have to settle for one favorite scheme or guifont.

New Features
============
####Menu Integration

Ultimate Colorscheme Utility is now working on better integration into GVim.
There is now a 'Favorites' menu that enables all the functionality of the
plugin at the push of a button.

####Excluded Filetypes

Now you can specify which filetypes Ultimate Colorscheme Utility can ignore for
even more customizability.

Features
========
Ultimate Colorscheme Utility offers several features for customizing your
colorscheme preferences.
- Allows for easy browsing of all installed colorschemes. See the awesome
  archive at https://github.com/flazz/vim-colorschemes for a ton of
  colorschemes.
- Allows saving favorite colorschemes and fonts for all files, or for specific
  filetypes.
- Enables automatic switching of colorschemes and fonts when switching filetype
  buffers so that a favorite is always on.

Required Vim Options
====================
Vim must have been compiled with the following features:
- modify\_fname
- enable-gui (if you want to save your favorite fonts)

Installation
============
Vim-Ultimate-Colorscheme-Utility can also be found at
[vim.org](http://www.vim.org/scripts/script.php?script_id=4679), but this
should be avoided as github will always be more up to date.

### via Pathogen, the preferred method

```bash
cd ~/.vim/bundle
git clone https://github.com/biskark/vim-ultimate-colorscheme-utility.git
git checkout menu_integration
```

### via archive, the bad method
1. download archive
   but this is outdated.
2. unzip archive into .vim

Quick Usage Guide
=================
Note: This is not a complete list and all mappings are customizable, view the
helptags for more information.

```vim
<leader><leader>a    " Adds the current colorscheme to favorites
<leader><leader>A    " Removes the current colorscheme from favorites
<leader><leader>f    " Goes to next colorscheme in filetype specific favorites
<leader><leader>F    " Goes to previous colorscheme in filetype specific favorites
<leader><leader>g    " Goes to next colorscheme in global favorites
<leader><leader>G    " Goes to previous colorscheme in global favorites
<leader><leader>n    " Goes to next colorscheme in all colors
<leader><leader>N    " Goes to previous colorscheme in all colors

<leader><leader>t    " Adds the current font to favorites
<leader><leader>T    " Removes the current font from favorites
<leader><leader>e    " Goes to the next font in filetype specific favorites
<leader><leader>E    " Goes to the previous font in filetype specific favorites
<leader><leader>r    " Goes to the next font in global favorites
<leader><leader>R    " Goes to the previous font in global favorites

<leader><leader>q    " Views all favorites
```
