require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_6'

module TreeSitterFFI
  class Parser < BossFFI::BossPointer
    def self.release(ptr)
      TreeSitterFFI.ts_parser_delete(ptr)
    end
  
    module_attach(TreeSitterFFI, :ts_parser_new, [], Parser)
    module_attach(TreeSitterFFI, :ts_parser_delete, [Parser], :void)
  
    wrap_attach(TreeSitterFFI, :ts_parser_, [
      [:ts_parser_set_language, [Parser, Language], :bool],
      [:ts_parser_language, [Parser], Language],
      [:ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32_t], :bool],
      [:ts_parser_included_ranges, [Parser, :uint32_t_p], Range.by_ref],
      [:ts_parser_parse, [Parser, Tree, Input.by_value], Tree],
      [:ts_parser_parse_string, [Parser, Tree, :string, :uint32_t], Tree],
      [:ts_parser_parse_string_encoding, [Parser, Tree, :string, :uint32_t, EnumInputEncoding], Tree],
      [:ts_parser_reset, [Parser], :void],
      [:ts_parser_set_timeout_micros, [Parser, :uint64_t], :void],
      [:ts_parser_timeout_micros, [Parser], :uint64_t],
      [:ts_parser_set_cancellation_flag, [Parser, :size_t_p], :void],
      [:ts_parser_cancellation_flag, [Parser], :size_t_p],
      [:ts_parser_set_logger, [Parser, Logger.by_value], :void],
      [:ts_parser_logger, [Parser], Logger.by_value],
      [:ts_parser_print_dot_graphs, [Parser, :int], :void],
    ])
  
    # @param [Language] language_1 
    # @return [:bool] 
    def set_language(language_1)
      TreeSitterFFI.ts_parser_set_language(self, language_1)
    end
  
    # @return [Language] 
    def language()
      TreeSitterFFI.ts_parser_language(self)
    end
  
    # @param [Range.by_ref] range_1 
    # @param [:uint32_t] uint32_t_1 
    # @return [:bool] 
    def set_included_ranges(range_1, uint32_t_1)
      TreeSitterFFI.ts_parser_set_included_ranges(self, range_1, uint32_t_1)
    end
  
    # @param [:uint32_t] val_uint32_t_1 
    # @return [Range.by_ref, :uint32_t] 
    def bufs_included_ranges(val_uint32_t_1)
      NiftyFFI::bufs([[:uint32_t_p, val_uint32_t_1]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_parser_included_ranges(self, uint32_t_p_1)
      end
    end
  
    # @param [Tree] tree_1 
    # @param [Input.by_value] input_1 
    # @return [Tree] 
    def parse(tree_1, input_1)
      TreeSitterFFI.ts_parser_parse(self, tree_1, input_1)
    end
  
    # @param [Tree] tree_1 
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @return [Tree] 
    def parse_string(tree_1, string_1, uint32_t_1)
      TreeSitterFFI.ts_parser_parse_string(self, tree_1, string_1, uint32_t_1)
    end
  
    # @param [Tree] tree_1 
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @param [EnumInputEncoding] enum_input_encoding_1 
    # @return [Tree] 
    def parse_string_encoding(tree_1, string_1, uint32_t_1, enum_input_encoding_1)
      TreeSitterFFI.ts_parser_parse_string_encoding(self, tree_1, string_1, uint32_t_1, enum_input_encoding_1)
    end
  
    # @return [:void] 
    def reset()
      TreeSitterFFI.ts_parser_reset(self)
    end
  
    # @param [:uint64_t] uint64_t_1 
    # @return [:void] 
    def set_timeout_micros(uint64_t_1)
      TreeSitterFFI.ts_parser_set_timeout_micros(self, uint64_t_1)
    end
  
    # @return [:uint64_t] 
    def timeout_micros()
      TreeSitterFFI.ts_parser_timeout_micros(self)
    end
  
    # @param [:size_t] val_size_t_1 
    # @return [:void, :size_t] 
    def bufs_set_cancellation_flag(val_size_t_1)
      NiftyFFI::bufs([[:size_t_p, val_size_t_1]]) do |size_t_p_1|
        TreeSitterFFI.ts_parser_set_cancellation_flag(self, size_t_p_1)
      end
    end
  
    # @return [:size_t_p] 
    def cancellation_flag()
      TreeSitterFFI.ts_parser_cancellation_flag(self)
    end
  
    # @param [Logger.by_value] logger_1 
    # @return [:void] 
    def set_logger(logger_1)
      TreeSitterFFI.ts_parser_set_logger(self, logger_1)
    end
  
    # @return [Logger.by_value] 
    def logger()
      TreeSitterFFI.ts_parser_logger(self)
    end
  
    # @param [:int] int_1 
    # @return [:void] 
    def print_dot_graphs(int_1)
      TreeSitterFFI.ts_parser_print_dot_graphs(self, int_1)
    end
  
  end

end
