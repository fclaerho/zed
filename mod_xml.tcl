proc load_mod_xml {} {addType "^.*\.(html|xml|htm)$" "XML" "launchBrowser"}

proc launchBrowser {fileName} {
	exec mozilla $fileName &}

proc apply_XML {} {
	global keyWords ranges comments

	set keyWords {}

	set ranges {
		"<" ">" "steelblue3"
		"\"" "\"" "#119911"}

	set comments {}}