class NodeSigsPrep
  def before
  end
  
  def fn(c_name_sym)
    case name
		when :ts_node_type then 
		when :ts_node_symbol then 
		when :ts_node_start_byte then 

		when :ts_node_start_point then 
		when :ts_node_end_byte then 
		when :ts_node_end_point then 
	
			# not sure how best to do this. We need a pointer to wrap for freeing
			# and a string to return. Is a subclass equiv to :strptr poss???
			# for now, wrap attach AND override the rb_name form here
			# ts_ form in TreeSitterFFI will return [:string, :pointer]!!!
		when :ts_node_string then 

		when :ts_node_is_null then 
		when :ts_node_is_named then 
		when :ts_node_is_missing then 
		when :ts_node_is_extra then 
		when :ts_node_has_changes then 
		when :ts_node_has_error then 
		when :ts_node_parent then 
	
		when :ts_node_child then 
		when :ts_node_field_name_for_child then 
		when :ts_node_child_count then 
		when :ts_node_named_child then 
		when :ts_node_named_child_count then 
	
		when :ts_node_child_by_field_name then 
# 				[Node.by_value, :string, :uint32], 
# 				Node.by_value],
		when :ts_node_child_by_field_id then 

		when :ts_node_next_sibling then 
		when :ts_node_prev_sibling then 
		when :ts_node_next_named_sibling then 
		when :ts_node_prev_named_sibling then 

		when :ts_node_first_child_for_byte then 
		when :ts_node_first_named_child_for_byte then 
		when :ts_node_descendant_for_byte_range then 
# 				[Node.by_value, :uint32, :uint32], 
# 				Node.by_value],
		when :ts_node_descendant_for_point_range then 
# 				[Node.by_value, Point.by_value, Point.by_value], 
# 				Node.by_value],
		when :ts_node_named_descendant_for_byte_range then 
# 				[Node.by_value, :uint32, :uint32], 
# 				Node.by_value],
		when :ts_node_named_descendant_for_point_range then 
# 				[Node.by_value, Point.by_value, Point.by_value], 
# 				Node.by_value],

		when :ts_node_edit then 
		when :ts_node_eq then 
		else
		  nil
	  end
  end
end