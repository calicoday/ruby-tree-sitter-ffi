# extract ^[\t ]*\[(:ts_\w+),([^\n]*) to \t\twhen \1 #\2


# 		wrap_attach(:ts_node_, [
# 			[:ts_node_type, [Node.by_value], :string],
# 			[:ts_node_symbol, [Node.by_value], :uint16],
#       ])

# if a function returns anything, we need to confirm the type of the return,
# so we need to call with args that will nominally succeed.
# if we don't know what args are acceptable, we can set :nil_permitted to punt.
# :nil_permitted might be helpful later too, for higher level tests or docs???
# if we can determine any arg will do, we can generate with default per type, eg int: 7,
# String: "blurg"...

### so we can't do default args yet and so specifying with objects not strings
# is a problem. Just pass obj (args)? as strings for now!!!

class NodeSigsPrep
  def before
		before = %q%
      @pars = TreeSitterFFI.parser
      json = TreeSitterFFI.parser_json
      @pars.set_language(json).should == true
      @input = "[1, null]"
      @tree = @pars.parse_string(nil, @input, @input.length)
      @root_node = @tree.root_node
      @array_node = @root_node.named_child(0)
      @number_node = @array_node.named_child(0)
      %
    before.split("\n").map(&:strip).reject{|e| e.empty?}
  end
  
  def fn(c_name_sym)
#     puts "=== fn c_name_sym: #{c_name_sym.inspect}"
    # => obj
    # => call
    # => [obj_or_call, [arg_1, arg_2], :nil_permitted]
    case c_name_sym
		when :ts_node_type # [Node.by_value], :string],
		  '@number_node'
		when :ts_node_symbol # [Node.by_value], :uint16],
		  '@number_node'
		when :ts_node_start_byte # [Node.by_value], :uint32],
		  '@number_node'


		when :ts_node_start_point # [Node.by_value], Point.by_value],
		  '@number_node'
		when :ts_node_end_byte # [Node.by_value], :uint32],
		  '@number_node'
		when :ts_node_end_point # [Node.by_value], Point.by_value],
		  '@number_node'
	
			# not sure how best to do this. We need a pointer to wrap for freeing
			# and a string to return. Is a subclass equiv to :strptr poss???
			# for now, wrap attach AND override the rb_name form here
			# ts_ form in TreeSitterFFI will return [:string, :pointer]!!!
		when :ts_node_string # [Node.by_value], :adoptstring], # typedefd :strptr
		  nil #'@number_node'

		when :ts_node_is_null # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_is_named # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_is_missing # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_is_extra # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_has_changes # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_has_error # [Node.by_value], :bool],
		  '@number_node'
		when :ts_node_parent # [Node.by_value], Node.by_value],
		  '@number_node'
	
		when :ts_node_child # [Node.by_value, :uint32], Node.by_value],
		  ['@array_node', '3']
		when :ts_node_field_name_for_child # [Node.by_value, :uint32], :string],
		  nil #['@array_node', '3']
		when :ts_node_child_count # [Node.by_value], :uint32],
		  '@array_node'
		when :ts_node_named_child # [Node.by_value, :uint32], Node.by_value],
		  ['@array_node', '0']
		when :ts_node_named_child_count # [Node.by_value], :uint32],
		  '@array_node'
	
		when :ts_node_child_by_field_name # 
				# [Node.by_value, :string, :uint32], 
				# Node.by_value],
		  nil #['@number_node', '"blurg", 2', :nil_permitted]
# 		  ['@number_node', ["blurg", 2], :nil_permitted]
		when :ts_node_child_by_field_id # [Node.by_value, :field_id], Node.by_value],
		  nil #['@number_node', '2', :nil_permitted]

		when :ts_node_next_sibling # [Node.by_value], Node.by_value],
		  '@number_node'
		when :ts_node_prev_sibling # [Node.by_value], Node.by_value],
		  '@number_node'
		when :ts_node_next_named_sibling # [Node.by_value], Node.by_value],
		  '@number_node'
		when :ts_node_prev_named_sibling # [Node.by_value], Node.by_value],
		  nil #'@number_node'

		when :ts_node_first_child_for_byte # [Node.by_value, :uint32], Node.by_value],
      # array_node offset 5 should be at 'u', ie "[1, n^ull]"
		  ['@array_node', '5']
		when :ts_node_first_named_child_for_byte # [Node.by_value, :uint32], Node.by_value],
      # array_node offset 1 should be at '1', ie "[^1, null]"
		  ['@array_node', '1']
		when :ts_node_descendant_for_byte_range # 
				# [Node.by_value, :uint32, :uint32], 
				# Node.by_value],
      # array_node offset 2 should be at ',', ie "[1^, null]"
		  ['@array_node', '2, 3']
		when :ts_node_descendant_for_point_range # 
				# [Node.by_value, Point.by_value, Point.by_value], 
				# Node.by_value],
      # array_node offset 5 should be at 'u', ie "[1, n^ull]"
#         '@array_node' # no default args yet!!!
        ['@array_node', 'TreeSitterFFI::Point.new, TreeSitterFFI::Point.new']
		when :ts_node_named_descendant_for_byte_range # 
				# [Node.by_value, :uint32, :uint32], 
				# Node.by_value],
		  ['@number_node', '5, 7']
		when :ts_node_named_descendant_for_point_range # 
				# [Node.by_value, Point.by_value, Point.by_value], 
				# Node.by_value],
		  ['@number_node', 'TreeSitterFFI::Point.new, TreeSitterFFI::Point.new']

		when :ts_node_edit # [Node.by_ref, InputEdit.by_ref], :void], ### mem???
		  ['@number_node', 'TreeSitterFFI::InputEdit.new']
		when :ts_node_eq # [Node.by_value, Node.by_value], :bool],
	    ['@number_node', 'TreeSitterFFI::Node.new']
	    # nope, got confused, we can do this one too
	    # TBD special case -- wait up, all bool returns work the same??? prob!!!
		else
    end
  end
end