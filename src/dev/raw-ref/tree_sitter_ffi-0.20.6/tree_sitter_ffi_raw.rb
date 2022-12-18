require 'boss_ffi'

require 'tree_sitter_ffi/raw_0_20_6/types_raw'

# does order matter, as we've already defined everything in types in header-order???
require 'tree_sitter_ffi/raw_0_20_6/language_raw'
require 'tree_sitter_ffi/raw_0_20_6/node_raw'
require 'tree_sitter_ffi/raw_0_20_6/tree_raw'
require 'tree_sitter_ffi/raw_0_20_6/query_raw'
require 'tree_sitter_ffi/raw_0_20_6/parser_raw'
require 'tree_sitter_ffi/raw_0_20_6/tree_cursor_raw'
require 'tree_sitter_ffi/raw_0_20_6/query_cursor_raw'

module TreeSitterFFI
	def self.parser() TreeSitterFFI.ts_parser_new end
	def self.parser_json() 
    TreeSitterFFI.add_lang(:tree_sitter_json, 
      '/usr/local/lib/tree-sitter-json/libtree-sitter-json.0.19.0.dylib')
    json_lang = TreeSitterFFI.tree_sitter_json
# 	  TreeSitterFFILang::JSON.parser 
	end
end
