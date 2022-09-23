# coding: utf-8
# frozen_string_literal: false

### structs from parser.h for language-specific details???

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/language_raw'

module TreeSitterFFI

	class Language < BossPointer #BossStruct
# 		def inspect() 
# 			"<Language version: #{self[:version]}, sym_count: #{self[:symbol_count]}>" 
# 		end		

	end	
end
