image create photo .pixGoals
.pixGoals configure -file "gif/goals.gif"
image create photo .pixTag
.pixTag configure -file "gif/html.gif"

toplevel .advSearchBox
wm title .advSearchBox "Advanced Search Box"
label .advSearchBox.img1 -image .pixGoals

frame .advSearchBox.sourceFrame
label .advSearchBox.sourceFrame.img2 -image .pixTag
label .advSearchBox.sourceFrame.sourceLbl -text "String/Regexp to look for:" -justify left -font "-adobe-helvetica-medium-r-normal-*-*-100-*-*-p-*-iso10646-1"
pack .advSearchBox.sourceFrame.img2 -side left
pack .advSearchBox.sourceFrame.sourceLbl -side right -fill x

entry .advSearchBox.source -borderwidth 1 -relief ridge

frame .advSearchBox.sourceMgmt
button .advSearchBox.sourceMgmt.searchButton -text "Search" -font "-adobe-helvetica-bold-r-normal-*-*-80-*-*-p-*-iso10646-1" -command {searchFor}
button .advSearchBox.sourceMgmt.nextButton -text "Next" -font "-adobe-helvetica-bold-r-normal-*-*-80-*-*-p-*-iso10646-1" -command {searchFor next}
button .advSearchBox.sourceMgmt.prevButton -text "From Cur. Pos." -font "-adobe-helvetica-bold-r-normal-*-*-80-*-*-p-*-iso10646-1" -command {searchFor cur}

frame .advSearchBox.targetFrame
label .advSearchBox.targetFrame.img1 -image .pixGoals
label .advSearchBox.targetFrame.targetLbl -text "Replacement string:" -justify left -font "-adobe-helvetica-medium-r-normal-*-*-100-*-*-p-*-iso10646-1" 
pack .advSearchBox.targetFrame.img1 -side left
pack .advSearchBox.targetFrame.targetLbl -side right -fill x

entry .advSearchBox.target -borderwidth 1 -relief ridge

frame .advSearchBox.targetMgmt
button .advSearchBox.targetMgmt.replaceButton -text "Replace All!"  -font "-adobe-helvetica-bold-r-normal-*-*-80-*-*-p-*-iso10646-1" -command {replace [.advSearchBox.source get] [.advSearchBox.target get]}
frame .advSearchBox.boxMgmt
label .advSearchBox.boxMgmt.copyright -text "By d4rkir0n@January 2004 / v1.0a" -font "-adobe-helvetica-medium-r-normal-*-*-80-*-*-p-*-iso10646-1"
button .advSearchBox.boxMgmt.ok -text "ok" -font "-adobe-helvetica-medium-r-normal-*-*-80-*-*-p-*-iso10646-1" -command {wm withdraw .advSearchBox}

pack .advSearchBox.sourceMgmt.searchButton -side right
pack .advSearchBox.sourceMgmt.prevButton -side right
pack .advSearchBox.sourceMgmt.nextButton -side right
pack .advSearchBox.sourceFrame -side top -fill x
pack .advSearchBox.source -side top -fill x
pack .advSearchBox.sourceMgmt -side top -fill x
pack .advSearchBox.targetFrame -side top -fill x
pack .advSearchBox.target -side top -fill x
pack .advSearchBox.targetMgmt.replaceButton -side right
pack .advSearchBox.targetMgmt -side top -fill x
pack .advSearchBox.boxMgmt.ok -side right
pack .advSearchBox.boxMgmt.copyright -side right -fill x
pack .advSearchBox.boxMgmt -side top -fill x
wm withdraw .advSearchBox

bind .advSearchBox.source <KeyRelease-Return> {searchFor next}


proc load_mod_search {} {
	global t txt pos
	set pos "1.0"
	$t.menuEdit.localMenu add separator
	$t.menuEdit.localMenu add command -image .pixGoals -command "AdvSearch" -accelerator "Search...<Ctrl-f>"
	bind . <Control-f> {AdvSearch}}

proc AdvSearch {} {
	wm geometry .advSearchBox "+[expr [winfo rootx .]-10]+[expr [winfo rooty .]-10]"
	wm deiconify .advSearchBox}

proc searchFor {{src "init"}} {
	global txt skin_abg pos
	$txt tag delete "searchFor"
	if {$src=="init"} {
		#from the beginning
		set length 1
		set pos [$txt search -forwards -regexp -count length [.advSearchBox.source get] 1.0 end]
		if {$pos==""} {set pos 1.0;return}
		$txt tag configure "searchFor" -background $skin_abg
		$txt tag add "searchFor" $pos $pos+${length}chars
		$txt see $pos
		set pos $pos+${length}chars
	} elseif {$src=="next"} {
		#next
		set length 1
		set pos [$txt search -forwards -regexp -count length [.advSearchBox.source get] $pos end]
		if {$pos==""} {set pos 1.0;return}
		$txt tag configure "searchFor" -background $skin_abg
		$txt tag add "searchFor" $pos $pos+${length}chars
		$txt see $pos
		set pos $pos+${length}chars
	} else {
		#from current position
		set pos [$txt index insert]
		searchFor next}}

proc replace {src tgt} {
	global txt
	set buffer [$txt get 1.0 end]
	regsub -all $src $buffer $tgt buffer
	$txt delete 1.0 end
	$txt insert 1.0 $buffer
	fullSync}