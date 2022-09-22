# coding: utf-8
# frozen_string_literal: false

# require 'tree_sitter_ffi/boss'
# require 'tree_sitter_ffi/types'
# require 'tree_sitter_ffi/tree'
# require 'tree_sitter_ffi/language'
# require 'tree_sitter_ffi/tidy/parser_tidy'
# require 'tree_sitter_ffi/idio/parser_idio'
require 'tree_sitter_ffi/raw/parser_raw'
require 'tree_sitter_ffi/tidy/parser_tidy'
require 'tree_sitter_ffi/idio/parser_idio'

### no subclasses, just reopen!!!

module TreeSitterFFI

	class Parser < BossPointer

#     include ParserTidy #???
#     extend ParserTidy
#     include ParserIdio
	end

end
