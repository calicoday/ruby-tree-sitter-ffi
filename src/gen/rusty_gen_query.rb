# more rusty gen stuff for query

### from Jubify
class String
	def gsubb(re, &b) gsub(re){|s| yield(re.match(s), re)} end
end
# 		line = line.gsubb(/<([^>]+)>/){|md| "<#{md[1].gsub(/\s+/, '_')}>"}

class RustyGen

	# mod the Query* classes to match rust bindings enough for query_tests.rs-ish
	def rusty_bindings_patch()
		
	end
	
# 	def preprocess_square_capture(s, m)
# 	  # look for array of captures (can it be vec???)
# 	  re_capture = /\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\])(\s*,?\s*)\)/
# 	  re_sq_capture = /&?(\[\s*)((#{re_capture}\s*,?\s*)+)(\])/
# 	  re_sq_capture_flat = /&?(\[\s*)((\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\])(\s*,?\s*)\)\s*,?\s*)+)(\])/
# 	  got = preprocess_captures('\2', m)
# 	  puts "got: #{got.inspect}"
# 	  s.gsub(re_sq_capture, "\1#{got}\3")
# 	end
	def preprocess_square_capture(s, m)
	  # look for array of captures (can it be vec???)
	  re_capture = /\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\])(\s*,?\s*)\)/
	  re_sq_capture = /&?(\[\s*)((#{re_capture}\s*,?\s*)+)(\])/
	  re_sq_capture_flat = /&?(\[\s*)((\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\])(\s*,?\s*)\)\s*,?\s*)+)(\])/
	  s.gsubb(re_sq_capture) do |md| #, "\1#{got}\3")
      got = preprocess_captures(md[2], m)
      puts "got: #{got.inspect}"
      md[1] + got + md[11]
	  end
	end
	def preprocess_square_str_bool(s, m)
#         Row {
#             description: "an indefinite step that is optional",
#             language: get_language("javascript"),
#             pattern: %q%(object "{" (identifier)? @foo "}")% ,
#             results_by_substring: &[
#                 ("object", false),
#                 ("{", true),
#                 ("(identifier)?", false),
#                 ("}", true),
#             ],
#         },

	end
	def preprocess_captures(s, m)
		puts "  captures m: #{m}"
		# look for vec! specifically (not just any []) bc that's the capture structure!!!
# 		re = /([^\w,!])\((\s*\d+\s*,\s*)(vec!([^\]]\)|[^\]])*)(\],?\s*)\)/

#     re_string_pair_guts = /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*/
#          re_string_pair = /\(#{re_string_pair_guts}\)/
#     re_string_pair_flat = /\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)/
# 
# 		re_string_pairs = /(#{re_string_pair}\s*,?\s*)+/

		# allow poss , after second string
    re_string_pair_guts = /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*/
#     re_string_pair_guts = /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*/
         re_string_pair = /\(#{re_string_pair_guts}\)/
    re_string_pair_flat = /\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*\)/
#     re_string_pair_flat = /\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)/

		re_string_pairs = /(#{re_string_pair}\s*,?\s*)+/

    # or empty vec!
		re_vec = /vec!\[(\s*#{re_string_pairs}?)\]/ # re_string_pairs now opt
		re_vec_flat = /vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*\)\s*,?\s*)+)\]/
#    chgd + to * -->                                                 ^
# 		re_vec = /vec!\[(\s*#{re_string_pairs})\]/
# 		re_vec_flat = /vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*\)\s*,?\s*)+)\]/

		# allow poss , after vec ]
    # allow poss , after ) but don't capture \s* needed for next start match: \s(\d+
		     re = /(\A|[^\w,!])\((\s*\d+\s*,\s*)(#{re_vec})(\s*,?\s*)\)(\s*,?)/
		re_flat = /(\A|[^\w,!])\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*\)\s*,?\s*)*)\])(\s*,?\s*)\)(\s*,?)/
#        ^  <-- chgd + to *
# 		re_flat = /(\A|[^\w,!])\((\s*\d+\s*,\s*)(vec!\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*\)\s*,?\s*)+)\])(\s*,?\s*)\)(\s*,?)/

		s = s.gsubb(re) do |md|
			count = md[2]
# 			count = md[1]
			puts "    count: #{count.inspect}"
			vec_tail = md[8]
			square_tail = md[9] # must not capture space after , bc next needs it pre (\d+
# 			tail = md[8]
# 			tail = md[5]
# 			vec = preprocess_vec!(md[2], m)
			vec = preprocess_square_pairs(md[3], m, 1)
			"#{md[1]}[" + count + vec + vec_tail + ']' + square_tail
# 			"#{md[1]}[" + count + vec + ']' + tail
		end
	end
# 	def re(k)
# 		@re ||= {
# 			string_pair_guts: /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*/,
# 			string_pair = /\(#{re_string_pair_guts}\)/,
# 			string_pair_flat = /\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)/,
# 			
# 			}
# 	end
	#### ((vec!|(&|[^#])\[)([^\]]\)|[^\]])*)(\],?\s*)
	## seq of string pairs in any vec! or []
	def preprocess_square_pairs(s, m, depth=0)
		puts '  '* depth + "  square m: #{m}"
		# allow poss , after second string
    re_string_pair_guts = /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*,?\s*/
#     re_string_pair_guts = /\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*/
         re_string_pair = /\(#{re_string_pair_guts}\)/
    re_string_pair_flat = /\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)/

		re_string_pairs = /(#{re_string_pair}\s*,?\s*)+/

		# md 1 (2): head, '[', 3 (4,5): pairs, ']'
# 		re_square_pairs = 
# 			/(vec!|&)?\[(\s*#{re_string_pairs})\]/
# 		re_square_pairs_flat = 
# 			/(vec!|&)?\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\]/
# 
# 		s.gsubb(re_square_pairs) do |md|
# 		# capture full () and trim ends, pair[1...-1]
# 			puts "  ["
# # 			pairs = md[2].split(/(#{re_string_pair})/).each_slice(4).map do |comma, pair, _| 
# 			pairs = md[2].split(/(#{re_string_pair})/).tap{|o| 
# 				puts "    #{o.inspect}"}.each_slice(4).map do |comma, pair, _| 
# 				puts "    [#{comma.inspect}, #{pair.inspect}]"
# 				
# 				[comma, "#{pair ? '[' + pair[1...-1] + ']' : ''}"]
# 			end.flatten.join
# 			puts "  ]"
# 			# lose the vec!, restore [,]
# 			'[' + pairs + ']'
# 		end

		# md 1 (2): head, '[', 3 (4,5): pairs, ']'
# 		re_square_pairs = 
# 			/(vec!|&)?\[(\s*#{re_string_pairs})\]/
# 		re_square_pairs_flat = 
# 			/(vec!|&)?\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\]/

    # or empty vec!
		re_square_pairs = 
			/(vec!|&)?\[(\s*#{re_string_pairs}?)\](\s*,?\s*)/ # re_string_pairs now opt
		re_square_pairs_flat = 
			/(vec!|&)?\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)*)\](\s*,?\s*)/
#    chgd + to * -->                                                       ^
# 		re_square_pairs = 
# 			/(vec!|&)?\[(\s*#{re_string_pairs})\](\s*,?\s*)/
# 		re_square_pairs_flat = 
# 			/(vec!|&)?\[(\s*(\(\s*"(\\"|[^"])*"\s*,\s*"(\\"|[^"])*"\s*\)\s*,?\s*)+)\](\s*,?\s*)/

		s.gsubb(re_square_pairs) do |md|
		# capture full () and trim ends, pair[1...-1]
			puts "  ["
# 			pairs = md[2].split(/(#{re_string_pair})/).each_slice(4).map do |comma, pair, _| 
			###pairs = md[2].split(/(#{re_string_pair})/).tap{|o| 
			###	puts "    #{o.inspect}"}.each_slice(4).map do |comma, pair, _| 
			pairs = md[2].split(/(#{re_string_pair})/).each_slice(4).map do |comma, pair, _| 
# 			pairs = md[2].split(/(#{re_string_pair})/).each_slice(4).map do |comma, pair, _| 
				puts "    [#{comma.inspect}, #{pair.inspect}]"
				
				[comma, "#{pair ? '[' + pair[1...-1] + ']' : ''}"]
			end.flatten.join
			puts "  ]"
			# lose the vec!, restore [,]
			'[' + pairs + ']' + md[6]
		end
	end

	def preprocess_query(s, m)
# 		s = s.gsub(/(allocations::record\(\|\| {)/, '# \1')
# 			.gsub(/^((    )}\);?)/, '\2# \1')
# 			.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src

		###s = s.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src

		# just lucky no { inside hash!!!
		# /QueryError {([^}]*)}/, 'QueryError::new({\1})'
		#		=> TreeSitterFFI::QueryError.new({params})
		s = s.gsub(/.unwrap_err\(\)\n?/, '')
			.gsub(/QueryError {([^}]*)}/, 'QueryError::new({\1})') # so :: will get -> TreeFFI.

#     s = preprocess_square_capture(s, m)
    
		s = preprocess_captures(s, m)
		# and the string_pair seqs outside captures, if any
		s = preprocess_square_pairs(s, m)
		
		# now rm any remaining & in assert_(eq/matches) params, guard strings
		re_asserts = /assert_(eq!|query_matches)\((("(\\"|[^"])*"|[^;])*);/
		s = s.gsubb(re_asserts) do |md|
			tidy = md[2]
			
      tidy = tidy.gsub(/&(\w+\s*,)/, '\1')
        .gsub(/&\[/, '[')

			"assert_#{md[1]}(#{tidy};" # put back ; now and cut it in one sweep
		end

		# also rm any remaining & in method call params, guard strings
		# (capture 'matches' to keep capture numbers the same as re_asserts)
		# list methods for now... cursor.matches, parser.parse
		re_call_params = /\.(matches|parse)\((("(\\"|[^"])*"|[^;])*);/
		s = s.gsubb(re_call_params) do |md|
			tidy = md[2]
			
      tidy = tidy.gsub(/&(\w+\s*,)/, '\1')
        .gsub(/&\[/, '[')

			".#{md[1]}(#{tidy};" # put back ; now and cut it in one sweep
		end
		
#     tidy = md[2].split(/(&?("(\\"|[^"])*"))/).each_slice(4).map do |oth, _, str, _| 
#       # group by 2 specified captures plus split-keep-separator
# # 				[oth.gsub(/(^|\s)&([\w\["])/, '\1\2'), str]
#       [oth, str]
#     end.flatten.join
    # this will get &str anywhere but guard &&
    s = s.gsub(/([^&])&("(\\"|[^"])*")/, '\1\2')
		
		s = s.gsub(/(allocations::record\(\|\| {)/, '# \1')
			.gsub(/^((    )}\);?)/, '\2# \1')

  # leave this until main guts bc we'll break again guarding string, comment anyway!!!
		s = s.gsub(/r#"(("[^#]|[^"])*)"#/, '%q%\1% ') # bc % not in rust src
		
			# find all r#str with ; => 6
			# r#"(("[^#;]|[^";])*"?;("[^#]|[^"])*)"#
			# all together => 78
			# r#"(("[^#]|[^"])*)"#

		s
		
		### note the eeks might get garbled despite skip!!!
		
# this was earlier
=begin		
		# only these have vec!vec!, have skip_fn disable for now!!! /vec!(\[[^\]]*vec!)+/
		# but we want to process paren inside vec! others so ALSO skip these here and
		# do the rest
		eek = ["test_query_matches_with_many_results",
			"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
			"test_query_matches_with_alternatives_and_too_many_permutations_to_track"]
		unless eek.include?(m)
			# assumes no nested paren, maybe else...
			# within a single-level vec!, this gathers the list of paren'd elements in md[1]
# 			re = /vec!\[\s*((\([^)]*\),?\s*)*)\]/
			re = /vec!\[(\s*(\([^)]*\),?\s*)*)\]/ # capture lead, end space* in paren group

# 			s = s.gsubb(re) do |md, re|
			s = s.gsubb(re_paren_vec_bang_flat) do |md, re|
# 			s = s.gsubb(re_paren_vec_bang) do |md, re|
				arrs = md[1].split(/(\s*\([^)]*\)\s*,\s*)/).map do |e|
					e.gsub(/^(\s*)\(([^)]*)\)(,?\s*)$/, '\1[\2]\3')
				end
				'[' + arrs.reject{|e| e == ''}.join + ']'
			end
		end
=end		
	end	

	def tmp_skip_fn_query(boss, m)
		# m NOT commented out will be skipped!!!
		name = m.scan(/[^\(]*/).first
		[
			# query, prob need to recreate these
	# 		"test_query_errors_on_invalid_syntax",
	# 		"test_query_errors_on_invalid_symbols",
	
			"test_query_errors_on_invalid_predicates",
# 	
# 	# 		"test_query_errors_on_impossible_patterns",
# 	# 		"test_query_verifies_possible_patterns_with_aliased_parent_nodes",
# 	# 		"test_query_matches_with_simple_pattern",
# 	# 		"test_query_matches_with_multiple_on_same_root",
# 	# 		"test_query_matches_with_multiple_patterns_different_roots",
# 	# 		"test_query_matches_with_multiple_patterns_same_root",
# 	# 		"test_query_matches_with_nesting_and_no_fields",
# 	# 		"test_query_matches_with_many_results",
# 			"test_query_matches_with_many_overlapping_results",
# 	# 		"test_query_matches_capturing_error_nodes",
# 	# 		"test_query_matches_with_extra_children",
# 			"test_query_matches_with_named_wildcard",
# # 			"test_query_matches_with_wildcard_at_the_root", ### anchor op '.'
# # 			"test_query_matches_with_immediate_siblings", ### anchor op '.'
# # 			"test_query_matches_with_last_named_child", ### anchor op '.'
# 
# 			"test_query_matches_with_negated_fields", ### anchor op '.'
# # 			"test_query_matches_with_field_at_root",
# 			"test_query_matches_with_repeated_leaf_nodes", ### anchor op '.'
# # 			"test_query_matches_with_optional_nodes_inside_of_repetitions",
# # 			"test_query_matches_with_top_level_repetitions",
# # 			"test_query_matches_with_non_terminal_repetitions_within_root",
# # 			"test_query_matches_with_nested_repetitions",
# # 			"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
# # 			"test_query_matches_with_trailing_repetitions_of_last_child",
# 			"test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes", ### anchor op '.'
# # 			"test_query_matches_with_trailing_optional_nodes",
# # 			"test_query_matches_with_nested_optional_nodes",
# # 			"test_query_matches_with_repeated_internal_nodes",
# # 			"test_query_matches_with_simple_alternatives",
# 			"test_query_matches_with_alternatives_in_repetitions", ### anchor op '.'
# # 			"test_query_matches_with_alternatives_at_root",
# # 			"test_query_matches_with_alternatives_under_fields",
# # 			"test_query_matches_in_language_with_simple_aliases",
# # 			"test_query_matches_with_different_tokens_with_the_same_string_value",
# 			"test_query_matches_with_too_many_permutations_to_track",
# # 			"test_query_matches_with_alternatives_and_too_many_permutations_to_track",
# # # 			"test_query_matches_with_anonymous_tokens",
# # # 			"test_query_matches_with_supertypes",
# 
# # 			"test_query_matches_within_byte_range",
# 
# 			"test_query_matches_within_point_range",
# 			"test_query_captures_within_byte_range",
# # 			"test_query_matches_with_unrooted_patterns_intersecting_byte_range",
# 			"test_query_captures_within_byte_range_assigned_after_iterating",
# # 			"test_query_matches_different_queries_same_cursor",
# 			"test_query_matches_with_multiple_captures_on_a_node",
# 
# ### match_capture_names_and_rows...
			"test_query_matches_with_captured_wildcard_at_root",

# 			"test_query_matches_with_no_captures",
# 			"test_query_matches_with_repeated_fields",
			"test_query_matches_with_deeply_nested_patterns_with_fields",  ### anchor op '.'
# 			"test_query_matches_with_indefinite_step_containing_no_captures",

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

# 			"test_query_comments",
# 			"test_query_disable_pattern",
# 			"test_query_alternative_predicate_prefix",
			"test_query_step_is_definite",

			"assert_query_matches",
			"collect_matches<'a>",
			"collect_captures<'a>",
			"format_captures<'a>",

			].include?(name) || name =~ /&|Vec/ ||
			["test_query_matches_with_many_results",
			"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
			"test_query_matches_with_alternatives_and_too_many_permutations_to_track"
			].include?(name)

			# disable any calls that contain '&', 'Vec'
	end
	def skip_fn_query(boss, m)
		# m NOT commented out will be skipped!!!
		name = m.scan(/[^\(]*/).first
		[
			# query, prob need to recreate these
	# 		"test_query_errors_on_invalid_syntax",
	# 		"test_query_errors_on_invalid_symbols",
	
			"test_query_errors_on_invalid_predicates",
	
	# 		"test_query_errors_on_impossible_patterns",
	# 		"test_query_verifies_possible_patterns_with_aliased_parent_nodes",
	# 		"test_query_matches_with_simple_pattern",
	# 		"test_query_matches_with_multiple_on_same_root",
	# 		"test_query_matches_with_multiple_patterns_different_roots",
	# 		"test_query_matches_with_multiple_patterns_same_root",
	# 		"test_query_matches_with_nesting_and_no_fields",
	# 		"test_query_matches_with_many_results",
			"test_query_matches_with_many_overlapping_results",
	# 		"test_query_matches_capturing_error_nodes",
	# 		"test_query_matches_with_extra_children",
			"test_query_matches_with_named_wildcard",
# 			"test_query_matches_with_wildcard_at_the_root", ### anchor op '.'
# 			"test_query_matches_with_immediate_siblings", ### anchor op '.'
# 			"test_query_matches_with_last_named_child", ### anchor op '.'

# 			"test_query_matches_with_negated_fields", ### anchor op '.'
# 			"test_query_matches_with_field_at_root",
# 			"test_query_matches_with_repeated_leaf_nodes", ### anchor op '.'
# 			"test_query_matches_with_optional_nodes_inside_of_repetitions",
# 			"test_query_matches_with_top_level_repetitions",
# 			"test_query_matches_with_non_terminal_repetitions_within_root",
# 			"test_query_matches_with_nested_repetitions",
# 			"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
# 			"test_query_matches_with_trailing_repetitions_of_last_child",
# 			"test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes", ### anchor op '.'
# 			"test_query_matches_with_trailing_optional_nodes",
# 			"test_query_matches_with_nested_optional_nodes",
# 			"test_query_matches_with_repeated_internal_nodes",
# 			"test_query_matches_with_simple_alternatives",
# 			"test_query_matches_with_alternatives_in_repetitions", ### anchor op '.'
# 			"test_query_matches_with_alternatives_at_root",
# 			"test_query_matches_with_alternatives_under_fields",
# 			"test_query_matches_in_language_with_simple_aliases",
# 			"test_query_matches_with_different_tokens_with_the_same_string_value",
			"test_query_matches_with_too_many_permutations_to_track",
# 			"test_query_matches_with_alternatives_and_too_many_permutations_to_track",
# # 			"test_query_matches_with_anonymous_tokens",
# # 			"test_query_matches_with_supertypes",

# 			"test_query_matches_within_byte_range",

			"test_query_matches_within_point_range",
			"test_query_captures_within_byte_range",
# 			"test_query_matches_with_unrooted_patterns_intersecting_byte_range",
			"test_query_captures_within_byte_range_assigned_after_iterating",
# 			"test_query_matches_different_queries_same_cursor",
			"test_query_matches_with_multiple_captures_on_a_node",

### match_capture_names_and_rows...
			"test_query_matches_with_captured_wildcard_at_root",

# 			"test_query_matches_with_no_captures",
# 			"test_query_matches_with_repeated_fields",
# 			"test_query_matches_with_deeply_nested_patterns_with_fields",  ### anchor op '.'
# 			"test_query_matches_with_indefinite_step_containing_no_captures",

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

# 			"test_query_comments",
# 			"test_query_disable_pattern",
# 			"test_query_alternative_predicate_prefix",
			"test_query_step_is_definite",

			"assert_query_matches",
			"collect_matches<'a>",
			"collect_captures<'a>",
			"format_captures<'a>",

			].include?(name) || name =~ /&|Vec/ ||
			["test_query_matches_with_many_results",
			"test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern",
			"test_query_matches_with_alternatives_and_too_many_permutations_to_track"
			].include?(name)

			# disable any calls that contain '&', 'Vec'
	end
end
