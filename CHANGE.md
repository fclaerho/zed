
## Sun Feb 01 15:38:16 CET 2004 - v1.3R

- pressing F1 indent the selected text area, F2 reverse the process
- 'bookmarks' and historic management
	->historic nearly makes z to be multibuffered
- <alt-t> for tags
- <ctrl-e>and <ctrl-alt-e> removed, the data entry react now like vi
	-> /str to look for str
	-> :cmd to execute the tcl cmd
- the file list now give the number of items
- 'newFolder' tool
- copy/cut/paste work now with the modifier 'alt' due to tk constraint (ctrl-v is already bound and it seems it cannot be undone)

## Fri Jan 30 14:03:09 CET 2004 - v1.3 final

- hilighting mode has been changed to speed up the whole thing
(this was too sloooow on several machines)

- sideBar cannot be fooled anymore :)

- splash screen appears now *before* the loading, it a bit more logical

- comment hilighting primitive has been 'fixed'.

## Thu Jan 29 00:39:51 CET 2004 - v1.3b5
	
- Fix 'fileHasChanged'

## Sun Jan 25 23:20:52 CET 2004

KNOWN BUG: if you work on window$ files from a posix system, there'll be
a little problem as the end line chars (\n\r) are translated into simple (\n) by
the 'text' widget; so the editor believe you've modified the file even if u don't
do anything! - This will be fixed soon...

## Thu Jan 22 00:07:40 CET 2004 - v1.3b4

- added the lineFinder box and the related stuff
- the code has been a bit cleaned (about the sync/resync functions)
- added the rewrite configuration menu

KNOWN BUG: the 'fileHasChanged' function is not really reliable
so even if u don't change the file size, but you do have modified
something, the editor won't see anything - be careful.

## Mon Jan 19 18:53:11 CET 2004 - v1.3b3

- configuration file 'update' function rebuilt  to allow
modifications during the current session

- 'ghost file ' bug fixed (if you move/remove a file that
was loaded in the buffer=huge problem...but this is now ~managed!)

## Sun Jan 18 00:23:03 CET 2004 - v1.3b2

- Color 'theme' support via tk_setPalette
- window geometry status saved in the conf. file
- 'Home' button added
- access restriction bug fixed
- splash screen
- initialization sequence moved into 'z.tcl'
- hidden shortcuts (god mode :)
	(the command is entered in the '.data' entry)
	- <ctrl-e> execute the command via exec
	- <ctrl-alt-e> execute the command as a [tcl/tk]-script command
		('exit' is usefull when the editor is going mad and all is over due to a bug)
- new language CC (c++)
- new language xml
- new plugin advanced research (alpha)

## Sat Jan 17 00:52:57 CET 2004 - v1.3b1

- UI improvement:
	- the folder list can be resized using the bottom scale
	- a side bar has been added to show the line numbers
	- a new logo (cf about box)
- Browsing improvement
	- even if z should still be considered as a 'local' editor, the current directory can be changed
- syntax hilighting engine has been reworked (the file opening sequence was too slow)
- <Control-s> bug fixed

## (...) - v1.2

lost in virtual space (tm)...

## Tue May 13 00:14:58 CEST 2003 - v1.1

- Syntax highlighting algorithms update
- Checkpoints
- C language support
- file modification mark
- big changes in key links
...
