require 'fileutils'
require 'erb'
require './src/gen/rusty_gen_query.rb'

require 'awesome_print'

puts "src/gen/rusty_gen.rb"
puts "+=+=+ " + `date`
puts

# move into reusable class, top-level gen calls as we did???

# ruby -e"require './fresh/gen-step/rusty_gen_00.rb'; gen"

def gen()
# 	$log = File.open('./gen-step/rusty-log.rb', 'w') # open after mkdir
	devdir = './src/gen'
# 	devdir = './fresh/gen-step'
	gendir = './gen'
	outdir = gendir + '/rusty'
	ts_tests_dir = './dev-ref/tree-sitter-0.19.5/cli/src/tests'
	g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
# 	bosslist = ["node", "tree"]
	$log = File.open(outdir + '/rusty-log.rb', 'w')
# 	bosslist = ["node"] # only node so smaller log
# 	bosslist = ["node", "tree"]
	bosslist = ["node", "tree", "query"]
# 	bosslist = ["query"]
	g.gen_tests(bosslist)

	$log.close
	puts "done."
end

$womping = true

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
# 		if Dir.exists?(outdir)
			raise "#{outdir}-keep dir exists. exitting." if Dir.exists?(outdir + "-keep")
			::FileUtils.mv(outdir, outdir + "-keep")
# 			if Dir.exists?(outdir + "-keep")
# 				puts "#{outdir}-keep dir exists. exitting." 
# 				exit 0
# 			else
# 			end
		elsif Dir.exists?(outdir + "-keep") && !$womping
# 		elsif Dir.exists?(outdir + "-keep")
			$warn_exists = "Warning: #{outdir}-keep dir already existed but #{outdir} did not."
		end
		Dir.mkdir(outdir) unless Dir.exists?(outdir)
# 		Dir.mkdir(outdir)

		raise "no #{outdir} dir. exitting." unless Dir.exists?(outdir)
# 		unless Dir.exists?(outdir)
# 			puts "no #{outdir} dir. exitting."
# 			exit 0
# 		end
		File.write(outdir+"/cp_or_mv_before_edit.txt", "Script will womp generated files. Copy or move elsewhere before edit.")
	end
	
end

class RustyGen
	include GenUtils
	
# 	attr_reader :lead, :bossfile, :bossreq, :tests, :gather, :testslist
	attr_reader :srcfile, :boss, :testcalls, :testdefs
	
	# boss-specific preprocessing
	def preprocess(boss, rem, m)
		case boss
		when 'tree' then preprocess_tree(rem, m)
		when 'query' then preprocess_query(rem, m)
		else
			rem
		end
	end

  def get_binding
    binding
  end
	
	def gen_tests(bosslist)
		gen_base(bosslist)
		self # reorg this!!!
	end


	# gen_tests(["node", "tree"])
	def gen_base(bosslist)
# 		tmplt = File.read('./fresh/side/rusty_tests.rb.erb')
		@testcalls = []

		bosslist.each do |e|
			@boss = e
			
			puts "boss: #{boss}"
			$log << "#{boss}...\n"
			
			@srcfile = srcdir + "/#{boss}_test.rs"
			s = File.read(srcfile)
				
			@testdefs = []
			tests = s.split(/^fn/).map do |fn|
				# strip whitespace and end } and junk
				fn = fn.strip.gsub(/}[^{}]*\z/, '')
				_, m, rem = fn.split(/\A([^\(]*\([^\)]*\))[^{]*{\s*/)
				next unless m

				if m == 'test_node_children()'
					puts "%%%#{rem}%%%"
	# 				puts "  %%% $pre: #{$pre}, rem: "
	# 				ap rem
	# 				puts "%%%" 
				end

				$log << "#{m}\n"
				
				skip = skip_fn(boss, m)
				rem = preprocess(boss, rem, m) # 02 preprocess back in
				testdefs << [m, guts(rem, m), skip]	# 01 only common, eg unwrap() m for log
# 				testdefs << [m, guts(rem), skip]	# 01 only common, eg unwrap()
# 				testdefs << [m, rem, skip] # 00 change nothing for zero!!!
				
				puts "#{m}: #{skip ? 'skip' : ''}"
				$log << "  - skipped\n" if skip

				m
			end.compact # remove nils where we nexted
			
			outfile = outdir+"/rusty_#{boss}_test.rb"
			
			tmplt = File.read(devdir + '/rusty_tests.rb.erb')
# 			tmplt = File.read('./fresh/gen/rusty_tests.rb.erb')
			# template needs boss [not srcfile], testdefs arr [[m, guts, skip]+]
			File.write(outfile, ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
	
			# comment out the skips
			tests_string = tests.map{|m| 
				skip_fn(boss, m) ? m.split("\n").map{|e| e.gsub(/^/, '# ')}.join("\n") : m
			}.join("\n")
			
			@testcalls << {
				bossreq: outfile,
				tests: tests_string}
				
			$log << "\n"

		end

		tmplt = File.read(devdir + '/rusty_run.rb.erb')
# 		tmplt = File.read('./fresh/gen/rusty_run.rb.erb')
		# template needs testcalls {:bossreq, :tests}
		File.write(outdir+"/run_rusty.rb", 
			ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
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
# 	def respell_lang(code, _=nil)
# 			puts "  %%% code: #{code.inspect}"

		### bah. can do better now: split on ; not in a string (or comment?)!!! FIXME!!!

		tmp = split_atomic(code) # already flattened
# 		tmp2 = tmp.chunk_while{|a,b| a !~ /\A;[ \t]*\n/} #.map(&:join)

# 		puts "+++++++ respell_lang code:"
# 		ap code
# 		puts "   ++++ respell_lang split_atomic tmp:"
# 		ap tmp
	
		ish = tmp #.join
# 		puts "+++++++"

		# now drop the ; statement end
# 		got = tmp2.map{|e| e.gsub(/;([ \t]*\n)\z/, '\1')}
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
				
			# do better!!!
# 			expr = expr.gsub(/r#"/, '<<-HEREDOC')
# 				.gsub(/"#/, "HEREDOC\n    ") 
# 			expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, "<<-HEREDOC\\1HEREDOC\n    ")
			# guard string better??? eg (&?("(\\"|[^"])*"))
# 			expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, "<<-HEREDOC\\1HEREDOC\n    ")
			
			#TMP!!! keep HEREDOC for node, tree; use %q%% for query
			if vars =~ /^test_query_/
# 				expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src
			else
				expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, "<<-HEREDOC\\1HEREDOC\n    ")
			end
			
# 			expr = expr.gsub(/r#"(("[^#]|[^"])*)"#/, 
# 				"<<-HEREDOC\\1HEREDOC\n    ") unless vars =~ /^test_query_/
			
# 			....|-gasket-----|
# 			"abc#{calc_expr()}def"
# 			......|-hatch---|
			
			# for tree_test
			expr = expr.gsub(/&InputEdit\s*({[^}]*})/, 'TreeSitterFFI::InputEdit.from_hash(\1)')
				.gsub(/index_of\(&?(\w+),\s*("[^"]*")\)/, '\1.index(\2)')

			# from gen_query, comment for{}
# 			expr = expr.gsub(/(allocations::record\(\|\| {)/, '# \1')
# 				.gsub(/^((    )}\);?)/, '\2# \1')
# 			expr = expr.gsubb(/^([ \t]*)(for[^{]*{[ \t]*)$/) do |md| 
# 				for_indent = md[1]
# 				'# ' + md[1] + md[2]
# 			end
# 			# if another pass set a for_indent, try to match the end brace
# 			if for_indent
# 				expr = expr.gsubb(/^(#{for_indent}}[ \t]*)$/) do |md|
# 					indent = nil
# 					'# ' + md[1]
# 				end
# 			end

      # drop & from any variables now ### new in aug!!!
      expr = expr.gsub(/&(\w+)/, '\1')

			# disable any asserts that contain '&', 'Vec' 
# 			if expr =~ /&|Vec/ || expr =~ /.repeat(count)/
			if expr =~ /[^&]&[^&]|Vec/ 
				$log << "  - suppress &|Vec: #{expr.scan(/[^&]&[^&]|Vec/).inspect}\n"
				###$log << "  - suppress &|Vec\n"
# 				expr = expr.split("\n").map{|e| e.gsub(/^/, '# ')}.join("\n")
				expr = expr.split("\n", -1).map{|e| e.gsub(/^/, '# ') unless e == ''}.join("\n")
			end
# 			expr + (semi || '')
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

	def guts(s, vars="")
		tmp = respell_bindings(respell_lang(s, vars))
		# guard string, %q%%!!! FIXME!!
		tmp.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
# 		tmp = s.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
# 		respell_bindings(respell_lang(tmp, vars))
	end

	def preprocess_tree(s, m)
		# for all of tree_test, respell arrays in asserts and use assert_array_eq!
		re = /assert_eq!\((\s*\((['"];|[^;])*);/ # capture args and close paren but not open
		s = s.gsub(re) do |s|
			md = re.match(s)
			# chg open paren of first arg and close paren of last arg to [ and ], resp
			args = md[1].gsub(/\A(\s*)\(/, '\1[').gsub(/\)(\s*)\)(\s*)\z/, ']\1')
			better = args.split(/\)\s*(,\s*)\(/).each_slice(2).map do |pair|
				"#{pair[0] ? pair[0] : ''}#{pair[1] ? ']' + pair[1] + '[' : ''}"
			end.flatten.join
			"assert_array_eq!(#{better});" # reform the assert
		end

		# ANOTHER tricky bit
		if m == 'test_tree_cursor_child_for_point()'
			# deal with source var and chg None to -1
			# source string contains spaces not tabs!!!
    src = 'source = "    [
        one,
        {
            two: tree
        },
        four, five, six
    ];"'
			s = s.gsub(/let source = &"[^"]*"\[1\.\.\]/, src)
				.gsub(/assert_eq!\(c.goto_first_child_for_point\([^;]*/) do |line|
					line.gsub('None', '-1')
				end
		end		

		# tree_test has some extra {} blocking that node_test doesn't, for reusing var names!
		# BY EYE, we determine the vars necessary per method and rename
		$mods ||= {
			'test_tree_edit()' => ['tree'],
			'test_get_changed_ranges()' => ['tree', 'source_code'],
			}
		subs = $mods[m] || []

		return s if subs.empty?
	
		# for only specific functions
		subs.each do |var|
			puts "var: #{var}"
			# make control_var for vars that get cloned, add var = control_var
			# for any pre-block statements and comment out block parens
			s = s.gsub(/    let\s+#{var}\s+= ([^;]*;)/, 
				"    control_#{var} = \\1\n    #{var} = control_#{var};")
			s = s.gsub(/#{var}\.clone\(\)/, "control_#{var}.clone()")
				.gsub(/^(\s*){\s*$/, '\1# {')
				.gsub(/^(\s*)}\s*$/, "\\1# }\n")
		end
		s
	end

	# for commenting out def and call of troublesome functions
	def skip_fn(boss, m)
		return skip_fn_query(boss, m) if boss == 'query'
		
		# m NOT commented out will be skipped!!!
		name = m.scan(/[^\(]*/).first
		[
			# node
			"test_node_named_child_with_aliases_and_extras", # generate
			"test_node_children", # tree.walk
			"test_node_children_by_field_name", # python
	# 		"test_node_parent_of_child_by_field_name", # javascript
	# 		"test_node_child_by_field_name_with_extra_hidden_children", # python
			"test_node_named_child_with_aliases_and_extras", # generate
			"test_node_edit", # rusty
			"test_node_field_names", # generate
			"test_node_field_calls_in_language_without_fields", # generate
			"test_node_is_named_but_aliased_as_anonymous", # generate
	# 		"test_node_numeric_symbols_respect_simple_aliases", # python, ruby
			"get_all_nodes", # rusty
		
			# tree
	# 		"test_tree_edit",
	# 		"test_tree_cursor",
	# 		"test_tree_cursor_fields",
	# 		"test_tree_node_equality",
	# 		"test_tree_cursor_child_for_point", # need rusty vars
			"test_get_changed_ranges", # need rusty args
			"index_of",
			"range_of",
			"get_changed_ranges",

			].include?(name) || name =~ /&|Vec/
			# disable any calls that contain '&', 'Vec'
	end

end




