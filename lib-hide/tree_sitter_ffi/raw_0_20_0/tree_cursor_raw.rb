require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_0'

module TreeSitterFFI
  class TreeCursor < BossFFI::BossStruct
    def self.release(ptr)
      TreeSitterFFI.ts_tree_cursor_delete(ptr)
    end
  
    module_attach(TreeSitterFFI, :ts_tree_cursor_new, [Node.by_value], TreeCursor.by_value)
    module_attach(TreeSitterFFI, :ts_tree_cursor_delete, [TreeCursor.by_ref], :void)
  
    wrap_attach(TreeSitterFFI, :ts_tree_cursor_, [
      [:ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void],
      [:ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value],
      [:ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string],
      [:ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id],
      [:ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool],
      [:ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool],
      [:ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool],
      [:ts_tree_cursor_goto_first_child_for_byte, [TreeCursor.by_ref, :uint32_t], :int64_t],
      [:ts_tree_cursor_goto_first_child_for_point, [TreeCursor.by_ref, Point.by_value], :int64_t],
      [:ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value],
    ])
  
    # @param [Node.by_value] node_1 
    # @return [:void] 
    def reset(node_1)
      TreeSitterFFI.ts_tree_cursor_reset(self, node_1)
    end
  
    # @return [Node.by_value] 
    def current_node()
      TreeSitterFFI.ts_tree_cursor_current_node(self)
    end
  
    # @return [:string] 
    def current_field_name()
      TreeSitterFFI.ts_tree_cursor_current_field_name(self)
    end
  
    # @return [:field_id] 
    def current_field_id()
      TreeSitterFFI.ts_tree_cursor_current_field_id(self)
    end
  
    # @return [:bool] 
    def goto_parent()
      TreeSitterFFI.ts_tree_cursor_goto_parent(self)
    end
  
    # @return [:bool] 
    def goto_next_sibling()
      TreeSitterFFI.ts_tree_cursor_goto_next_sibling(self)
    end
  
    # @return [:bool] 
    def goto_first_child()
      TreeSitterFFI.ts_tree_cursor_goto_first_child(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:int64_t] 
    def goto_first_child_for_byte(uint32_t_1)
      TreeSitterFFI.ts_tree_cursor_goto_first_child_for_byte(self, uint32_t_1)
    end
  
    # @param [Point.by_value] point_1 
    # @return [:int64_t] 
    def goto_first_child_for_point(point_1)
      TreeSitterFFI.ts_tree_cursor_goto_first_child_for_point(self, point_1)
    end
  
    # @return [TreeCursor.by_value] 
    def copy()
      TreeSitterFFI.ts_tree_cursor_copy(self)
    end
  
  end

end
