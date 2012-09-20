tk_setPalette $skin

#<IHM/MAINWINDOW>
frame .mainFrame -borderwidth 1
frame .mainFrame.rightFrame -borderwidth 0 -relief flat
frame .mainFrame.leftFrame -borderwidth 0 -relief flat
frame .mainFrame.rightFrame.toolbar -borderwidth 1 -relief flat
frame .mainFrame.rightFrame.viewer -borderwidth 1 -relief sunken

set m ".mainFrame"
set r ".mainFrame.rightFrame"
set l ".mainFrame.leftFrame"
set t ".mainFrame.rightFrame.toolbar"
set v ".mainFrame.rightFrame.viewer"

image create photo .pixAlert
.pixAlert configure -file "gif/alert.gif"
image create photo .pixInfo
.pixInfo configure -file "gif/ideas.gif"
image create photo .pixPerso
.pixPerso configure -file "gif/personal.gif"
image create photo .pixWhere
.pixWhere configure -file "gif/ftp.gif"
image create photo .pixTime
.pixTime configure -file "gif/time.gif"
image create photo .pixHelp
.pixHelp configure -file "gif/lib.gif"
image create photo .pixStat
.pixStat configure -file "gif/folder.gif"
image create photo .pixEdit
.pixEdit configure -file "gif/edit.gif"
image create photo .pixTuX
.pixTuX configure -file "gif/Linux.gif"
image create photo .pixPack
.pixPack configure -file "gif/Package.gif"
image create photo .pixUnPack
.pixUnPack configure -file "gif/Package2.gif"
image create photo .pixKey
.pixKey configure -file "gif/login.gif"
image create photo .pixStatus
.pixStatus configure -file "gif/term.gif"
image create photo .pixFavorite
.pixFavorite configure -file "gif/favorites.gif"
image create photo .pixZ
.pixZ configure -file "gif/z.gif"

proc backHome {} {
	global env
	switchFile "$env(HOME)"}

#<TOOLBAR>
foreach {opName iconFile opCommand} {
	Exit "gif/shutdown.gif" "quit"
	Home "gif/suspend.gif" "backHome"
	Bookmark "gif/favorites.gif" "bookmark"
	Folder "gif/folder.gif" "newFolder"
	New "gif/hot.gif" "newFile"
	Save "gif/16_save.gif" "saveFile"
	Discard "gif/16_revert.gif" "discardChanges"
	Exec "gif/cpu.gif" "execApp"
	Print "gif/printer.gif" "printFile"
	About "gif/help.gif" "about"} {
	image create photo .pix$opName
	.pix$opName configure -file $iconFile
	button $t.button$opName -image .pix$opName -borderwidth 1 -relief groove -width 20 -height 18 -command $opCommand -bg $skin_abg
	pack $t.button$opName -side left
	bind $t.button$opName <Enter> "updateMssgStatus $opCommand"
	bind $t.button$opName <Leave> "updateMssgStatus restore"}
entry $t.data -width 5 -font $font2 -borderwidth 1 -relief sunken -highlightthickness 0 -selectborderwidth 0 -selectbackground $skin_abg
pack $t.data -side left -fill x -expand 1 -padx 2

foreach {menuName} {
	File
	Edit
	Languages
	Bookmarks} {
	menubutton $t.menu$menuName -text $menuName -menu $t.menu$menuName.localMenu -activebackground $skin_abg -activeforeground $skin_afg -font $font1 -borderwidth 1
	menu $t.menu$menuName.localMenu -font $font1 -tearoff 0 -relief groove -borderwidth 1 -activeborderwidth 0
	pack $t.menu$menuName -side right}
	#file menu...
	$t.menuFile.localMenu add command -image .pixStatus -accelerator "New window" -command "exec wish $home/z.tcl &"
	$t.menuFile.localMenu add separator
	$t.menuFile.localMenu add command -image .pixNew -accelerator "New file" -command "newFile"
	$t.menuFile.localMenu add command -image .pixSave -accelerator "Save file" -command "saveFile"
	$t.menuFile.localMenu add command -image .pixDiscard -accelerator "Discard changes" -command "discardChanges"
	$t.menuFile.localMenu add command -image .pixExec -accelerator "Exec App" -command "execApp"
	$t.menuFile.localMenu add separator
	$t.menuFile.localMenu add command -image .pixAbout -command "about" -accelerator "About"
	$t.menuFile.localMenu add separator
	$t.menuFile.localMenu add command -image .pixStatus -command "rewriteConfFile" -accelerator "Rewrite Conf"
	$t.menuFile.localMenu add separator
	$t.menuFile.localMenu add command -image .pixExit -accelerator "Exit" -command "quit"
	#edit menu...
	$t.menuEdit.localMenu add command -label "Copy" -accelerator "<alt-c>" -command "copyText"
	$t.menuEdit.localMenu add command -label "Cut" -accelerator "<alt-x>" -command "cutText"
	$t.menuEdit.localMenu add command -label "Paste" -accelerator "<alt-v>" -command "pasteText"
	$t.menuEdit.localMenu add separator
	$t.menuEdit.localMenu add command -image .pixTime -accelerator "Date/Time" -command "insertDateTime"
	$t.menuEdit.localMenu add separator
	$t.menuEdit.localMenu add checkbutton -label "autoScroll" -variable autoScroll -onvalue 1 -offvalue 0 -selectcolor "lightgreen"
	$t.menuEdit.localMenu add separator
	$t.menuEdit.localMenu add command -image .pixPack -accelerator "Set CheckPoint" -command "push"
	$t.menuEdit.localMenu add command -image .pixUnPack -accelerator "Get CheckPoint" -command "pop"
	#languages menu...
	$t.menuLanguages.localMenu add checkbutton -label "autoSwitch" -variable autoSwitch -onvalue 1 -offvalue 0 -selectcolor "lightgreen"
	$t.menuLanguages.localMenu add separator
	$t.menuLanguages.localMenu add radiobutton -label "Txt" -variable currentFileType -value "Txt" -command "applyLanguage Txt" -selectcolor "lightgreen"
	#bookmarks menu...
	$t.menuBookmarks.localMenu add separator
	$t.menuBookmarks.localMenu add command -image .pixStatus -accelerator "Clear Historic" -command "clearHistoric"
	$t.menuBookmarks.localMenu add command -image .pixStatus -accelerator "Clear Bookmarks" -command "clearBookmarks"
	$t.menuBookmarks.localMenu add separator

menu .editMenu -font $font1 -tearoff 0 -relief raised -borderwidth 1 -activeborderwidth 0
.editMenu add command -label "Copy" -accelerator "<alt-c>" -command "copyText"
.editMenu add command -label "Cut" -accelerator "<alt-x>" -command "cutText"
.editMenu add command -label "Paste" -accelerator "<alt-v>" -command "pasteText"
.editMenu add separator
.editMenu add command -image .pixSave -accelerator "<ctrl-s>" -command "saveFile"
.editMenu add command -image .pixDiscard -accelerator "<ctrl-q>" -command "discardChanges"
.editMenu add command -image .pixExec -accelerator "<ctrl-r>" -command "execApp"
.editMenu add separator
.editMenu add command -image .pixPack -accelerator "Set CheckPoint" -command "push"
.editMenu add command -image .pixUnPack -accelerator "Get CheckPoint" -command "pop"
.editMenu add separator
.editMenu add command -image .pixExit -accelerator "<esc>" -command "quit"
bind .editMenu <Leave> {.editMenu unpost}

scrollbar  $v.ytxtScroll -orient vertical -width 10 -command "yScrollDemultiplex" -relief sunken -borderwidth 1
frame $v.local -borderwidth 1 -relief raised
set v2 "$v.local"
entry $v2.lineFinder -font $font1 -width 0 -borderwidth 1 -relief sunken -justify right
button $v2.lcLogo -image .pixWhere -borderwidth 0 -width 20 -command {lineFinder}
label $v2.lineStatus -text " z on-line " -relief sunken -borderwidth 1 -font $font3
label $v2.mssgStatus -text " ready and waiting for u :) " -relief sunken -borderwidth 1 -font $font1
button $v2.more -image .pixInfo -relief flat -width 16 -height 16 -borderwidth 0 -command {setTitle 1} -padx 0 -pady 0
button $v2.help -image .pixHelp -relief flat -width 16 -height 16 -borderwidth 0 -command {help} -cursor question_arrow -padx 0 -pady 0
button $v2.dateTime -image .pixTime -relief flat -width 16 -height 16 -borderwidth 0 -command {insertDateTime} -padx 0 -pady 0
scrollbar  $v2.xtxtScroll -orient horizontal -width 10 -command "$v.txtZone xview" -relief sunken -borderwidth 1
text $v.txtZone -yscrollcommand "yScrollMultiplex" -xscrollcommand "$v2.xtxtScroll set" -bg "gray90" -fg "black" -font $font2 -wrap none -selectbackground $skin_abg -selectforeground "#FFFFFF" -selectborderwidth 0 -relief flat -borderwidth 1 -highlightthickness 0 -state disabled -tabs $tab -cursor xterm -insertbackground "#000000"
set txt "$v.txtZone"
text $v.sideBar -width 5 -selectborderwidth 0 -borderwidth 1 -relief flat -font $font2 -highlightthickness 0 -state disabled
set side "$v.sideBar"

proc resetTimer {} {
	after cancel {localHighlighting;updateSideBar;updateLineStatus}
	after 100 {localHighlighting;updateSideBar;updateLineStatus}}

proc yScrollDemultiplex {cmd val {sup "-1"}} {
	global side txt
	if {$sup == "-1"} {
		$txt yview $cmd $val
		$side yview moveto [lindex [$txt yview] 0]
	} else {
		$txt yview $cmd $val $sup
		$side yview $cmd $val $sup}
	resetTimer}

proc yScrollMultiplex {xVal yVal} {
	global side txt v
	$v.ytxtScroll set $xVal $yVal
	$side yview moveto [lindex [$txt yview] 0]
	resetTimer}

#initial sidebar setup
proc setSideBar {} {
	global txt side skin_abg skin_afg
	$side configure -state normal
	$side delete 1.0 end
	set currentLineNumber [getLine end]
	for {set currentLine 1} {$currentLine < $currentLineNumber} {set currentLine [expr $currentLine+1]} {
		$side insert end "$currentLine\n"}
	$side delete end-1chars end
	$side tag configure "lineNumber" -justify right -rmargin 2 -wrap none
	$side tag add "lineNumber" 1.0 end
	$side configure -bg $skin_abg -fg $skin_afg -state disabled

	$side yview moveto [lindex [$txt yview] 0]}

#local modification
proc updateSideBar {} {
	global side txt
	set last [getSideLineNb]
	set diff [expr [getLine end]-$last]
	
	if {$diff>0} {
		$side configure -state normal
		$side insert end "\n"
		set i 0
		while {$i<$diff} {
			$side insert end "[expr $last+$i]\n"
			set i [expr $i+1]}
		$side delete end-1chars end
		$side tag add "lineNumber" $last.0 end
		$side configure -state disabled
	} elseif {$diff<0} {
		$side configure -state normal
		$side delete "end${diff}lines" end
		$side configure -state disabled}

	$side yview moveto [lindex [$txt yview] 0]}

pack $v2.lineFinder -side left
pack $v2.lcLogo -side left
pack $v2.lineStatus -side left
pack $v2.mssgStatus -side left
pack $v2.xtxtScroll -side left -expand 1 -fill x
pack $v2.dateTime -side left
pack $v2.help -side left
pack $v2.more -side left
pack $v2 -side bottom -fill x
pack $v.ytxtScroll -side right -fill y
pack $v.sideBar -side left -fill y
pack $v.txtZone -expand 1 -fill both

proc lineFinder {} {
	global v2 txt
	set lastWidth [$v2.lineFinder cget -width]
	if {$lastWidth>0} {
		$v2.lineFinder delete 0 end
		$v2.lineFinder configure -width 0
		focus $txt
	} else {
		$v2.lineFinder configure -width 10
	}
}

proc findLine {} {
	global v2 txt
	set lineToFind [$v2.lineFinder get]
	catch {
		$txt see $lineToFind.0
		$txt tag configure "gotLine" -background pink
		$txt tag add "gotLine" $lineToFind.0 $lineToFind.0+1lines
		after 1000 $txt tag delete "gotLine"}}

#bottom toolbar tooltips
bind $v2.dateTime <Enter> "updateMssgStatus insertDateTime"
bind $v2.dateTime <Leave> "updateMssgStatus restore"
bind $v2.help <Enter> "updateMssgStatus help"
bind $v2.help <Leave> "updateMssgStatus restore"
bind $v2.more <Enter> "updateMssgStatus more"
bind $v2.more <Leave> "updateMssgStatus restore"

#<FILELIST>
scrollbar  $l.listScroll -orient vertical -width 10 -command "$l.fileList yview" -borderwidth 1 -relief sunken
listbox $l.fileList -width $fileListWidth -yscrollcommand "$l.listScroll set" -selectbackground $skin_abg -selectborderwidth 0 -font $font1 -selectmode single -borderwidth 1 -relief sunken
pack $l.listScroll -side right -expand 1 -fill y
pack $l.fileList -side right -expand 1 -fill y
bind $l.fileList <Enter> {updateMssgStatus "[expr [$l.fileList size]-2] items"}
bind $l.fileList <Motion> {updateMssgStatus "[expr [$l.fileList size]-2] items" 0}
bind $l.fileList <Leave> "updateMssgStatus restore"

#editor events
bind $txt <ButtonPress-3> {.editMenu post [expr %X-15] [expr %Y-15]}
bind $txt <ButtonRelease-1> {hilightBr;updateLineStatus}
bind $txt <Alt-c> {copyText}
bind $txt <Alt-v> {pasteText}
bind $txt <Alt-x> {cutText}
#set keys {
#	a z e r t y u i o p q s d f g h j k l m w x c v b n 1 2 3 4 5 6 7 8 9
#	comma semicolon colon exclam question period slash section ugrave
#	percent dead_circumflex dead_diaeresis dollar sterling currency ampersand
#	eacute quotedbl apostrophe parenleft minus egrave underscore scedilla agrave
#	parenright equal asterisk degree plus mu onesuperior asciitilde numbersign
#	braceleft bracketleft bar grave backslash asciicircum at bracketright
#	braceright twosuperior notsign space BackSpace Return Tab less greater
#	Delete}
set keys {
	a z e r t y u i o p q s d f g h j k l m w x c v b n 1 2 3 4 5 6 7 8 9
	comma semicolon colon exclam question period slash section ugrave
	percent dollar sterling currency ampersand
	eacute quotedbl parenleft minus egrave underscore scedilla agrave
	parenright equal asterisk degree plus mu onesuperior asciitilde numbersign
	braceleft bracketleft bar backslash asciicircum at bracketright
	braceright twosuperior notsign space BackSpace Return Tab less greater
	Delete}
foreach {keyName} $keys {
	bind $txt <KeyRelease-$keyName> {resetTimer}}
bind $txt <KeyRelease> {hilightBr;updateLineStatus;updateSideBar}
bind $txt <F1> {indent}
bind $txt <F2> {unIndent}
bind $txt <Alt-t> {insertTag}
#select a new file
bind $l.fileList <ButtonRelease-1> {if {[$l.fileList curselection]!=""} {switchFile [$l.fileList get [$l.fileList curselection]]}}
#try to answer a user request
bind $t.data <KeyRelease-Return> {answerRequest}
#line finder
bind $v2.lineFinder <KeyRelease-Return> {findLine}
#sideBar
bind $v.sideBar <ButtonPress-1> {updateSideBar}
bind $v.sideBar <Leave> {updateSideBar}
#all
bind all <Escape> {quit}
bind all <Control-s> {saveFile}
bind all <Control-q> {discardChanges}
bind all <Control-r> {execApp}
bind all <Control-w> {setTitle 1}
bind all <Alt-n> {exec wish $home/z.tcl &}

pack $t -side top -fill x
pack $v -side top -expand 1 -fill both
scale .divider -orient horizontal -borderwidth 0 -relief flat -showvalue false -highlightthickness 0 -width 8 -sliderlength 20 -sliderrelief raised
pack .divider -side bottom -fill x
pack $l -side left -fill y
pack $r -side left -expand 1 -fill both
pack $m -expand 1 -fill both
wm geometry . $usergeometry
wm title . $id
wm withdraw .

proc divide {val} {
	global l
	if {$val>0} {
	$l.fileList configure -width $val}
}
.divider configure -from 0 -to [.divider cget -length] -command "divide"
.divider set [$l.fileList cget -width]

#<INFOBOX>
toplevel .box
frame .box.sub -borderwidth 0
label .box.sub.img -image .pixInfo -height 20 -width 20
label .box.sub.mssg -text "Hello World" -font $font4
button .box.agree -text "OK!" -font $font1 -borderwidth 1 -command {wm withdraw .box;wm deiconify .}
pack .box.sub.img -side left
pack .box.sub.mssg -side left -expand 1 -fill both
pack .box.sub -side top -expand 1 -fill both
pack .box.agree -side top
wm resizable .box 0 0
wm title .box "ZZZzzz..."
wm withdraw .box
bind .box <KeyRelease-Return> {.box.agree invoke}

proc about {} {
	global txt
	wm deiconify .about
	wm geometry .about "500x300+[expr [winfo vrootwidth .]/2-225]+[expr [winfo vrootheight .]/2-150]"
	focus .about
	raise .about
	after 2000 {wm withdraw .about}}

toplevel .about
label .about.logo -image .pixZ -borderwidth 0 -bg "#000000"
pack .about.logo -expand 1 -fill both
wm overrideredirect .about 1
wm resizable .about 0 0
wm withdraw .about

bind .about <ButtonPress-1> {wm withdraw .about;wm deiconify .}
