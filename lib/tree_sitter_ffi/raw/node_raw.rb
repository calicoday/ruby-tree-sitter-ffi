# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'

module TreeSitterFFI

	class Node < BossStruct
		layout(
			:context, [:uint32, 4],
			:id, :pointer,
			:tree, :pointer
# 			:tree, Tree #???
		)

		wrap_attach(:ts_node_, [
			[:ts_node_type, [Node.by_value], :string],
			[:ts_node_symbol, [Node.by_value], :uint16],
			[:ts_node_start_byte, [Node.by_value], :uint32],

			[:ts_node_start_point, [Node.by_value], Point.by_value],
			[:ts_node_end_byte, [Node.by_value], :uint32],
			[:ts_node_end_point, [Node.by_value], Point.by_value],
	
			# not sure how best to do this. We need a pointer to wrap for freeing
			# and a string to return. Is a subclass equiv to :strptr poss???
			# for now, wrap attach AND override the rb_name form here
			# ts_ form in TreeSitterFFI will return [:string, :pointer]!!!
			[:ts_node_string, [Node.by_value], :adoptstring], # typedefd :strptr

			[:ts_node_is_null, [Node.by_value], :bool],
			[:ts_node_is_named, [Node.by_value], :bool],
			[:ts_node_is_missing, [Node.by_value], :bool],
			[:ts_node_is_extra, [Node.by_value], :bool],
			[:ts_node_has_changes, [Node.by_value], :bool],
			[:ts_node_has_error, [Node.by_value], :bool],
			[:ts_node_parent, [Node.by_value], Node.by_value],
	
			[:ts_node_child, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_field_name_for_child, [Node.by_value, :uint32], :string],
			[:ts_node_child_count, [Node.by_value], :uint32],
			[:ts_node_named_child, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_named_child_count, [Node.by_value], :uint32],
	
			[:ts_node_child_by_field_name, 
				[Node.by_value, :string, :uint32], 
				Node.by_value],
			[:ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value],

			[:ts_node_next_sibling, [Node.by_value], Node.by_value],
			[:ts_node_prev_sibling, [Node.by_value], Node.by_value],
			[:ts_node_next_named_sibling, [Node.by_value], Node.by_value],
			[:ts_node_prev_named_sibling, [Node.by_value], Node.by_value],

			[:ts_node_first_child_for_byte, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_first_named_child_for_byte, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_descendant_for_byte_range, 
				[Node.by_value, :uint32, :uint32], 
				Node.by_value],
			[:ts_node_descendant_for_point_range, 
				[Node.by_value, Point.by_value, Point.by_value], 
				Node.by_value],
			[:ts_node_named_descendant_for_byte_range, 
				[Node.by_value, :uint32, :uint32], 
				Node.by_value],
			[:ts_node_named_descendant_for_point_range, 
				[Node.by_value, Point.by_value, Point.by_value], 
				Node.by_value],

			[:ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void], ### mem???
			[:ts_node_eq, [Node.by_value, Node.by_value], :bool],
	
			])

### tidy

		### override for better args/rets types

		def string
			str, ptr = TreeSitterFFI.ts_node_string(self)
			what_about_this_ref = TreeSitterFFI::AdoptPointer.new(ptr)
			str
		end
			
	end
end

