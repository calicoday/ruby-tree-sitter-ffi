require './src/rusty/rusty_prep_boss.rb'

# boss for each rusty test file, here tree_test.rs

class RustyTree < RustyBoss

	# for commenting out def and call of troublesome functions during dev
	# => nil or a why String
	def skip_fn(m)
		# m NOT commented out will be skipped!!!
		# return nil for functions NOT to be skipped by commenting them out
		# and letting them fall through to else, so they are visual distinctive
		# comment them out so they fall through to else.
		name = m.scan(/[^\(]*/).first
		case name
			# tree
#     when "test_tree_edit" then nil
#     when "test_tree_cursor" then nil
#     when "test_tree_cursor_fields" then nil
#     when "test_tree_node_equality" then nil
#     when "test_tree_cursor_child_for_point" then nil
		when "test_get_changed_ranges" then "[internal]"
		when "index_of" then "[internal]"
		when "range_of" then "[internal]"
		when "get_changed_ranges" then "[internal], patch"

    # common
		when /&|Vec/ then "&|Vec"
			# disable any calls that contain '&', 'Vec'
		else
		  nil
		end
	end

	def preprocess(s, m)
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
# 			puts "var: #{var}"
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


end