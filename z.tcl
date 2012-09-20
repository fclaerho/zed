
set id "z  1.3R"

puts stdout "$id: here we go! :)"

set currentFolder [pwd]
set home "$env(ZEDHOME)"

cd $home

set criticalFiles {"z.conf.tcl" "z.code.tcl" "z.ihm.tcl"}

foreach {file} $criticalFiles {
	if {[file exists $file] && [file readable $file]} {
		source $file
	} else {
		puts stdout "$id: FATAL ERROR, critical file not found or not readable ($file)"
		exit}
}

#splash screen
puts stdout "$id: screen resolution @[winfo vrootwidth .]x[winfo vrootheight .] ok!."
about

#loading
loadModules

cd $currentFolder

loadFileList

wm deiconify .
after 1 {set timeout 1}
vwait timeout
focus .about
raise .about
