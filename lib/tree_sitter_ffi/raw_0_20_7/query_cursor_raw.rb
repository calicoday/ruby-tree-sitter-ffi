require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_7'

module TreeSitterFFI
  class QueryCursor < BossFFI::BossPointer
    def self.release(ptr)
      TreeSitterFFI.ts_query_cursor_delete(ptr)
    end
  
    module_attach(TreeSitterFFI, :ts_query_cursor_new, [], QueryCursor)
    module_attach(TreeSitterFFI, :ts_query_cursor_delete, [QueryCursor], :void)
  
    wrap_attach(TreeSitterFFI, :ts_query_cursor_, [
      [:ts_query_cursor_exec, [QueryCursor, Query, Node.by_value], :void],
      [:ts_query_cursor_did_exceed_match_limit, [QueryCursor], :bool],
      [:ts_query_cursor_match_limit, [QueryCursor], :uint32_t],
      [:ts_query_cursor_set_match_limit, [QueryCursor, :uint32_t], :void],
      [:ts_query_cursor_set_byte_range, [QueryCursor, :uint32_t, :uint32_t], :void],
      [:ts_query_cursor_set_point_range, [QueryCursor, Point.by_value, Point.by_value], :void],
      [:ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool],
      [:ts_query_cursor_remove_match, [QueryCursor, :uint32_t], :void],
      [:ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_t_p], :bool],
    ])
  
    # @param [Query] query_1 
    # @param [Node.by_value] node_1 
    # @return [:void] 
    def exec(query_1, node_1)
      TreeSitterFFI.ts_query_cursor_exec(self, query_1, node_1)
    end
  
    # @return [:bool] 
    def did_exceed_match_limit()
      TreeSitterFFI.ts_query_cursor_did_exceed_match_limit(self)
    end
  
    # @return [:uint32_t] 
    def match_limit()
      TreeSitterFFI.ts_query_cursor_match_limit(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:void] 
    def set_match_limit(uint32_t_1)
      TreeSitterFFI.ts_query_cursor_set_match_limit(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] uint32_t_2 
    # @return [:void] 
    def set_byte_range(uint32_t_1, uint32_t_2)
      TreeSitterFFI.ts_query_cursor_set_byte_range(self, uint32_t_1, uint32_t_2)
    end
  
    # @param [Point.by_value] point_1 
    # @param [Point.by_value] point_2 
    # @return [:void] 
    def set_point_range(point_1, point_2)
      TreeSitterFFI.ts_query_cursor_set_point_range(self, point_1, point_2)
    end
  
    # @param [QueryMatch.by_ref] query_match_1 
    # @return [:bool] 
    def next_match(query_match_1)
      TreeSitterFFI.ts_query_cursor_next_match(self, query_match_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:void] 
    def remove_match(uint32_t_1)
      TreeSitterFFI.ts_query_cursor_remove_match(self, uint32_t_1)
    end
  
    # @param [QueryMatch.by_ref] query_match_1 
    # @param [:uint32_t] val_uint32_t_1 
    # @return [:bool, :uint32_t] 
    def bufs_next_capture(query_match_1, val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_query_cursor_next_capture(self, query_match_1, uint32_t_p_1)
      end
    end
  
  end

end
