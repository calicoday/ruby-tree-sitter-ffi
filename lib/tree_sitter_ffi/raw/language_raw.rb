# coding: utf-8
# frozen_string_literal: false

### structs from parser.h for language-specific details???

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'

module TreeSitterFFI

	class Language < BossPointer #BossStruct
	
		wrap_attach(:ts_language_, [
			[:ts_language_symbol_count, [Language], :uint32],
			[:ts_language_symbol_name, [Language, :symbol], :string],
			[:ts_language_symbol_for_name, [Language, :string, :uint32, :bool], :symbol],
			[:ts_language_field_count, [Language], :uint32],
			[:ts_language_field_name_for_id, [Language, :field_id], :string],
			[:ts_language_field_id_for_name, [Language, :string, :uint32], :field_id],
			[:ts_language_symbol_type, [Language, :symbol], EnumSymbolType],
			[:ts_language_version, [Language], :uint32],
			])
	
	end	
end
