#

outdir = './gen/rusty'
Dir.mkdir('./gen') unless Dir.exists?('./gen')
# PROB don't care about past rusty but doesn't hurt to be clear about it
if Dir.exists?(outdir)
	if Dir.exists?(outdir + "-keep")
		puts "#{outdir}-keep dir exists. exitting." 
		exit 0
	else
		FileUtils.mv(outdir, outdir + "-keep")
	end
elsif Dir.exists?(outdir + "-keep")
	$warn_exists = "Warning: #{outdir}-keep dir already existed but #{outdir} did not."
end
Dir.mkdir(outdir)

unless Dir.exists?(outdir)
	puts "no #{outdir} dir. exitting."
	exit 0
end

# ts_repo_dir = '/Users/cal/dev/rubymotion/tang/gh/tree-sitter/tree-sitter'
# ts_tests_dir = ts_repo_dir + '/cli/src/tests/'
ts_tests_dir = './dev-ref/tree-sitter-0.19.5/cli/src/tests/'

File.write(outdir+"/cp_or_mv_before_edit.txt", "Script will womp generated files. Copy or move elsewhere before edit.")

def mk_assert(s)
	"puts \"\#{s}\"\nputs \"\t=> \"\#(s)"
end

def respell_lang(code, _=nil)
	got = code.split(/;[ \t]*\n/).map do |expr|
		expr = expr.gsub(/\blet\s+(&?mut\s+)?/, '\1')
		
		# note: extra "\n    " after HEREDOC end bc bbedit doesn't colour HEREDOCs right!!!
		# note: None may have other meaning in rust but here it seems to be 'no node',
		#   so add a constant No_node = Node.new to the helper.
		expr = expr.gsub(/\s*.unwrap\(\)(\n)?/, '\1')
			.gsub('.kind', '.type')
			.gsub('.start_position', '.start_point')
			.gsub('.end_position', '.end_point')
			.gsub(/(\w+)::/, 'TreeSitterFFI::\1.')
			.gsub('.find(', '.index(')
			.gsub('None', 'nil')
			.gsub(/&?mut\s+/, '')
			.gsub(/r#"/, '<<-HEREDOC')
			.gsub(/"#/, "HEREDOC\n    ") 
			.gsub('Some(', '(')
			.gsub(/&InputEdit\s*({[^}]*})/, 'TreeSitterFFI::InputEdit.from_hash(\1)')
			
		# for tree_test
		expr = expr.gsub(/&InputEdit\s*({[^}]*})/, 'TreeSitterFFI::InputEdit.from_hash(\1)')
			.gsub(/index_of\(&?(\w+),\s*("[^"]*")\)/, '\1.index(\2)')

		# disable any asserts that contain '&', 'Vec' 
		if expr =~ /&|Vec/
			expr = expr.split("\n").map{|e| e.gsub(/^/, '# ')}.join("\n")
		end
		expr
	end.join("\n")
end

# respell things for ruby-tree-sitter bindings
def respell_bindings(code)
	code.gsub('TreeSitterFFI::Parser.new', 'TreeSitterFFI.parser')
		.gsub(/(tree|source_code).clone\(\)/, '\1.copy()')
		.gsub('TreeSitterFFI::Query.new', 'TreeSitterFFI::Query.make')
end

def guts(s, vars="")
	tmp = s.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
	respell_bindings(respell_lang(tmp, vars))
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

# 	re = /assert_eq!\((\s*\((['"];|[^;])*);/ # capture args and close paren but not open
# "#
# ([^"]#|[^#])*
# r#"(("[^#]|[^"])*)"#
def preprocess_query(s, m)
	s = s.gsub(/(allocations::record\(\|\| {)/, '# \1')
		.gsub(/^((    )}\);?)/, '\2# \1')
		.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src

	# just lucky no { inside hash!!!
	s = s.gsub(/QueryError {([^}]*)}/, 'StuntQueryError.new({\1})')
		.gsub(/.unwrap_err\(\)\n?/, '')

# 	s = s.gsub(/(allocations::record\(\|\| {)/, '# \1')
# 		.gsub(/^((    )}\);?)/, '\2); # \1')
# 		.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src
end

# for commenting out def and call of troublesome functions
def skip_fn(m)
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
		
		# query, prob need to recreate these
# 		"test_query_errors_on_invalid_syntax",
# 		"test_query_errors_on_invalid_symbols",
# 		"test_query_errors_on_invalid_predicates",
# 		"test_query_errors_on_impossible_patterns",
# 		"test_query_verifies_possible_patterns_with_aliased_parent_nodes",
# 		"test_query_matches_with_simple_pattern",
# 		"test_query_matches_with_multiple_on_same_root",
# 		"test_query_matches_with_multiple_patterns_different_roots",
# 		"test_query_matches_with_multiple_patterns_same_root",
# 		"test_query_matches_with_nesting_and_no_fields",
# 		"test_query_matches_with_many_results",
# 		"test_query_matches_with_many_overlapping_results",
# 		"test_query_matches_capturing_error_nodes",
# 		"test_query_matches_with_extra_children",
# 		"test_query_matches_with_named_wildcard",
# 		"test_query_matches_with_wildcard_at_the_root",
# 		"test_query_matches_with_immediate_siblings",
# 		"test_query_matches_with_last_named_child",
		"test_query_matches_with_negated_fields",
		"test_query_matches_with_field_at_root",
		"test_query_matches_with_repeated_leaf_nodes",
		"test_query_matches_with_optional_nodes_inside_of_repetitions",
		"test_query_matches_with_top_level_repetitions",
		"test_query_matches_with_non_terminal_repetitions_within_root",
		"test_query_matches_with_nested_repetitions",
		"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
		"test_query_matches_with_trailing_repetitions_of_last_child",
		"test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes",
		"test_query_matches_with_trailing_optional_nodes",
		"test_query_matches_with_nested_optional_nodes",
		"test_query_matches_with_repeated_internal_nodes",
		"test_query_matches_with_simple_alternatives",
		"test_query_matches_with_alternatives_in_repetitions",
		"test_query_matches_with_alternatives_at_root",
		"test_query_matches_with_alternatives_under_fields",
		"test_query_matches_in_language_with_simple_aliases",
		"test_query_matches_with_different_tokens_with_the_same_string_value",
		"test_query_matches_with_too_many_permutations_to_track",
		"test_query_matches_with_alternatives_and_too_many_permutations_to_track",
		"test_query_matches_with_anonymous_tokens",
		"test_query_matches_with_supertypes",
		"test_query_matches_within_byte_range",
		"test_query_matches_within_point_range",
		"test_query_captures_within_byte_range",
		"test_query_matches_with_unrooted_patterns_intersecting_byte_range",
		"test_query_captures_within_byte_range_assigned_after_iterating",
		"test_query_matches_different_queries_same_cursor",
		"test_query_matches_with_multiple_captures_on_a_node",
		"test_query_matches_with_captured_wildcard_at_root",
		"test_query_matches_with_no_captures",
		"test_query_matches_with_repeated_fields",
		"test_query_matches_with_deeply_nested_patterns_with_fields",
		"test_query_matches_with_indefinite_step_containing_no_captures",
		"test_query_captures_basic",
		"test_query_captures_with_text_conditions",
		"test_query_captures_with_predicates",
		"test_query_captures_with_quoted_predicate_args",
		"test_query_captures_with_duplicates",
		"test_query_captures_with_many_nested_results_without_fields",
		"test_query_captures_with_many_nested_results_with_fields",
		"test_query_captures_with_too_many_nested_results",
		"test_query_captures_with_definite_pattern_containing_many_nested_matches",
		"test_query_captures_ordered_by_both_start_and_end_positions",
		"test_query_captures_with_matches_removed",
		"test_query_captures_and_matches_iterators_are_fused",
		"test_query_text_callback_returns_chunks",
		"test_query_start_byte_for_pattern",
		"test_query_capture_names",
		"test_query_lifetime_is_separate_from_nodes_lifetime",
		"test_query_with_no_patterns",
		"test_query_comments",
		"test_query_disable_pattern",
		"test_query_alternative_predicate_prefix",
		"test_query_step_is_definite",
		"assert_query_matches",
		"collect_matches<'a>",
		"collect_captures<'a>",
		"format_captures<'a>",

		].include?(name) || name =~ /&|Vec/
		# disable any calls that contain '&', 'Vec'
end

out_run = File.open(outdir+"/run_rusty.rb", "w")
out_run << "# run each test file\n\n"
lead = <<-INDENTED_HEREDOC
# hacky hacky hacky -- generated by src/gen/rusty_gen.rb, then COPIED and hand-tweaked

# run the rusty test with this script from the project dir, like so:
# ruby misc/run_rusty.rb

require './src/run_rusty_helper.rb'

	INDENTED_HEREDOC
out_run << lead
	

# ["node", "tree", "query"].each do |bossfile|
["node", "tree"].each do |bossfile|
	puts "bossfile: #{bossfile}"
	filename = outdir+"/rusty_#{bossfile}_test.rb"
	out_test = File.open(filename, "w")

  lead = <<-INDENTED_HEREDOC
# hacky hacky hacky -- generated by src/gen/rusty_gen.rb, NOT hand-tweaked

# this is a simplistic translation-by-regexp to ruby of the tree-sitter test:
# tree-sitter/cli/src/tests/#{bossfile}_test.rs

	INDENTED_HEREDOC
	out_test << lead
	
	s = File.read(ts_tests_dir + "/#{bossfile}_test.rs")
	tests = []
	
	# extract functions
	fn = s.split(/^fn/)
	fn.each do |fn|
		# strip whitespace and end } and junk
		fn = fn.strip.gsub(/}[^{}]*\z/, '')
		_, m, rem = fn.split(/\A([^\(]*\([^\)]*\))[^{]*{\s*/)
		next unless m

		tests << m
		
		skipping = skip_fn(m)
		puts "#{m}: #{skipping ? 'skip' : ''}"
		out_test << "\n=begin" if skipping

		# special for tree_test.rs
		rem = preprocess_tree(rem, m) if bossfile == 'tree'
		rem = preprocess_query(rem, m) if bossfile == 'query'

		out_test << "\ndef #{m}\n    #{guts(rem)}\nend\n"
		out_test << "=end\n" if skipping
	end
	
	out_test << "\n\n"

	out_run << "\nrequire '#{filename}'\n\n"
	out_run << "puts '#{filename}'\n"
	out_run << tests.map do |m|
		skip_fn(m) ?
			m.split("\n").map{|e| e.gsub(/^/, '# ')}.join("\n") :
			m
	end.join("\n") + "\n\n"
end

out_run << "puts 'done.'\n"

puts "done."



