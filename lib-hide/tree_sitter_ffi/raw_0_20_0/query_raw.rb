require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_0'

module TreeSitterFFI
  class Query < BossFFI::BossPointer
    def self.release(ptr)
      TreeSitterFFI.ts_query_delete(ptr)
    end
  
    module_attach(TreeSitterFFI, :ts_query_new, [Language, :string, :uint32_t, :uint32_t_p, :int_p], Query)
    module_attach(TreeSitterFFI, :ts_query_delete, [Query], :void)
  
    wrap_attach(TreeSitterFFI, :ts_query_, [
      [:ts_query_pattern_count, [Query], :uint32_t],
      [:ts_query_capture_count, [Query], :uint32_t],
      [:ts_query_string_count, [Query], :uint32_t],
      [:ts_query_start_byte_for_pattern, [Query, :uint32_t], :uint32_t],
      [:ts_query_predicates_for_pattern, [Query, :uint32_t, :uint32_t_p], QueryPredicateStep.by_ref],
      [:ts_query_step_is_definite, [Query, :uint32_t], :bool],
      [:ts_query_capture_name_for_id, [Query, :uint32_t, :uint32_t_p], :string],
      [:ts_query_string_value_for_id, [Query, :uint32_t, :uint32_t_p], :string],
      [:ts_query_disable_capture, [Query, :string, :uint32_t], :void],
      [:ts_query_disable_pattern, [Query, :uint32_t], :void],
    ])
  
    # @return [:uint32_t] 
    def pattern_count()
      TreeSitterFFI.ts_query_pattern_count(self)
    end
  
    # @return [:uint32_t] 
    def capture_count()
      TreeSitterFFI.ts_query_capture_count(self)
    end
  
    # @return [:uint32_t] 
    def string_count()
      TreeSitterFFI.ts_query_string_count(self)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:uint32_t] 
    def start_byte_for_pattern(uint32_t_1)
      TreeSitterFFI.ts_query_start_byte_for_pattern(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] val_uint32_t_1 
    # @return [QueryPredicateStep.by_ref, :uint32_t] 
    def bufs_predicates_for_pattern(uint32_t_1, val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_query_predicates_for_pattern(self, uint32_t_1, uint32_t_p_1)
      end
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:bool] 
    def step_is_definite(uint32_t_1)
      TreeSitterFFI.ts_query_step_is_definite(self, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] val_uint32_t_1 
    # @return [:string, :uint32_t] 
    def bufs_capture_name_for_id(uint32_t_1, val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_query_capture_name_for_id(self, uint32_t_1, uint32_t_p_1)
      end
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @param [:uint32_t] val_uint32_t_1 
    # @return [:string, :uint32_t] 
    def bufs_string_value_for_id(uint32_t_1, val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_query_string_value_for_id(self, uint32_t_1, uint32_t_p_1)
      end
    end
  
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @return [:void] 
    def disable_capture(string_1, uint32_t_1)
      TreeSitterFFI.ts_query_disable_capture(self, string_1, uint32_t_1)
    end
  
    # @param [:uint32_t] uint32_t_1 
    # @return [:void] 
    def disable_pattern(uint32_t_1)
      TreeSitterFFI.ts_query_disable_pattern(self, uint32_t_1)
    end
  
  end

end
