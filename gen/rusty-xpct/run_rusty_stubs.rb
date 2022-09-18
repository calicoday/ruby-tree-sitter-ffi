# run the rusty test with this script, generated by src/rusty/gen_rusty.rb,
# from the project dir, like so:
# ruby src/run_rusty.rb

require './src/run_rusty_helper.rb'
require './src/rusty/query_util.rb'

require './gen/rusty/rusty_node_patch_blank.rb'
require './gen/rusty/rusty_query_patch_blank.rb'


require './gen/rusty/rusty_node_test.rb'

puts './gen/rusty/rusty_node_test.rb'
init_tally()
test_node_child()
test_node_children()
test_node_children_by_field_name()
test_node_parent_of_child_by_field_name()
test_node_field_name_for_child()
test_node_child_by_field_name_with_extra_hidden_children()
test_node_named_child()
test_node_named_child_with_aliases_and_extras()
test_node_descendant_for_range()
test_node_edit()
test_node_is_extra()
test_node_sexp()
test_node_field_names()
test_node_field_calls_in_language_without_fields()
test_node_is_named_but_aliased_as_anonymous()
test_node_numeric_symbols_respect_simple_aliases()
parse_json_example()
report_tally()


require './gen/rusty/rusty_tree_test.rb'

puts './gen/rusty/rusty_tree_test.rb'
init_tally()
test_tree_edit()
test_tree_cursor()
test_tree_cursor_fields()
test_tree_cursor_child_for_point()
test_tree_node_equality()
report_tally()


require './gen/rusty/rusty_query_test.rb'

puts './gen/rusty/rusty_query_test.rb'
init_tally()
test_query_errors_on_invalid_syntax()
test_query_errors_on_invalid_symbols()
test_query_errors_on_invalid_predicates()
test_query_errors_on_impossible_patterns()
test_query_verifies_possible_patterns_with_aliased_parent_nodes()
test_query_matches_with_simple_pattern()
test_query_matches_with_multiple_on_same_root()
test_query_matches_with_multiple_patterns_different_roots()
test_query_matches_with_multiple_patterns_same_root()
test_query_matches_with_nesting_and_no_fields()
test_query_matches_with_many_results()
test_query_matches_with_many_overlapping_results()
test_query_matches_capturing_error_nodes()
test_query_matches_with_extra_children()
test_query_matches_with_named_wildcard()
test_query_matches_with_wildcard_at_the_root()
test_query_matches_with_immediate_siblings()
test_query_matches_with_last_named_child()
test_query_matches_with_negated_fields()
test_query_matches_with_field_at_root()
test_query_matches_with_repeated_leaf_nodes()
test_query_matches_with_optional_nodes_inside_of_repetitions()
test_query_matches_with_top_level_repetitions()
test_query_matches_with_non_terminal_repetitions_within_root()
test_query_matches_with_nested_repetitions()
test_query_matches_with_multiple_repetition_patterns_that_intersect_other_pattern()
test_query_matches_with_trailing_repetitions_of_last_child()
test_query_matches_with_leading_zero_or_more_repeated_leaf_nodes()
test_query_matches_with_trailing_optional_nodes()
test_query_matches_with_nested_optional_nodes()
test_query_matches_with_repeated_internal_nodes()
test_query_matches_with_simple_alternatives()
test_query_matches_with_alternatives_in_repetitions()
test_query_matches_with_alternatives_at_root()
test_query_matches_with_alternatives_under_fields()
test_query_matches_in_language_with_simple_aliases()
test_query_matches_with_different_tokens_with_the_same_string_value()
test_query_matches_with_too_many_permutations_to_track()
test_query_matches_with_alternatives_and_too_many_permutations_to_track()
test_query_matches_with_anonymous_tokens()
test_query_matches_with_supertypes()
test_query_matches_within_byte_range()
test_query_matches_within_point_range()
test_query_captures_within_byte_range()
test_query_matches_with_unrooted_patterns_intersecting_byte_range()
test_query_captures_within_byte_range_assigned_after_iterating()
test_query_matches_different_queries_same_cursor()
test_query_matches_with_multiple_captures_on_a_node()
test_query_matches_with_captured_wildcard_at_root()
test_query_matches_with_no_captures()
test_query_matches_with_repeated_fields()
test_query_matches_with_deeply_nested_patterns_with_fields()
test_query_matches_with_indefinite_step_containing_no_captures()
test_query_captures_basic()
test_query_captures_with_text_conditions()
test_query_captures_with_predicates()
test_query_captures_with_quoted_predicate_args()
test_query_captures_with_duplicates()
test_query_captures_with_many_nested_results_without_fields()
test_query_captures_with_many_nested_results_with_fields()
test_query_captures_with_too_many_nested_results()
test_query_captures_with_definite_pattern_containing_many_nested_matches()
test_query_captures_ordered_by_both_start_and_end_positions()
test_query_captures_with_matches_removed()
test_query_captures_and_matches_iterators_are_fused()
test_query_text_callback_returns_chunks()
test_query_start_byte_for_pattern()
test_query_capture_names()
test_query_lifetime_is_separate_from_nodes_lifetime()
test_query_with_no_patterns()
test_query_comments()
test_query_disable_pattern()
test_query_alternative_predicate_prefix()
test_query_step_is_definite()
report_tally()

puts 'done.'