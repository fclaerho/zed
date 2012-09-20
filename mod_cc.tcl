proc load_mod_cc {} {addType "^.*\.(cc|cpp|h)$" "CC" "compileNexec"}

proc compileNexec {fileName} {
	if {[file exists make]} {
		exec make
	} else {
		exec g++ $fileName && ./a.out}}

proc apply_CC {} {
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
		while #000000 1
		template "steelblue3" 0
		typename #000000 0
		class "steelblue3" 0
		namespace "steelblue3" 0
		new #000000 0
		delete #000000 0
		public "steelblue3" 0
		protected "steelblue3" 0
		private "steelblue3" 0
		throw #AA1111 0
		bool "CornFlowerBlue" 0
		inline #000000 0
		wchar_t "CornFlowerBlue" 0
		friend #000000 0
		virtual #000000 0}

	set ranges {
		"\"" "\"" "SeaGreen"
		"/*" "*/" "slategray4"}

	set comments {
		"#" "indianred"
		"//" "slategray4"}}