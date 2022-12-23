require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_6'

module TreeSitterFFI
  class Tree < BossFFI::BossPointer
    def self.release(ptr)
      TreeSitterFFI.ts_tree_delete(ptr)
    end
  
    module_attach(TreeSitterFFI, :ts_tree_delete, [Tree], :void)
  
    wrap_attach(TreeSitterFFI, :ts_tree_, [
      [:ts_tree_copy, [Tree], Tree],
      [:ts_tree_root_node, [Tree], Node.by_value],
      [:ts_tree_language, [Tree], Language],
      [:ts_tree_edit, [Tree, InputEdit.by_ref], :void],
      [:ts_tree_get_changed_ranges, [Tree, Tree, :uint32_t_p], Range.by_ref],
      [:ts_tree_print_dot_graph, [Tree, :waitwhatFILE_p], :void],
    ])
  
    # @return [Tree] 
    def copy()
      TreeSitterFFI.ts_tree_copy(self)
    end
  
    # @return [Node.by_value] 
    def root_node()
      TreeSitterFFI.ts_tree_root_node(self)
    end
  
    # @return [Language] 
    def language()
      TreeSitterFFI.ts_tree_language(self)
    end
  
    # @param [InputEdit.by_ref] input_edit_1 
    # @return [:void] 
    def edit(input_edit_1)
      TreeSitterFFI.ts_tree_edit(self, input_edit_1)
    end
  
    # @param [Tree] tree_2 
    # @param [:uint32_t] val_uint32_t_1 
    # @return [Range.by_ref, :uint32_t] 
    def bufs_get_changed_ranges(tree_2, val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_tree_get_changed_ranges(self, tree_2, uint32_t_p_1)
      end
    end
  
    # @param [:waitwhatFILE] val_waitwhat_file_1 
    # @return [:void, :waitwhatFILE] 
    def bufs_print_dot_graph(val_waitwhat_file_1)
      NiftyFFI::bufs([[:waitwhatFILE_p, val_waitwhat_file_1]]) do |waitwhat_file_p_1|
        TreeSitterFFI.ts_tree_print_dot_graph(self, waitwhat_file_p_1)
      end
    end
  
  end

end
