proc load_mod_tcltk {} {addType "^.*\.tcl$" "TclTk" "execWish"}

proc execWish {fileName} {
	exec wish $fileName & }

proc apply_TclTk {} {
	global keyWords ranges comments

	set keyWords {
		after #000000 0
		append #000000 0
		array #000000 0
		break #000000 0
		case #000000 1
		catch #000000 0
		clock #000000 0
		close #000000 0
		concat #000000 0
		continue #000000 0
		default #000000 0
		eof #000000 0
		else #000000 1
		elseif #000000 1
		error #000000 0
		eval #000000 0
		expr #000000 0
		fblocked #000000 0
		fileevent #000000 0
		flush #000000 0
		for #000000 1
		foreach #000000 1
		format #000000 0
		gets #000000 0
		global #000000 0
		history #000000 0
		if #000000 1
		incr #000000 0
		info #000000 0
		interp #000000 0 
		join #000000 0
		lappend #000000 0
		lindex #000000 0
		linsert #000000 0
		list #000000 0
		llength #000000 0
		lower #000000 0
		lrange #000000 0
		lreplace #000000 0
		lsearch #000000 0
		lsort #000000 0
		package #000000 0
		pid #000000 0
		proc purple 0
		puts #000000 0
		read #000000 0
		rename #000000 0
		return #000000 0
		scan #000000 0
		seek #000000 0
		set #000000 0
		split #000000 0
		string #000000 0
		subst #000000 0
		switch #000000 1
		tell #000000 0
		trace #000000 0
		unset #000000 0
		update #000000 0
		uplevel #000000 0
		upvar #000000 0
		vwait #000000 0
		while #000000 1
		cd #000000 0
		exec #000000 0
		exit #000000 0
		fconfigure #000000 0
		file #000000 0
		glob #000000 0
		load #000000 0
		open #000000 0
		pwd #000000 0
		socket #000000 0
		source #000000 0
		vwait #000000 0
		canvas red 0
		entry red 0
		listbox red 0
		menu red 0
		text red 0
		button red 0
		checkbutton red 0
		frame red 0
		label red 0
		menubutton red 0
		message red 0
		radiobutton red 0
		scale red 0
		scrollbar red 0
		toplevel red 0
		image red 0
		pack red 0
		grid red 0
		place red 0
		wm red 0
		winfo red 0
		bind red 0
		bindtags red 0
		event red 0
		font red 0
		cget darkblue 0
		configure darkblue 0
		bell purple 0
		clipboard purple 0
		destroy purple 0
		grab purple 0
		option purple 0
		send purple 0
		tk purple 0
		tkwait purple 0
		tk_bisque purple 0
		tk_chooseColor purple 0
		tk_dialog purple 0
		tk_focusNext purple 0
		tk_focusPrev purple 0
		tk_focusFollowsMouse purple 0
		tk_getOpenFile purple 0
		tk_getSaveFile purple 0
		tk_messageBox purple 0
		tk_optionMenu purple 0
		tk_popup purple 0
		tk_setPalette purple 0}

	set ranges {
		"\"" "\"" "#119911"}

	set comments {
		"#" "steelblue3"}}