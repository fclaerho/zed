FOREWORD
========

_20 Sep. 2012._

This is probably my oldest "real" project, dating back from engineering school (read: **no longer maintained**).
We were then learning Tk, and it was my first GUI toolkit... I hacked this code editor "Z" out of enthusiasm.
As for other "finished" projects, I decided to dig it out and store it on github for posterity ;-)
I renamed a couple of files, removed some keybindings that were preventing it to start
and surprisingly it's still working on my MacBook'11...
Some menu titles are missing though, but except if asked otherwise I don't really plan to fix it.
I edited a bit the readme to fix some english and convert it to markdown.

* * *

INTRODUCTION
============

_12 May 2003._

Z is a small "local" editor,
i.e. it starts with the files from within the current directory.

The side listbox allows to browse between the files in the current directory;
simply click on a item to open it.
If you start to modify the opened file
(pressing some key is considered as a modification in the file, mouse events are not)
you won't be allowed to open or create another file:
* click on the ![floppy icon](https://github.com/claerhout/zed/raw/master/gif/16_save.gif) or use menus to save your modifications,
* or click on the ![revert icon](https://github.com/claerhout/zed/raw/master/gif/16_revert.gif) or use menus to discard your changes.

To create a new file,
click on the ![beach icon](https://github.com/claerhout/zed/raw/master/gif/holiday.gif),
the file name will be a default one.
You can give it another name by entering it in the text box next to the toolbar and then
click again on the beach icon.
if the file aready exists it won't be erased, a dialog box will warn you about the conflict.
On conflict, if the default name is used, an internal function will give it another unique name.

SYNTAX HIGHLIGHTING & MODULES
=============================

By default, z only recognizes the 'text' file type and doesn't apply any syntax highlighting.
However as z is built with a module support, it's easy to add a new filetype.
Each filetype is associated to:
* highlighting rules,
* a filename pattern,
* a linked command.
The status bar shows all this informations for the current opened file;
e.g.:
* for a text file: `Working on <<README.txt>> (Txt/)` (no linked application),
* for a tck/tk script: `Working on <<foo.tcl>> (TclTk/execWish)` (linked app: wish)
When a language plugin is loaded it adds a new entry in the Languages menu
and if autoSwitch is enabled (default) when you open a file matching the pattern given
by the language plugin the highlighting rules are automatically applied.
To launch the linked command, click on ![the cpu icon](https://github.com/claerhout/zed/raw/master/gif/cpu.gif) or use menus.

STRING SEARCH
=============

When a file is opened, you can search a string by completing the entry box next the toolbar
and by clicking then on the 'target' icon. The number of matches will be showed in the status
bar, text will be highlighted and the window will be scrolled to reach the first highlighted string.

CONFIGURATION
=============

There's not yet a configuration tool so open the 'z.conf.tcl' file to customize variables.
This is the same game for the syntax color rules (edit the module mod_...tcl)
If you want to add a new language support module, name it mod_languageID.tcl and move it
in the z core script directory. A language module MUST have @least two functions which are
called by the module loader:
  * load_mod_languageID wich will used the core function 'addType pattern extansion linkedApp'
  * apply_[your file extension] which will import the global variables
		keyWords commands ranges comments to complete list of keywords, ranges, etc...with
		colors
the linkedApp can be a local function, but it need to have a filename as parameter.
