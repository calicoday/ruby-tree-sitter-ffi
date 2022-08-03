# when included, GenUtils needs FileUtils, $womping

module GenUtils
	attr_reader :srcdir, :gendir, :outdir, :devdir

	def initialize(srcdir, gendir, outdir, devdir)
		prepare_dirs(srcdir, gendir, outdir, devdir) 
	end
	
	def prepare_dirs(srcdir, gendir, outdir, devdir)
		@devdir = devdir
		@gendir = gendir
		@srcdir = srcdir
		@outdir = outdir
		Dir.mkdir(gendir) unless Dir.exists?(gendir)
		if Dir.exists?(outdir) && !$womping
			raise "#{outdir}-keep dir exists. exitting." if Dir.exists?(outdir + "-keep")
			::FileUtils.mv(outdir, outdir + "-keep")
		elsif Dir.exists?(outdir + "-keep") && !$womping
			$warn_exists = "Warning: #{outdir}-keep dir already existed but #{outdir} did not."
		end
		Dir.mkdir(outdir) unless Dir.exists?(outdir)

		raise "no #{outdir} dir. exitting." unless Dir.exists?(outdir)
		File.write(outdir+"/cp_or_mv_before_edit.txt", 
		  "Script will womp generated files. Copy or move elsewhere before edit.")
	end

	def mk_assert(s)
		# cut & here, since we've already preprocessed or do it in preprocess???
		"puts \"\#{s}\"\nputs \"\t=> \"\#(s)"
	end

	# [365] pry(main)> got7 = u.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
	# [368] pry(main)> parts = got7.map{|oth, sep, _| [oth, sep]}
	# [373] pry(main)> u == parts.flatten.join
	# => true

	# => [(oth, sep)*]
	# same as capture split but trimming the subcaptures
# 	def was_split_atomic(s)
# 		re_rs_comm = /\/\/.*$/
# 		re_rb_comm = /#.*$/
# 		re_rb_quote = /%q%[^%]*%/
# 		re_string = /"(\\"|[^"])*"/
# 		# require \n for semi end!!!
# 		re_semi_end = /;[ \t]*\n/
# 		  	 re_all = /#{re_rs_comm}|#{re_rb_comm}|#{re_rb_quote}|#{re_string}|#{re_semi_end}/
# 		re_all_flat = /\/\/.*$|#.*$|%q%[^%]*%|"(\\"|[^"])*"|;[ \t]*\n$/
# # 		re_semi_end = /;[ \t]*$/
# # 		  	 re_all = /#{re_rs_comm}|#{re_rb_comm}|#{re_rb_quote}|#{re_string}|#{re_semi_end}/
# # 		re_all_flat = /\/\/.*$|#.*$|%q%[^%]*%|"(\\"|[^"])*"|;[ \t]*$/
# 		re_scan = /([^\/#%";]*)(\/\/.*$|#.*$|%q%[^%]*%|"(\\"|[^"])*"|;[ \t]*$|[\/#%";])/
# 
# 		s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/).map do |oth, sep, _| 
# 			# error not-wellformed if sep is " here!!! include it or no???
# # 			oth << sep.shift if sep =~ /^[\/#%;"]$/
# # 			[oth, sep]
# # 			sep =~ /^[\/#%;"]$/ ? [oth << sep, ''] : [oth, sep]
# 			###sep =~ /^[\/#%]$/ && sep.length == 1 ? [oth << sep, ''] : [oth, sep]
# 			# (sep =~ /^[\/#%]$/ && sep.length == 1) ? [oth + sep] : [oth, sep]
# 			(sep == '/' || sep == '#' || sep == '%' || sep == ';') ?
# 				[oth + sep] :
# 				[oth, sep]
# 		end.flatten
# 	end
	
# [423] pry(main)> hmm = u.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
# [424] pry(main)> aha = hmm.map{|a| [a[0], a[1]]}.flatten
# [426] pry(main)> oho = aha.chunk_while{|a,b| a !~ /\A;[ \t]*\n/}.map(&:join)
# [428] pry(main)> oho.join == u
# => true

# prob cdv used these earlier:
# (?:re)
# Makes re into a group without generating backreferences. This is often useful when you need to group a set of constructs but don't want the group to set the value of $1 or whatever. 
# (?>re)
# Nests an independent regular expression within the first regular expression. This expression is anchored at the current match position. If it consumes characters, these will no longer be available to the higher-level regular expression. This construct therefore inhibits backtracking, which can be a performance enhancement. 
# also note: #{} makes a string?, so may need extra backslashes???
# #{...}
# Performs an expression substitution, as with strings. By default, the substitution is performed each time a regular expression literal is evaluated. With the /o option, it is performed just the first time.	def split_atomic(s)
#
# better with some recursive, eg nested brace after for (doesn't guard string, etc):
# (^\s*for[^{]*)(\{(?:[^{}]*+|\g<2>?)+\})

  def split_atomic(s)
		re_rs_comm = /\/\/.*$/
		re_rb_comm = /#.*$/
		re_rb_quote = /%q%[^%]*%/
		re_string = /"(\\"|[^"])*"/
		# require \n for semi end!!!
		re_semi_end = /;[ \t]*\n/
		  	 re_all = /#{re_rs_comm}|#{re_rb_comm}|#{re_rb_quote}|#{re_string}|#{re_semi_end}/
		re_all_flat = /\/\/.*$|#.*$|%q%[^%]*%|"(\\"|[^"])*"|;[ \t]*\n$/

# 		s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
# 		arr = s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
		arr = s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])?/)
		puts "   ++++ respell_lang scan arr:"
		ap arr
			
		arr.map{|a| [a[0], a[1]]}
			.flatten
			.chunk_while{|a,b| a !~ /\A;[ \t]*\n/}
			.map(&:join)
	end

	def respell_lang(code, vars=nil) # vars is m for log

		### bah. can do better now: split on ; not in a string (or comment?)!!! FIXME!!!

		tmp = split_atomic(code) # already flattened
	
		ish = tmp

		# now drop the ; statement end
		got = ish.map{|e| e.gsub(/;([ \t]*\n)\z/, '\1')}

		for_indent = nil
		got = got.map do |expr|

			expr = expr.gsub(/\blet\s+(&?mut\s+)?/, '\1')
		
			# note: extra "\n    " after HEREDOC end bc bbedit doesn't colour HEREDOCs right!!!
			# note: None may have other meaning in rust but here it seems to be 'no node',
			#   so add a constant No_node = Node.new to the helper.
			expr = expr.gsub(/\s*.unwrap\(\)(\n)?/, '\1')
				.gsub('.kind', '.type')
				.gsub('.start_position', '.start_point')
				.gsub('.end_position', '.end_point')
				.gsub('String::new()', '""')
				.gsub(/(\w+)::/, 'TreeSitterFFI::\1.')
				.gsub('.find(', '.index(')
				.gsub('None', 'nil')
				.gsub(/&?mut\s+/, '')
				.gsub('Some(', '(')
				.gsub(/&InputEdit\s*({[^}]*})/, 'TreeSitterFFI::InputEdit.from_hash(\1)')
				
			# sigh. rust and ruby Range have opposite ../...
			# rust .. excludes end, ... or ..= includes end
			# ruby .. includes end, ... excludes end
# 			expr = expr.gsub(/([\(\[]\s*)(\d+)\.\.\.(\d+)(\s*[\]\)])/, '\1(\2..\3)\4')
# 				.gsub(/([\(\[]\s*)(\d+)\.\.(\d+)(\s*[\]\)])/, '\1(\2...\3)\4')
			expr = expr.gsub(/([\(\[]\s*\d+)\.\.\.(\d+\s*[\]\)])/, '\1..\2')
				.gsub(/([\(\[]\s*\d+)\.\.(\d+\s*[\]\)])/, '\1...\2')
				
			#TMP!!! keep HEREDOC for node, tree; use %q%% for query
			if vars =~ /^test_query_/
# 				expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src
			else
				expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, "<<-HEREDOC\\1HEREDOC\n    ")
			end
			
			# for tree_test
			expr = expr.gsub(/&InputEdit\s*({[^}]*})/, 'TreeSitterFFI::InputEdit.from_hash(\1)')
				.gsub(/index_of\(&?(\w+),\s*("[^"]*")\)/, '\1.index(\2)')

      # drop & from any variables, array literals now ### new in aug!!!
      expr = expr.gsub(/&(\w+)/, '\1')
        .gsub(/&(\[)/, '\1')

      # isn't this done already elsewhere???!!! FIXME!!!
			# disable any asserts that contain '&', 'Vec' 
			if expr =~ /[^&]&[^&]|Vec/ 
				$log << "  - suppress &|Vec: #{expr.scan(/[^&]&[^&]|Vec/).inspect}\n"
				expr = expr.split("\n", -1).map{|e| e.gsub(/^/, '# ') unless e == ''}.join("\n")
			end
			expr
		end
		
		got = got.join

	#### come back to this for{} issue!!!
	# - don't double comment
	# - guard string et al
		# restrict this to query???
		# comment out for{}
# 		re_for = /(^\s*for[^{]*)(\{(?:[^{}]*+|\g<2>?)+\})/
# 		got = got.gsubb(re_for) do |md|
# 			(md[1] + md[2]).split("\n", -1).map{|e| e.gsub(/^/, '# ') unless e == ''}.join("\n")
# 		end

	end

	# respell things for ruby-tree-sitter bindings
	def respell_bindings(code)
		code.gsub('TreeSitterFFI::Parser.new', 'TreeSitterFFI.parser')
			.gsub(/(tree|source_code).clone\(\)/, '\1.copy()')
			.gsub('TreeSitterFFI::Query.new', 'TreeSitterFFI::Query.make')
			.gsub('TreeSitterFFI::QueryCursor.new', 'TreeSitterFFI::QueryCursor.make')
	end

	
end
