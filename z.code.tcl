set modules [list]

set typeList [list "^.*$" "Txt" ""]
set currentFileName ""
set fileDirectory ""
set currentFileType ""
set currentApp ""
set keyWords [list]
set ranges [list]
set comments [list]
set historic [list]
set buffer ""
set backup ""

proc loadModules {} {
	global modules home id
	#probing
	foreach {modName} [glob -nocomplain "mod_*.tcl"] {
		if {[catch {
			source $home/$modName
			set module [file rootname $modName]
			set modules [linsert $modules 0 $module]
			load_$module
			puts stdout "$id: \[$module\] module registered and loaded."
			} errMsg]!=0} {
			puts stdout "$id: FAILURE:Unable to load module $modName ($errMsg)\n\tThis module isn't z-std compliant! :)" }}}

proc quit {} {
	if {[fileHasChanged]} {
		infoBox "-WARNING-\nfile has been modified, save it or discard changes" "err"
	} else {
		updateConfFile
		exit}}

proc setTitle {{type 0}} {
	global txt currentFileName fileDirectory modules id
	if {[string length $currentFileName]==0} {return}
	if {$type==0} {
		wm title . "$currentFileName ([file size "$fileDirectory/$currentFileName"] bytes) - $id"
	} elseif {$type==1} {
		set bufferSize [string length [$txt get 1.0 end-1chars]]
		set tag ""
		if {[fileHasChanged]} {set tag "file has changed!"}
		wm title . "$tag $fileDirectory/$currentFileName ([file size "$fileDirectory/$currentFileName"]/$bufferSize bytes) - $id"
		after 3000 {setTitle 2}
	} elseif {$type==2} {
		wm title . "[llength $modules] module(s) registered: $modules - $id"
		after 2000 setTitle
	} elseif {$type==3} {
		wm title . "~File Saved~ - $id"
		after 2000 setTitle}}

proc loadFileList {} {
	global l
	$l.fileList delete 0 end
	set fileList [lsort -decreasing [glob -nocomplain "*" ".*"]]
	foreach {fileName} $fileList {
		if {[file isdirectory $fileName]} {
			$l.fileList insert 0 "$fileName/"
		} else {
			$l.fileList insert 0 $fileName}}}

proc switchFile {fileName} {
	if {[file isdirectory $fileName]} {
		if {[file readable $fileName]} {
			cd $fileName
			loadFileList
		} elseif {[file executable $fileName]} {
			infoBox "-ACCESS DENIED-\nI cannot open this directory! (not readable)\nHowever, It can be crossed:\n if u know one of its subfolder name enter the absolute path in your terminal and recall me there!" "acc"
			return 1
		} else {
			infoBox "-ACCESS DENIED-\nthis folder is neither readable nor crossable, there's nothing I can do!" "acc"
			return 1}
	} else {
		if {[fileHasChanged]} {
			infoBox "-ERROR-\nPlease save this file or discard changes before working on another" "err"
			return 1
		} elseif {![file exists $fileName]} {
			infoBox "-ERROR-\nthis file no longer exists" "err"
			return 1
		} elseif {! [file readable $fileName]} {
			infoBox "-ACCESS DENIED-\nThis file isn't readable\nI cannot do anything, but try to hack the root account and then recall me :)" "acc"
			return 1}
		openFile $fileName
		return 0}}

proc copyText {} {
	global currentFileName txt buffer
	if {[string length $currentFileName]==0} {return 1}
	if {[catch {
		set buffer [$txt get sel.first sel.last]} errMsg]!=0} {
			set buffer ""
			return 1}
	return 0}

proc cutText {} {
	global currentFileName txt buffer
	if {[string length $currentFileName]==0} {return 1}
	if {[catch {
		set buffer [$txt get sel.first sel.last]
		$txt delete sel.first sel.last} errMsg]!=0} {
			set buffer ""
			return 1}
	return 0}

proc pasteText {} {
	global currentFileName txt buffer
	if {[string length $currentFileName]==0} {return 1}
	$txt insert insert $buffer
	updateSideBar
	return 0}

#synchronize the sidebar and the text
proc sync {} {
	loadFileList
	setSideBar
	showFileStatus
	setTitle}

#resynchronize almost everything
proc resync {{lvl 0}} {
	loadFileList
	updateSideBar
	showFileStatus
	setTitle $lvl}

proc openFile {fileName} {
	global txt currentFileName fileDirectory
	addInHistoric
	$txt configure -state normal
	set currentFileName $fileName
	set fileDirectory [pwd]
	$txt delete 1.0 end
	if {[catch {
		set pFile [open $fileName "r"]} errMsg]!=0} {
	infoBox "Unable to open this file:\n$errMsg" "err"
	return 1}
	while {[eof $pFile]==0} {
			gets $pFile aLine
			$txt insert end "$aLine\n"}
	$txt delete end-1chars end
	close $pFile
	#info update
	typeFinder
	sync
	return 0}

proc newFile {} {
	global txt t defaultName id
	set fileName [$t.data get]
	if {[file exists $fileName]==1} {
		infoBox "-ERROR-\nThis file already exists try\nto give me another name!..." "err"
		return 1}	
	if {[string length $fileName]==0} {
		puts stdout "$id: WARNING, new file creation, using default filename ($defaultName)."
		set fileName $defaultName}
	set baseFileName $fileName
	set patch 2
	while {[file exists $fileName]==1} {
		set fileName [file rootname $baseFileName].$patch[file extension $baseFileName]
		incr patch}
	close [open $fileName "w"]
	return [switchFile $fileName]}

proc newFolder {} {
	global txt t  id
	set folderName [$t.data get]
	if {[file exists $folderName]==1} {
		infoBox "-ERROR-\nThis folder already exists try\nto give me another name!..." "err"
		return 1}	
	if {[string length $folderName]==0} {
		puts stdout "$id: Please give me a folder name! (operation aborted)."
		return 1}
	if {![file writable [pwd]]} {
		infoBox "-PERMISSION DENIED-\nCannot create $folderName" "acc"
		return 1}
	exec mkdir $folderName
	loadFileList}

proc saveFile {} {
	global txt t currentFileName fileDirectory
	set currentFile "$fileDirectory/$currentFileName"
	if {[string length $currentFile]==0} {
		infoBox "-ERROR-\nThere's no opened file, select a item in the list or create a new one." "err"
		return 1}
	#save...
	set pFile [open $currentFile w+]
	puts -nonewline $pFile [$txt get 1.0 "end-1chars"]
	close $pFile
	resync 3
	return 0}

proc fileHasChanged {} {
	global txt currentFileName fileDirectory id
	set currentFile "$fileDirectory/$currentFileName"

	if {$currentFile=="/"} {return 0}

	if {![file exists $currentFile]} {
		puts stdout "$id: WARNING! $currentFile has been moved/deleted...\n\tNevermind! I drop the buffer :("
		return 0}

	set lastSize 0
	set pFile 0
	set fileContent "";
	if {[string length $currentFileName]!=0} {
		#this is boring but needed cause of the redmond::window$ '\r' chars
		set pFile [open $currentFile "r"]
		set fileContent [read $pFile [file size $currentFile]]
		set lastSize [string length $fileContent]}

	set currentSize [string length [$txt get 1.0 end-1chars]]

	if {$currentSize!=$lastSize} {
		return 1
	} else {
		#full check
		if {![string compare $fileContent [$txt get 1.0 end-1chars]]} {
			return 0;
		} else {
			return 1;
		}
	}
}

proc discardChanges {} {
	global txt side currentFileName fileDirectory 

	cd $fileDirectory
	openFile $currentFileName}

proc getLine {{val insert}} {
	global txt
	set tmp [$txt index $val]
	return [string range $tmp 0 [expr [string first "." $tmp]-1]]}

proc getSideLineNb {} {
	global side
	set tmp [$side index end]
	return [string range $tmp 0 [expr [string first "." $tmp]-1]]}

proc getCol {{val "nop"}} {
	global txt
	if {[string compare $val "nop"]==0} {
		set tmp [$txt index insert]} else {
		set tmp [$txt index $val]}
	return [string range $tmp [expr [string first "." $tmp]+1] end]}
	
proc updateLineStatus {} {
	global v2 currentLineNb line
	$v2.lineStatus configure -text " (Row) [getLine] / [expr [getLine end]-1] - (Col) [getCol nop] "}

proc showFileStatus {} {
	global currentFileName currentFileType currentApp
	updateLineStatus
	updateMssgStatus2 " Playing with << [string range [file tail $currentFileName] 0 15] >> ( $currentFileType / $currentApp ) "}

set oldMssg ""
proc updateMssgStatus {mssg {backup 1}} {
	global v2 oldMssg
	if {[string compare $mssg "restore"]==0} {
		$v2.mssgStatus configure -text $oldMssg} else {
	if {$backup=="1"} {set oldMssg [$v2.mssgStatus cget -text]}
	$v2.mssgStatus configure -text $mssg}}

proc updateMssgStatus2 {mssg} {
	updateMssgStatus $mssg
	updateMssgStatus $mssg }

proc find {str} {
	global currentFileName
	if {[string length $currentFileName]==0} {return 1}
	global txt t font4
	$txt tag delete "find"
	if {[string compare $str ""]==0} {
		updateMssgStatus2 "Nothing to search."
		infoBox "Give me something to search...\nUse the toolbar entry box for that..." "info"
		return 1}
	if {[string compare [string index $str 0] \-]==0} {
		updateMssgStatus2 "String to search starts with a \-, I cannot handle it!"
		return 1}
	set occ 0
	set findWord [$txt search $str [expr round([lindex [$txt yview] 0]*[getLine end])].0 end]
	if {[string length $findWord]==0} {
		updateMssgStatus2 "Nothing found."
		infoBox "$str : string not found...sorry\n\nTry something else and remember it's exact matching." "info"
		return 1}
	$txt tag configure "find" -background "lightgreen" -foreground "#000000" -relief groove -borderwidth 2 -font $font4
	$txt see $findWord
	set currentIndex $findWord
	while {[string length $findWord]>0} {
		$txt tag add "find" $findWord $findWord+[string length $str]chars
		set currentIndex [getLine $findWord].[expr [getCol $findWord]+[string length $str]]
		incr occ
		set findWord [$txt search $str $currentIndex end]}
	updateMssgStatus2 "$occ string(s) found."
	return 0}

proc help {} {
	global home helpFile
	set folder [pwd]
	cd $home
	switchFile $helpFile
	switchFile $folder}

proc typeFinder {} {
	global autoSwitch currentFileType currentFileName currentApp typeList
	if {$autoSwitch==1} {
		foreach {typeRegExp modName appLinked} $typeList {
			if {[regexp $typeRegExp $currentFileName]==1} {
				set currentFileType $modName
				set currentApp $appLinked
				applyLanguage $modName

				return 0}}
		set currentFileType "Txt"
		set currentApp ""
		applyLanguage Txt}

	return 0}

proc addType {typeRegExp moduleName appLinked} {
	global typeList t
	$t.menuLanguages.localMenu add radiobutton -label $moduleName -variable currentFileType -value $moduleName -command "applyLanguage $moduleName" -selectcolor "lightgreen"
	set typeList [linsert $typeList 0 $typeRegExp $moduleName $appLinked]}

proc applyLanguage {lang} {
	global id currentFileName keyWords ranges comments
	if {[string length $currentFileName]==0} {return 1}
	unassignAllTags
	if {[catch {
		apply_$lang} errMsg]!=0} {
	puts stdout "$id: ERROR! Language apply function failed ($lang), I need a module for that! (STFW :)"}
	localHighlighting
	return 0}

#default language
proc apply_Txt {} {
	global keyWords ranges comments
	set keyWords [list]
	set ranges [list]
	set comments [list]}

proc localHighlighting {} {
	global txt
	#first, bound computation
	set from	[expr round([lindex [$txt yview] 0]*[getLine end])]
	set to [expr round([lindex [$txt yview] 1]*[getLine end]+2)]
	#second, highlighting
	unassignAllTags
	assignKeyWordTags $from $to
	assignRangeTags $from $to
	assignCommentTags $from $to}

proc unassignAllTags {} {
	global txt keyWords ranges comments
	foreach {keyWordName keyWordColor underlined} $keyWords {
		$txt tag delete "keyWord_$keyWordName"}
	foreach {rangeStart rangeEnd rangeColor} $ranges {
		$txt tag delete "range_$rangeStart$rangeEnd"}
	foreach {commentStart commentColor} $comments {
		$txt tag delete "comment_$commentStart"}}

proc assignKeyWordTags {from to} {
	global txt keyWords font4
	if {[llength $keyWords]==0} {return 0}

	foreach {keyWordName keyWordColor underlined} $keyWords {
	$txt tag configure "keyWord_$keyWordName" -foreground $keyWordColor -font $font4 -underline $underlined
	set index "$from.0"
	set size [string length $keyWordName]
	set keyWordIndex [$txt search $keyWordName $index "$to.0"]
	while {[string length $keyWordIndex]>0} {
		if {[thereIsNothingAround $keyWordIndex $size] && [llength [$txt tag names $keyWordIndex]]==0} {
			$txt tag add "keyWord_$keyWordName" $keyWordIndex "$keyWordIndex+$size chars"}
		set index [getLine $keyWordIndex].[expr [getCol $keyWordIndex]+$size+1]
		set keyWordIndex [$txt search $keyWordName $index "$to.0"]}}}

proc assignCommentTags {from to} {
	global txt comments font4
	if {[llength $comments]==0} {return 0}

	set last [getLine end]
	foreach {commentStart commentColor} $comments {
		$txt tag configure "comment_$commentStart" -foreground $commentColor -font $font4 -lmargin1 2
		set index "$from.0"
		set commentStartIndex [$txt search $commentStart $index "$to.0"]
		while {[string length $commentStartIndex]>0 && [getLine $index]<$last} {
			$txt tag add "comment_$commentStart" $commentStartIndex "$commentStartIndex lineend"
			set index [expr [getLine $commentStartIndex]+1].0
			set commentStartIndex [$txt search $commentStart $index "$to.0"]}}}

proc assignRangeTags {from to} {
	global txt ranges font2
	if {[llength $ranges]==0} {return 0}

	foreach {rangeStart rangeEnd rangeColor} $ranges {
		$txt tag configure "range_$rangeStart$rangeEnd" -foreground $rangeColor -font $font2
		set index "$from.0"
		set rangeStartIndex [$txt search $rangeStart $index "$to.0"]
		if {[string length $rangeStartIndex]>0} {
			set rangeEndIndex [$txt search $rangeEnd [getLine $rangeStartIndex].[expr [getCol $rangeStartIndex]+1] "$to.0"]
			while {[string length $rangeStartIndex]>0 && [string length $rangeEndIndex]>0} {
				$txt tag add "range_$rangeStart$rangeEnd" $rangeStartIndex [getLine $rangeEndIndex].[expr [getCol $rangeEndIndex]+1]
				set index [getLine $rangeEndIndex].[expr [getCol $rangeEndIndex]+1]
				set rangeStartIndex [$txt search $rangeStart $index "$to.0"]
				if {[string length $rangeStartIndex]>0} {
					set rangeEndIndex [$txt search $rangeEnd [getLine $rangeStartIndex].[expr [getCol $rangeStartIndex]+1] "$to.0"]}}}}}

proc thereIsNothingAround {here size} {
	global txt
	if {[getCol $here]==0} {return 1}
	set prevCar [$txt get $here-1chars]
	set nextCar [$txt get "$here+${size}chars"]
	if {[string compare $prevCar \-]==0} {return 0}
	if {[string compare $nextCar \-]==0} {return 0}
	if {[string compare $prevCar "."]==0} {return 0}
	if {[string compare $nextCar "."]==0} {return 0}
	switch -regexp $prevCar {
			"[a-z]|[A-Z]|0|1|2|3|4|5|6|7|8|9|_" {return 0}}
	switch -regexp $nextCar {
			"[a-z]|[A-Z]|0|1|2|3|4|5|6|7|8|9|_" {return 0}}
	return 1}

proc hilightBr {} {
	global txt
	$txt tag delete "hilightBr"
	set prevCar [$txt get insert-1chars]
	if {[string compare $prevCar \-]==0} {return 1}
	if {[catch {
	switch $prevCar {
		"\{" {highlightNext "\{" "\}" "Red1"}
		"\}" {highlightPrev "\{" "\}" "Red1"}
		"\(" {highlightNext "\(" "\)" "Red2"}
		"\)" {highlightPrev "\(" "\)" "Red2"}
		"\[" {highlightNext "\[" "\]" "Red3"}
		"\]" {highlightPrev "\[" "\]" "Red3"}}} errMsg]!=0} {return 1}}

proc highlightNext {startChar endChar color} {
	global txt font4 autoScroll
	set startIndex [$txt index insert-1chars]
	set endIndex $startIndex
	while {[string length $startIndex]!=0} {
		set endIndex [$txt search $endChar $endIndex+1chars end]
		if {[string length $endIndex]>0} {
			set startIndex [$txt search $startChar $startIndex+1chars end]
			if {[string length $startIndex]>0} {
				set sl [getLine $startIndex]
				set sc [getCol $startIndex]
				set el [getLine $endIndex]
				set ec [getCol $endIndex]
				if {$sl>$el || ($sl==$el && $sc>$ec)} {set startIndex ""}}}}
	$txt tag configure "hilightBr" -background $color -foreground "#FFFFFF" -borderwidth 0 -font $font4
	if {[string length $endIndex]!=0} {
		$txt tag add "hilightBr"  insert-1chars insert
		$txt tag add "hilightBr" $endIndex $endIndex+1chars
		if {$autoScroll==1} {$txt see $endIndex}}}

proc highlightPrev {startChar endChar color} {
	global txt font4 autoScroll
	set startIndex [$txt index insert-1chars]
	set endIndex $startIndex
	while {[string length $endIndex]!=0} {
		set startIndex [$txt search -backwards $startChar $startIndex 1.0]
		if {[string length $startIndex]>0} {
			set endIndex [$txt search -backwards $endChar $endIndex 1.0]
			if {[string length $endIndex]>0} {
				set sl [getLine $startIndex]
				set sc [getCol $startIndex]
				set el [getLine $endIndex]
				set ec [getCol $endIndex]
				if {$el<$sl || ($sl==$el && $ec<$sc)} {set endIndex ""}}}}
	$txt tag configure "hilightBr" -background $color -foreground "#FFFFFF" -borderwidth 0 -font $font4
	if {[string length $startIndex]!=0} {
		$txt tag add "hilightBr"  insert-1chars insert
		$txt tag add "hilightBr" $startIndex $startIndex+1chars
		if {$autoScroll==1} {$txt see $startIndex}}}

proc infoBox {mssg type} {
	.box.sub.mssg configure -text \n$mssg\n
	switch $type {
		"err" {.box.sub.img configure -image .pixAlert}
		"info" {.box.sub.img configure -image .pixInfo}
		"acc" {.box.sub.img configure -image .pixKey}
		default {.box.sub.img configure -image .pixAbout}}
	wm withdraw .
	wm deiconify .box
	wm geometry .box "+[winfo rootx .]+[winfo rooty .]"}

proc push {} {
	global backup txt
	set backup [$txt get 1.0 end]}

proc pop {} {
	global backup txt
	$txt delete 1.0 end
	$txt insert end $backup
	setFileHasChanged
	typeFinder
	showFileStatus}

proc insertStr {str} {
	global currentFileName txt
	if {[string length $currentFileName]==0} {return 1}
	$txt insert insert $str
	return 0
}

proc execApp {} {
	global currentFileName currentApp fileDirectory
	if {[string length $currentFileName]==0 || [string length $currentApp]==0} {return 1}
	$currentApp $fileDirectory/$currentFileName
	return 0}

proc printFile {} {
	global currentFileName
	if {[string length $currentFileName]==0} {return 1}
	infoBox "Sending $currentFileName to default printer..." "info"
	exec lpr < $currentFileName &
	return 0}

proc insertDateTime {} {
	return [insertStr [clock format [clock seconds]]]}

proc rewriteConfFile {} {
	global home
	set pFile [open "$home/z.conf.tcl" "w+"]
	set buffer "
	set skin #507090
	set skin_abg #6090C0
	set skin_afg #FFFFFF
	set font1 -adobe-helvetica-medium-r-normal-*-*-80-*-*-p-*-iso10646-1
	set font2 -adobe-helvetica-medium-r-normal-*-*-100-*-*-p-*-iso10646-1
	set font3 -adobe-helvetica-bold-r-normal-*-*-80-*-*-p-*-iso10646-1
	set font4 -adobe-helvetica-bold-r-normal-*-*-100-*-*-p-*-iso10646-1
	set tab 20
	set defaultName Scratch.z
	set autoSwitch 1
	set autoScroll 1
	set helpFile Change.log
	set fileListWidth 14
	set usergeometry \"600x400+10+10\""
	puts $pFile $buffer
	puts stdout "$id: configuration file rewritten."
}

proc updateConfFile {} {
	global home id l autoSwitch autoScroll fileListWidth
	set pFile [open "$home/z.conf.tcl" "r+"]
	set buffer [read -nonewline $pFile]
	regsub "set autoSwitch ." $buffer "set autoSwitch $autoSwitch" buffer
	regsub "set autoScroll ." $buffer "set autoScroll $autoScroll" buffer
	regsub "set fileListWidth (0|1|2|3|4|5|6|7|8|9)*" $buffer "set fileListWidth [$l.fileList cget -width]" buffer
	regsub "set usergeometry \".*\"" $buffer "set usergeometry \"[winfo geometry .]\"" buffer
	set pFile [open "$home/z.conf.tcl" "w+"]
	puts $pFile $buffer
	puts stdout "$id: configuration file updated."
}

proc indent {} {
	global txt;
	if {[$txt tag ranges "sel"]==""} {return 1}

	set currentLine [getLine [lindex [$txt tag ranges "sel"] 0]]
	set lastLine [getLine [lindex [$txt tag ranges "sel"] 1]]

	while {$currentLine!=$lastLine} {
		$txt insert $currentLine.0 "	"
		incr currentLine
	}
	$txt insert $currentLine.0 "	"
}

proc unIndent {} {
	global txt;
	if {[$txt tag ranges "sel"]==""} {return 1}

	set currentLine [getLine [lindex [$txt tag ranges "sel"] 0]]
	set lastLine [getLine [lindex [$txt tag ranges "sel"] 1]]

	while {$currentLine!=$lastLine} {
		if {[$txt get $currentLine.0 $currentLine.1]=="	" || [$txt get $currentLine.0 $currentLine.1]==" "} {$txt delete $currentLine.0 $currentLine.1}
		incr currentLine
	}
	if {[$txt get $currentLine.0 $currentLine.1]=="	" || [$txt get $currentLine.0 $currentLine.1]==" "} {$txt delete $currentLine.0 $currentLine.1}
}

proc addInHistoric {} {
	global t currentFileName fileDirectory historic txt
	set currentFile "$fileDirectory/$currentFileName"
	if {$currentFileName==""} {return 1}
	set index [lsearch $historic $currentFile]
	if {$index != -1} {
		$t.menuBookmarks.localMenu delete $index
		set historic [lreplace $historic $index $index]
	}
	set historic [linsert $historic 0 $currentFile]
	$t.menuBookmarks.localMenu insert 0 command -image .pixEdit -accelerator "$currentFileName" -command "cd $fileDirectory;switchFile $currentFileName;$txt yview moveto [lindex [$txt yview] 0]"
	return 0
}

proc clearHistoric {} {
	global t historic
	set historic [list]
	while {[$t.menuBookmarks.localMenu type 0]!="separator"} {
		$t.menuBookmarks.localMenu delete 0
	}
	return 0
}

proc clearBookmarks {} {
	global t historic
	set historic [list]
	while {[$t.menuBookmarks.localMenu type last]!="separator"} {
		$t.menuBookmarks.localMenu delete last
	}
	return 0
}

proc bookmark {} {
	global t currentFileName fileDirectory txt
	if {$currentFileName==""} {return 1}
	$t.menuBookmarks.localMenu add command -image .pixFavorite -accelerator "$currentFileName " -command "cd $fileDirectory;switchFile $currentFileName;$txt yview moveto [lindex [$txt yview] 0]"
	return 0
}

proc insertTag {} {
	global home id currentFileName
	set tagFile "$home/my.tag"
	if {![file exists $tagFile]} {
		puts stdout "$id: file '$tagFile' not found, I cannot do anything"
		return 0}

	set pFile [open $tagFile "r"]
	set tag [read $pFile [file size $tagFile]]

	regsub "%file%" $tag  "$currentFileName" tag
	regsub "%pwd%" $tag [pwd] tag
	regsub "%date%" $tag  [clock format [clock seconds] -format "%d.%m.%Y"] tag
	return [insertStr $tag]}

proc answerRequest {} {
	global t id
	if {[$t.data get]==""} {return 1}

	set requestType [string index [$t.data get] 0]
	switch $requestType {
		"/" {find [string range [$t.data get] 1 end]}
		":" {[string range [$t.data get] 1 end]}
		"!" {exec [string range [$t.data get] 1 end] &}
		default {puts stdout "$id: '$requestType' unknown request type (operation aborted)."}}}
