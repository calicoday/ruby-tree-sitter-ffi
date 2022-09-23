# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/parser_raw'

module TreeSitterFFI
	class Parser < BossPointer

		### override for better sigs
		
		# prev:  parse(Tree, Input.by_value) => Tree
		#        parse_string(Tree, :string, :uint32) => Tree
		# now:   parse(Input_or_String, Tree=nil) => Tree
		# still: parse_string(...)
		alias_method :prev_parse, :parse
		def parse(src, old_tree=nil)
			case src
			when String
				TreeSitterFFI.ts_parser_parse_string(self, old_tree, src, src.length)
			when Input
				TreeSitterFFI.ts_parser_parse(self, old_tree, src)
			else #raise bad arg
			end
		end
		
		# prev:  --
		# now:   parse_with(String, Tree=nil, EnumInputEncoding=nil)
		# still: parse_string_encoding(Tree, :string, :uint32, EnumInputEncoding) => Tree
		def parse_with(src, *args)
			old_tree = encoding = nil
			case args.length
			when 2 
				TreeSitterFFI.ts_parser_parse_string_encoding(self, args[0], 
					src, src.length, args[1])
			when 1
				args[0].is_a?(Symbol) ? 
					TreeSitterFFI.ts_parser_parse_string_encoding(self, nil, 
						src, src.length, args[0]) :
					TreeSitterFFI.ts_parser_parse_string_encoding(self, args[0], 
						src, src.length, :utf8)
			else # raise bad arg
			end
		end
			
  end

end

