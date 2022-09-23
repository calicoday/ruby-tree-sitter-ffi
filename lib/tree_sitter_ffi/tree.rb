# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/tree_raw'

### both Tree and TreeCursor here for now!!!

module TreeSitterFFI

	class Tree < BossPointer
	end

	class TreeCursor < BossStruct ### ManagedStruct???
  end
end

