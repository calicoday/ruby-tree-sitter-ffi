require 'boss_ffi'
require 'tree_sitter_ffi/tree_sitter_ffi_0_20_0'

module TreeSitterFFI
  class Language < BossFFI::BossPointer
    wrap_attach(TreeSitterFFI, :ts_language_, [
      [:ts_language_symbol_count, [Language], :uint32_t],
      [:ts_language_symbol_name, [Language, :symbol], :string],
      [:ts_language_symbol_for_name, [Language, :string, :uint32_t, :bool], :symbol],
      [:ts_language_field_count, [Language], :uint32_t],
      [:ts_language_field_name_for_id, [Language, :field_id], :string],
      [:ts_language_field_id_for_name, [Language, :string, :uint32_t], :field_id],
      [:ts_language_symbol_type, [Language, :symbol], EnumSymbolType],
      [:ts_language_version, [Language], :uint32_t],
    ])
  
    # @return [:uint32_t] 
    def symbol_count()
      TreeSitterFFI.ts_language_symbol_count(self)
    end
  
    # @param [:symbol] symbol_1 
    # @return [:string] 
    def symbol_name(symbol_1)
      TreeSitterFFI.ts_language_symbol_name(self, symbol_1)
    end
  
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @param [:bool] bool_1 
    # @return [:symbol] 
    def symbol_for_name(string_1, uint32_t_1, bool_1)
      TreeSitterFFI.ts_language_symbol_for_name(self, string_1, uint32_t_1, bool_1)
    end
  
    # @return [:uint32_t] 
    def field_count()
      TreeSitterFFI.ts_language_field_count(self)
    end
  
    # @param [:field_id] field_id_1 
    # @return [:string] 
    def field_name_for_id(field_id_1)
      TreeSitterFFI.ts_language_field_name_for_id(self, field_id_1)
    end
  
    # @param [:string] string_1 
    # @param [:uint32_t] uint32_t_1 
    # @return [:field_id] 
    def field_id_for_name(string_1, uint32_t_1)
      TreeSitterFFI.ts_language_field_id_for_name(self, string_1, uint32_t_1)
    end
  
    # @param [:symbol] symbol_1 
    # @return [EnumSymbolType] 
    def symbol_type(symbol_1)
      TreeSitterFFI.ts_language_symbol_type(self, symbol_1)
    end
  
    # @return [:uint32_t] 
    def version()
      TreeSitterFFI.ts_language_version(self)
    end
  
  end

end
