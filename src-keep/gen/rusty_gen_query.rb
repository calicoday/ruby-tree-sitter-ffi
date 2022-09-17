require './src/gen/rusty_gen_boss.rb'

### from Jubify
class String
	def gsubb(re, &b) gsub(re){|s| yield(re.match(s), re)} end
end
# 		line = line.gsubb(/<([^>]+)>/){|md| "<#{md[1].gsub(/\s+/, '_')}>"}


# boss for each rusty test file, here query_test.rs

class RustyQuery < RustyBoss

  # let all pass for finding still problems
	def no_skip_fn(m)
		# m NOT commented out will be skipped!!!
		name = m.scan(/[^\(]*/).first
		case name
		when "test_query_errors_on_invalid_syntax" then nil
		when "test_query_errors_on_invalid_symbols" then nil
		when "test_query_errors_on_invalid_predicates" then nil
		when "test_query_errors_on_impossible_patterns" then nil
		when "test_query_verifies_possible_patterns_with_aliased_parent_nodes" then nil
		when "test_query_matches_with_simple_pattern" then nil
		when "test_query_matches_with_multiple_on_same_root" then nil
		when "test_query_matches_with_multiple_patterns_different_roots" then nil
		when "test_query_matches_with_multiple_patterns_same_root" then nil
		when "test_query_matches_with_nesting_and_no_fields" then nil
		when "test_query_matches_with_many_results" then nil
		when "test_query_matches_with_many_overlapping_results" then nil
		when "test_query_matches_capturing_error_nodes" then nil
		when "test_query_matches_with_extra_children" then nil
		when "test_query_matches_with_named_wildcard" then nil
		when "test_query_matches_with_wildcard_at_the_root" then nil
		when "test_query_matches_with_immediate_siblings" then nil
		when "test_query_matches_with_last_named_child" then nil
		when "test_query_matches_with_negated_fields" then nil
		when "test_query_matches_with_field_at_root" then nil
		when "test_query_matches_with_repeated_leaf_nodes" then nil
		when "test_query_matches_with_optional_nodes_inside_of_repetitions" then nil
		when "test_query_matches_with_top_level_repetitions" then nil
		when "test_query_matches_with_non_terminal_repetitions_within_root" then nil
		when "test_query_matches_with_nested_repetitions" then nil
		when "test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern" then nil
		when "test_query_matches_with_trailing_repetitions_of_last_child" then nil
		when "test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes" then nil
		when "test_query_matches_with_trailing_optional_nodes" then nil
		when "test_query_matches_with_nested_optional_nodes" then nil
		when "test_query_matches_with_repeated_internal_nodes" then nil
		when "test_query_matches_with_simple_alternatives" then nil
		when "test_query_matches_with_alternatives_in_repetitions" then nil
		when "test_query_matches_with_alternatives_at_root" then nil
		when "test_query_matches_with_alternatives_under_fields" then nil
		when "test_query_matches_in_language_with_simple_aliases" then nil
		when "test_query_matches_with_different_tokens_with_the_same_string_value" then nil
		when "test_query_matches_with_too_many_permutations_to_track" then nil
		when "test_query_matches_with_alternatives_and_too_many_permutations_to_track" then nil
		when "test_query_matches_with_anonymous_tokens" then nil
		when "test_query_matches_with_supertypes" then nil
		when "test_query_matches_within_byte_range" then nil
		when "test_query_matches_within_point_range" then nil
		when "test_query_captures_within_byte_range" then nil
		when "test_query_matches_with_unrooted_patterns_intersecting_byte_range" then nil
		when "test_query_captures_within_byte_range_assigned_after_iterating" then nil
		when "test_query_matches_different_queries_same_cursor" then nil
		when "test_query_matches_with_multiple_captures_on_a_node" then nil
		when "test_query_matches_with_captured_wildcard_at_root" then nil
		when "test_query_matches_with_no_captures" then nil
		when "test_query_matches_with_repeated_fields" then nil
		when "test_query_matches_with_deeply_nested_patterns_with_fields" then nil
		when "test_query_matches_with_indefinite_step_containing_no_captures" then nil
		when "test_query_captures_basic" then nil
		when "test_query_captures_with_text_conditions" then nil
		when "test_query_captures_with_predicates" then nil
		when "test_query_captures_with_quoted_predicate_args" then nil
		when "test_query_captures_with_duplicates" then nil
		when "test_query_captures_with_many_nested_results_without_fields" then nil
		when "test_query_captures_with_many_nested_results_with_fields" then nil
		when "test_query_captures_with_too_many_nested_results" then nil
		when "test_query_captures_with_definite_pattern_containing_many_nested_matches" then nil
		when "test_query_captures_ordered_by_both_start_and_end_positions" then nil
		when "test_query_captures_with_matches_removed" then nil
		when "test_query_captures_and_matches_iterators_are_fused" then nil
		when "test_query_text_callback_returns_chunks" then nil
		when "test_query_start_byte_for_pattern" then nil
		when "test_query_capture_names" then nil
		when "test_query_lifetime_is_separate_from_nodes_lifetime" then nil
		when "test_query_with_no_patterns" then nil
		when "test_query_comments" then nil
		when "test_query_disable_pattern" then nil
		when "test_query_alternative_predicate_prefix" then nil
		when "test_query_step_is_definite" then nil
		when "assert_query_matches" then nil
		when "collect_matches" then nil
		when "collect_captures" then nil
		when "format_captures" then nil

    when /&|Vec/ then "&|Vec"
      # disable any calls that contain '&', 'Vec'
    else
      nil
    end
  end
  
	# for commenting out def and call of troublesome functions during dev
	# => nil or a why String
	def skip_fn(m)
		# m NOT commented out will be skipped!!!
		name = m.scan(/[^\(]*/).first
		case name
# 		when "test_query_errors_on_invalid_syntax" then nil
# 		when "test_query_errors_on_invalid_symbols" then nil

	    # choke: run_rusty_helper.rb:28:in `==': Invalid Memory object (ArgumentError)
		when "test_query_errors_on_invalid_predicates" then "choke, noVec"

# 		when "test_query_errors_on_impossible_patterns" then nil
# 		when "test_query_verifies_possible_patterns_with_aliased_parent_nodes" then nil
# 		when "test_query_matches_with_simple_pattern" then nil
# 		when "test_query_matches_with_multiple_on_same_root" then nil
# 		when "test_query_matches_with_multiple_patterns_different_roots" then nil
# 		when "test_query_matches_with_multiple_patterns_same_root" then nil
# 		when "test_query_matches_with_nesting_and_no_fields" then nil

		when "test_query_matches_with_many_results" then "bc why???!!!"
		when "test_query_matches_with_many_overlapping_results" then "bc why???!!!"
		
# 		when "test_query_matches_capturing_error_nodes" then nil
# 		when "test_query_matches_with_extra_children" then nil
# 		when "test_query_matches_with_named_wildcard" then nil
# 		when "test_query_matches_with_wildcard_at_the_root" then nil
# 		when "test_query_matches_with_immediate_siblings" then nil
# 		when "test_query_matches_with_last_named_child" then nil
# 		when "test_query_matches_with_negated_fields" then nil
# 		when "test_query_matches_with_field_at_root" then nil
# 		when "test_query_matches_with_repeated_leaf_nodes" then nil
# 		when "test_query_matches_with_optional_nodes_inside_of_repetitions" then nil
# 		when "test_query_matches_with_top_level_repetitions" then nil
# 		when "test_query_matches_with_non_terminal_repetitions_within_root" then nil
# 		when "test_query_matches_with_nested_repetitions" then nil

		when "test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern" then "bc why???!!!"

# 		when "test_query_matches_with_trailing_repetitions_of_last_child" then nil
# 		when "test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes" then nil
# 		when "test_query_matches_with_trailing_optional_nodes" then nil
# 		when "test_query_matches_with_nested_optional_nodes" then nil
# 		when "test_query_matches_with_repeated_internal_nodes" then nil
# 		when "test_query_matches_with_simple_alternatives" then nil
# 		when "test_query_matches_with_alternatives_in_repetitions" then nil
# 		when "test_query_matches_with_alternatives_at_root" then nil
# 		when "test_query_matches_with_alternatives_under_fields" then nil
# 		when "test_query_matches_in_language_with_simple_aliases" then nil
# 		when "test_query_matches_with_different_tokens_with_the_same_string_value" then nil

      # choke: undefined method `push_str' for #<String:0x0000000141aefed8> (NoMethodError)
		when "test_query_matches_with_too_many_permutations_to_track" then "choke, noVec"

		when "test_query_matches_with_alternatives_and_too_many_permutations_to_track" then "bc why???!!!"
		
# 		when "test_query_matches_with_anonymous_tokens" then nil
# 		when "test_query_matches_with_supertypes" then nil
# 		when "test_query_matches_within_byte_range" then nil

      # choke: rusty_query_test.rb:1759:in `test_query_matches_within_point_range': bad value for range (ArgumentError)
		when "test_query_matches_within_point_range" then "choke, noVec"

		# no method captures
# 		when "test_query_captures_within_byte_range" then nil ### new captures here!!!
# 		when "test_query_matches_with_unrooted_patterns_intersecting_byte_range" then nil

  # bad end ### is it???!!!
		when "test_query_captures_within_byte_range_assigned_after_iterating" then "bad end"

# 		when "test_query_matches_different_queries_same_cursor" then nil

      # choke: /boss.rb:30:in `ts_query_disable_capture': wrong number of arguments (2 for 3) (ArgumentError)
		when "test_query_matches_with_multiple_captures_on_a_node" then "choke, noVec"
		
### match_capture_names_and_rows...
		when "test_query_matches_with_captured_wildcard_at_root" then "match_capture_names_and_rows, last MARKER"
		
# 		when "test_query_matches_with_no_captures" then nil
# 		when "test_query_matches_with_repeated_fields" then nil
# 		when "test_query_matches_with_deeply_nested_patterns_with_fields" then nil
# 		when "test_query_matches_with_indefinite_step_containing_no_captures" then nil
# 		when "test_query_captures_basic" then nil
# 		when "test_query_captures_with_text_conditions" then nil

			# choke:
		when "test_query_captures_with_predicates" then "choke, noVec"
			# choke: rusty_query_test.rb:2563:in `test_query_captures_with_quoted_predicate_args': undefined method `property_settings' for #<TreeSitterFFI::Query address=0x000000014f2fbc20> (NoMethodError)
		when "test_query_captures_with_quoted_predicate_args" then "choke, noVec"
		
# 		when "test_query_captures_with_duplicates" then nil

		when "test_query_captures_with_many_nested_results_without_fields" then "bad end"
		when "test_query_captures_with_many_nested_results_with_fields" then "bad end, gone MARKER"

# 		when "test_query_captures_with_too_many_nested_results" then nil
# 		when "test_query_captures_with_definite_pattern_containing_many_nested_matches" then nil
		when "test_query_captures_ordered_by_both_start_and_end_positions" then "will gone MARKER"
		when "test_query_captures_with_matches_removed" then "bc why???!!!"
		when "test_query_captures_and_matches_iterators_are_fused" then "bc why???!!!"
		when "test_query_text_callback_returns_chunks" then "bc why???!!!"

# 		when "test_query_start_byte_for_pattern" then nil
		
			# choke: rusty_query_test.rb:3146:in `test_query_capture_names': undefined method `capture_names' for #<TreeSitterFFI::Query address=0x0000000135ad6080> (NoMethodError)
# Did you mean?  capture_name_for_id
		when "test_query_capture_names" then "choke, noVec"
		when "test_query_lifetime_is_separate_from_nodes_lifetime" then "noVec"
			# choke: rusty_query_test.rb:3218:in `test_query_with_no_patterns': undefined method `capture_names' for #<TreeSitterFFI::Query address=0x00000001573d57b0> (NoMethodError)
		when "test_query_with_no_patterns" then "choke, noVec"
		
# 		when "test_query_comments" then nil
# 		when "test_query_disable_pattern" then nil
# 		when "test_query_alternative_predicate_prefix" then nil

		when "test_query_step_is_definite" then "bc why???!!!"
		
		# these need regex bc <>
		when /assert_query_matches/ then "[internal]"
		when /collect_matches/ then "[internal]"
		when /collect_captures/ then "[internal]"
		when /format_captures/ then "[internal]"

    when /&|Vec/ then "&|Vec"
      # disable any calls that contain '&', 'Vec'
    else
      nil
    end
	end

	def preprocess(s, m)
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
			pairs = md[2].split(/(#{re_string_pair})/).each_slice(4).map do |comma, pair, _| 
				puts "    [#{comma.inspect}, #{pair.inspect}]"				
				[comma, "#{pair ? '[' + pair[1...-1] + ']' : ''}"]
			end.flatten.join
			puts "  ]"
			# lose the vec!, restore [,]
			'[' + pairs + ']' + md[6]
		end
	end


end