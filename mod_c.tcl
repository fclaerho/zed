proc load_mod_c {} {addType "^.*\.(c|h)$" "C" ""}

proc apply_C {} {
	global keyWords ranges comments

	set keyWords {
		main purple 0
		auto #000000 1
		break #000000 1
		case #000000 1
		char "CornFlowerBlue" 0
		const #000000 0
		continue #000000 1
		default #000000 1
		do #000000 1
		double "CornFlowerBlue" 0
		else #000000 1
		enum #000000 1
		extern #000000 1
		exit navy 0
		float "CornFlowerBlue" 0
		for #000000 1
		goto red 0
		if #000000 1
		int "CornFlowerBlue" 0
		long "CornFlowerBlue" 0
		register #000000 1
		return #000000 1
		short "CornFlowerBlue" 0
		signed "CornFlowerBlue" 0
		sizeof #000000 1
		static #000000 1
		struct #000000 1
		switch #000000 1
		typedef #000000 1
		union #000000 1
		unsigned "CornFlowerBlue" 0
		void "CornFlowerBlue" 0
		volatile #000000 1
		while #000000 1}

	set ranges {
		"\"" "\"" "SeaGreen"}

	set comments {
		"#" "IndianRed"
		"//" "SlateGray4"}}