require 'fileutils'
require 'erb'

# require './src/rusty/gen_rusty_util.rb'

require 'awesome_print'

puts "src/rusty/gen_rusty.rb"
puts "+=+=+ " + `date`
puts

# RustyGen is class not module to keep ivars for ERB!!!

class RustyGen
# 	include GenUtils

  def self.gen_rusty(filer, bosslist)
    
    (['boss'] + bosslist).each do |e|
      path = Pathname.new('./') + filer.path(:reqs) + "#{e}_rusty_prep.rb"
      puts "=== path: #{path.inspect}"
      puts "  to_s: #{path.to_s.inspect}"
      path = filer.path(:reqs) + "#{e}_rusty_prep.rb"
      require './' + path.to_s
#       require Pathname.new('./') + filer.path(:reqs) + "#{e}_rusty_prep.rb"
    end
    self.new.gen_tests(filer, bosslist)
  end
  
  # ivars to pass to ERB
	attr_reader :srcfile, :boss, :testcalls, :testdefs, :stubs, :patchreqs
	
  def get_binding
    binding
  end

	def guts(s, vars="")
		tmp = respell_bindings(respell_lang(s, vars))
		# guard string, %q%%!!! FIXME!!
		tmp.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
	end
	
	def gen_tests(filer, bosslist)
		@testcalls = []

    klass = 'Rusty' + 'Boss'
    bossprep = Object::const_get(klass) #.new('boss')
    
		bosslist.each do |e|
		  @boss = Object::const_get("Rusty#{e.capitalize}").new(e)
			
			puts "boss: #{boss.tag}"
			$log << "#{boss.tag}...\n"
			
			s = filer.read(:input, "#{boss.tag}_test.rs")
				
			@testdefs = []
			tests = s.split(/^fn/).map do |fn|
				# strip whitespace and end } and junk
				fn = fn.strip.gsub(/}[^{}]*\z/, '')
				_, m, rem = fn.split(/\A([^\(]*\([^\)]*\))[^{]*{\s*/)
				next unless m

				$log << "#{m}\n"
				
				skip = boss.skip_fn(m)
				rem = boss.preprocess(rem, m)
				testdefs << [m, guts(rem, m), skip]
				
				puts "#{m}: #{skip ? "skip (#{skip})" : ''}"
				$log << "  - skipped #{skip}\n" if skip

				m
			end.compact # remove nils where we nexted
			
			filer.erb_write(:tmplt, 'rusty_tests.rb.erb', get_binding, 
			  "rusty_#{boss.tag}_test.rb")
	
			# comment out the skips
      good_tests = testdefs.reject{|m, guts, skip| skip &&
        skip.include?('internal')}.compact.map{|m, guts, skip| m}
      tests_string = good_tests.join("\n")


      # nope, gen rusty_patch_include.rb with require skip stubs files
			@stubs = testdefs.select{|m, guts, skip| skip && 
			  skip.is_a?(String) && !skip.include?('internal')}.compact
			@stubs = nil if stubs.empty?
			if stubs
			  puts "if stubs" #: #{stubs.inspect}"
			  @patchreqs ||= []
			  # form requires for patch blanks and cut '_blank' before gen run_rusty
			  			  
			  @patchreqs << filer.path(:out) + "rusty_#{boss.tag}_patch_blank.rb"
        filer.erb_write(:tmplt, 'rusty_patch.rb.erb', get_binding, 
          "rusty_#{boss.tag}_patch_blank.rb")
      end

			@testcalls << {
				bossreq: filer.path(:out) + "rusty_#{boss.tag}_test.rb",
				tests: tests_string}
				
			$log << "\n"

		end


		# for early testing...
    filer.erb_write(:tmplt, 'rusty_run.rb.erb', get_binding, "run_rusty_stubs.rb")

		# for real, when patch blanks have been filled, they'll be in src/
		@patchreqs = patchreqs.map{|e| 
		  e.to_s.gsub('_blank', '').gsub('gen/dev-', 'src/')}
# 		@patchreqs = patchreqs.map{|e| e.to_s.gsub('_blank', '')}

		# rusty_run tmplt needs @testcalls {:bossreq, :tests}
    filer.erb_write(:tmplt, 'rusty_run.rb.erb', get_binding, "run_rusty.rb")			  
	end

  ### was GenUtils...

  ### unused???
	def mk_assert(s)
		# cut & here, since we've already preprocessed or do it in preprocess???
		"puts \"\#{s}\"\nputs \"\t=> \"\#(s)"
	end

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
		# need \n for semi end!!!
		re_semi_end = /;[ \t]*\n/
		  	 re_all = /#{re_rs_comm}|#{re_rb_comm}|#{re_rb_quote}|#{re_string}|#{re_semi_end}/
		re_all_flat = /\/\/.*$|#.*$|%q%[^%]*%|"(\\"|[^"])*"|;[ \t]*\n$/

# 		s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
# 		arr = s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])/)
		arr = s.scan(/([^\/#%";]*)(#{re_all}|[\/#%";])?/)
# 		puts "   ++++ respell_lang scan arr:"
# 		ap arr
			
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