require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_7'

module TreeSitterFFI
  class Node < BossFFI::BossStruct
    wrap_attach(TreeSitterFFI, :ts_node_, [
      [:ts_node_type, [Node.by_value], :string],
      [:ts_node_symbol, [Node.by_value], :symbol],
      [:ts_node_start_byte, [Node.by_value], :uint32_t],
      [:ts_node_start_point, [Node.by_value], Point.by_value],
      [:ts_node_end_byte, [Node.by_value], :uint32_t],
      [:ts_node_end_point, [Node.by_value], Point.by_value],
      [:ts_node_string, [Node.by_value], :string],
      [:ts_node_is_null, [Node.by_value], :bool],
      [:ts_node_is_named, [Node.by_value], :bool],
      [:ts_node_is_missing, [Node.by_value], :bool],
      [:ts_node_is_extra, [Node.by_value], :bool],
      [:ts_node_has_changes, [Node.by_value], :bool],
      [:ts_node_has_error, [Node.by_value], :bool],
      [:ts_node_parent, [Node.by_value], Node.by_value],
      [:ts_node_child, [Node.by_value, :uint32_t], Node.by_value],
      [:ts_node_field_name_for_child, [Node.by_value, :uint32_t], :string],
      [:ts_node_child_count, [Node.by_value], :uint32_t],
      [:ts_node_named_child, [Node.by_value, :uint32_t], Node.by_value],
      [:ts_node_named_child_count, [Node.by_value], :uint32_t],
      [:ts_node_child_by_field_name, [Node.by_value, :string, :uint32_t], Node.by_value],
      [:ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value],
      [:ts_node_next_sibling, [Node.by_value], Node.by_value],
      [:ts_node_prev_sibling, [Node.by_value], Node.by_value],
      [:ts_node_next_named_sibling, [Node.by_value], Node.by_value],
      [:ts_node_prev_named_sibling, [Node.by_value], Node.by_value],
      [:ts_node_first_child_for_byte, [Node.by_value, :uint32_t], Node.by_value],
      [:ts_node_first_named_child_for_byte, [Node.by_value, :uint32_t], Node.by_value],
      [:ts_node_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value],
      [:ts_node_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value],
      [:ts_node_named_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value],
      [:ts_node_named_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value],
      [:ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void],
      [:ts_node_eq, [Node.by_value, Node.by_value], :bool],
    ])
  
    # @return [:string] 
    def type()
      TreeSitterFFI.ts_node_type(self)
    end
  
    # @return [:symbol] 
    def symbol()
      TreeSitterFFI.ts_node_symbol(self)
    end
  
    # @return [:uint32_t] 
    def start_byte()
      TreeSitterFFI.ts_node_start_byte(self)
    end
  
    # @return [Point.by_value] 
    def start_point()
      TreeSitterFFI.ts_node_start_point(self)
    end
  
    # @return [:uint32_t] 
    def end_byte()
      TreeSitterFFI.ts_node_end_byte(self)
    end
  
    # @return [Point.by_value] 
    def end_point()
      TreeSitterFFI.ts_node_end_point(self)
    end
  
    # @return [:string] 
    def string()
      TreeSitterFFI.ts_node_string(self)
    end
  
    # @return [:bool] 
    def is_null()
      TreeSitterFFI.ts_node_is_null(self)
    end
  
    # @return [:bool] 
    def is_named()
      TreeSitterFFI.ts_node_is_named(self)
    end
  
    # @return [:bool] 
    def is_missing()
      TreeSitterFFI.ts_node_is_missing(self)
    end
  
    # @return [:bool] 
    def is_extra()
      TreeSitterFFI.ts_node_is_extra(self)
    end
  
    # @return [:bool] 
    def has_changes()
      TreeSitterFFI.ts_node_has_changes(self)
    end
  
    # @return [:bool] 
    def has_error()
      TreeSitterFFI.ts_node_has_error(self)
    end
  
    # @return [Node.by_value] 
    def parent()
      TreeSitterFFI.ts_node_parent(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [Node.by_value] 
    def child(uint32_t_1)
      TreeSitterFFI.ts_node_child(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:string] 
    def field_name_for_child(uint32_t_1)
      TreeSitterFFI.ts_node_field_name_for_child(self, uint32_t_1)
    end
  
    # @return [:uint32_t] 
    def child_count()
      TreeSitterFFI.ts_node_child_count(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [Node.by_value] 
    def named_child(uint32_t_1)
      TreeSitterFFI.ts_node_named_child(self, uint32_t_1)
    end
  
    # @return [:uint32_t] 
    def named_child_count()
      TreeSitterFFI.ts_node_named_child_count(self)
    end
  
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @return [Node.by_value] 
    def child_by_field_name(string_1, uint32_t_1)
      TreeSitterFFI.ts_node_child_by_field_name(self, string_1, uint32_t_1)
    end
  
    # @param [:field_id] field_id_1 
    # @return [Node.by_value] 
    def child_by_field_id(field_id_1)
      TreeSitterFFI.ts_node_child_by_field_id(self, field_id_1)
    end
  
    # @return [Node.by_value] 
    def next_sibling()
      TreeSitterFFI.ts_node_next_sibling(self)
    end
  
    # @return [Node.by_value] 
    def prev_sibling()
      TreeSitterFFI.ts_node_prev_sibling(self)
    end
  
    # @return [Node.by_value] 
    def next_named_sibling()
      TreeSitterFFI.ts_node_next_named_sibling(self)
    end
  
    # @return [Node.by_value] 
    def prev_named_sibling()
      TreeSitterFFI.ts_node_prev_named_sibling(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [Node.by_value] 
    def first_child_for_byte(uint32_t_1)
      TreeSitterFFI.ts_node_first_child_for_byte(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [Node.by_value] 
    def first_named_child_for_byte(uint32_t_1)
      TreeSitterFFI.ts_node_first_named_child_for_byte(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] uint32_t_2 
    # @return [Node.by_value] 
    def descendant_for_byte_range(uint32_t_1, uint32_t_2)
      TreeSitterFFI.ts_node_descendant_for_byte_range(self, uint32_t_1, uint32_t_2)
    end
  
    # @param [Point.by_value] point_1 
    # @param [Point.by_value] point_2 
    # @return [Node.by_value] 
    def descendant_for_point_range(point_1, point_2)
      TreeSitterFFI.ts_node_descendant_for_point_range(self, point_1, point_2)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] uint32_t_2 
    # @return [Node.by_value] 
    def named_descendant_for_byte_range(uint32_t_1, uint32_t_2)
      TreeSitterFFI.ts_node_named_descendant_for_byte_range(self, uint32_t_1, uint32_t_2)
    end
  
    # @param [Point.by_value] point_1 
    # @param [Point.by_value] point_2 
    # @return [Node.by_value] 
    def named_descendant_for_point_range(point_1, point_2)
      TreeSitterFFI.ts_node_named_descendant_for_point_range(self, point_1, point_2)
    end
  
    # @param [InputEdit.by_ref] input_edit_1 
    # @return [:void] 
    def edit(input_edit_1)
      TreeSitterFFI.ts_node_edit(self, input_edit_1)
    end
  
    # @param [Node.by_value] node_2 
    # @return [:bool] 
    def eq(node_2)
      TreeSitterFFI.ts_node_eq(self, node_2)
    end
  
  end

end
