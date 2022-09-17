require './src/gen/rusty_gen_boss.rb'

# boss for each rusty test file, here node_test.rs

class RustyNode < RustyBoss
	# for commenting out def and call of troublesome functions during dev
	# => nil or a why String
	def skip_fn(m)
		# m NOT commented out will be skipped!!!
		# return nil for functions NOT to be skipped by commenting them out
		# and letting them fall through to else, so they are visual distinctive
		# comment them out so they fall through to else.
		name = m.scan(/[^\(]*/).first
		case name
    # node
		when "test_node_children" then "patch"
		when "test_node_children_by_field_name" then "patch"
#     when "test_node_parent_of_child_by_field_name" then nil
#     when "test_node_child_by_field_name_with_extra_hidden_children" then nil
		when "test_node_named_child_with_aliases_and_extras" then "generate"
		when "test_node_edit" then "patch" # rusty
		when "test_node_field_names" then "generate" # generate
		when "test_node_field_calls_in_language_without_fields" then "generate"
		when "test_node_is_named_but_aliased_as_anonymous" then "generate"
# 		when "test_node_numeric_symbols_respect_simple_aliases" then nil
		when "get_all_nodes" then "[internal]"

    # common
		when /&|Vec/ then "&|Vec"
			# disable any calls that contain '&', 'Vec'
		else
		  nil
		end

# 			].include?(name) || name =~ /&|Vec/
	end


end