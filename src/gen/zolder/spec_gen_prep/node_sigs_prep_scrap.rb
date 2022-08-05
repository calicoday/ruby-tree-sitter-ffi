# extract ^[\t ]*\[(:ts_\w+),([^\n]*) to \t\twhen \1 #\2


		wrap_attach(:ts_node_, [
			[:ts_node_type, [Node.by_value], :string],
			[:ts_node_symbol, [Node.by_value], :uint16],
      ])

			
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
    # before.split("\n").map(&:strip).reject{|e| e.empty?}

    case fn
    when :ts_node_type, :ts_node_symbol, :ts_node_start_byte, :ts_node_start_point, 
      :ts_node_end_byte, :ts_node_end_point, :ts_node_string, :ts_node_is_null, 
      :ts_node_is_named, :ts_node_is_missing, :ts_node_is_extra, :ts_node_has_changes, 
      :ts_node_has_error, :ts_node_parent # MUST NOT have comma here!!!
      "@number"
    when :ts_node_child, :ts_node_field_name_for_child, :ts_node_child_count, :ts_node_named_child, :ts_node_named_child_count, :ts_node_child_by_field_name, :ts_node_child_by_field_id, :ts_node_next_sibling, :ts_node_prev_sibling, :ts_node_next_named_sibling, :ts_node_prev_named_sibling, :ts_node_first_child_for_byte, :ts_node_first_named_child_for_byte, :ts_node_descendant_for_byte_range, :ts_node_descendant_for_point_range, :ts_node_named_descendant_for_byte_range, :ts_node_named_descendant_for_point_range, :ts_node_edit, :ts_node_eq
    else
    end

    # => obj
    # => call
    # => [obj_or_call, [arg_1, arg_2], :nil_permitted]
    case fn
		when :ts_node_type # [Node.by_value], :string],
		  "@number_node"
		when :ts_node_symbol # [Node.by_value], :uint16],
		  "@number_node"
		when :ts_node_start_byte # [Node.by_value], :uint32],
		  "@number_node"


		when :ts_node_start_point # [Node.by_value], Point.by_value],
		  "@number_node"
		when :ts_node_end_byte # [Node.by_value], :uint32],
		  "@number_node"
		when :ts_node_end_point # [Node.by_value], Point.by_value],
		  "@number_node"
	
			# not sure how best to do this. We need a pointer to wrap for freeing
			# and a string to return. Is a subclass equiv to :strptr poss???
			# for now, wrap attach AND override the rb_name form here
			# ts_ form in TreeSitterFFI will return [:string, :pointer]!!!
		when :ts_node_string # [Node.by_value], :adoptstring], # typedefd :strptr
		  "@number_node"

		when :ts_node_is_null # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_is_named # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_is_missing # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_is_extra # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_has_changes # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_has_error # [Node.by_value], :bool],
		  "@number_node"
		when :ts_node_parent # [Node.by_value], Node.by_value],
		  "@number_node"
	
		when :ts_node_child # [Node.by_value, :uint32], Node.by_value],
		  ["@array_node", [3]]
		when :ts_node_field_name_for_child # [Node.by_value, :uint32], :string],
		  "@array_node"
		when :ts_node_child_count # [Node.by_value], :uint32],
		  "@array_node"
		when :ts_node_named_child # [Node.by_value, :uint32], Node.by_value],
		  "@array_node"
		when :ts_node_named_child_count # [Node.by_value], :uint32],
		  "@array_node"
	
		when :ts_node_child_by_field_name # 
				# [Node.by_value, :string, :uint32], 
				# Node.by_value],
		  "@number_node"
		when :ts_node_child_by_field_id # [Node.by_value, :field_id], Node.by_value],
		  "@number_node"

		when :ts_node_next_sibling # [Node.by_value], Node.by_value],
		  "@number_node"
		when :ts_node_prev_sibling # [Node.by_value], Node.by_value],
		  "@number_node"
		when :ts_node_next_named_sibling # [Node.by_value], Node.by_value],
		  "@number_node"
		when :ts_node_prev_named_sibling # [Node.by_value], Node.by_value],
		  "@number_node"

		when :ts_node_first_child_for_byte # [Node.by_value, :uint32], Node.by_value],
		  "@array_node"
		when :ts_node_first_named_child_for_byte # [Node.by_value, :uint32], Node.by_value],
		  "@array_node"
		when :ts_node_descendant_for_byte_range # 
				# [Node.by_value, :uint32, :uint32], 
				# Node.by_value],
		  "@array_node"
		when :ts_node_descendant_for_point_range # 
				# [Node.by_value, Point.by_value, Point.by_value], 
				# Node.by_value],
		  "@array_node"
		when :ts_node_named_descendant_for_byte_range # 
				# [Node.by_value, :uint32, :uint32], 
				# Node.by_value],
		  "@number_node"
		when :ts_node_named_descendant_for_point_range # 
				# [Node.by_value, Point.by_value, Point.by_value], 
				# Node.by_value],
		  "@number_node"

		when :ts_node_edit # [Node.by_ref, InputEdit.by_ref], :void], ### mem???
		  "@number_node"
		when :ts_node_eq # [Node.by_value, Node.by_value], :bool],
	
		else
    end
