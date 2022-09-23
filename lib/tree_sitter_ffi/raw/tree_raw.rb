# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'
require 'tree_sitter_ffi/raw/node_raw'
require 'tree_sitter_ffi/raw/language_raw'

### both Tree and TreeCursor here for now!!!

module TreeSitterFFI

	class Tree < BossPointer
		def self.release(ptr)
			TreeSitterFFI.ts_tree_delete(ptr)
		end

		TreeSitterFFI.attach_function :ts_tree_delete, [Tree], :void # mem delete
		
		wrap_attach(:ts_tree_, [
			[:ts_tree_copy, [Tree], Tree],
			[:ts_tree_root_node, [Tree], Node.by_value],
			[:ts_tree_language, [Tree], Language], # Lang.by_ref
			[:ts_tree_edit, [Tree, InputEdit.by_ref], :void],
			[:ts_tree_get_changed_ranges, [Tree, Tree, :uint32_p], :array_of_range],
			[:ts_tree_print_dot_graph, [Tree, :file_pointer], :void],
			])
	end

	class TreeCursor < BossStruct ### ManagedStruct???
# 	class TreeCursor < BossManagedStruct
		layout(
			:tree, :pointer,
			:id, :pointer,
			:context, [:uint32, 2],
			)

# 		def self.release(ptr)
# 			puts "TreeCursor says 'Release me!!'"
# # 			TreeSitterFFI.ts_tree_cursor_delete(ptr)
# 		end

		TreeSitterFFI.attach_function :ts_tree_cursor_new, [Node.by_value], TreeCursor.by_value
		TreeSitterFFI.attach_function :ts_tree_cursor_delete, [TreeCursor], :void 
		
		wrap_attach(:ts_tree_cursor_, [
			[:ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void],
			[:ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value],
			[:ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string],
			[:ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id], 
			[:ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_first_child_for_byte, 
				[TreeCursor.by_ref, :uint32], 
				:int64],
			[:ts_tree_cursor_goto_first_child_for_point, 
				[TreeCursor.by_ref, Point.by_value], 
				:int64],
			[:ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value],
			])
	end

end
