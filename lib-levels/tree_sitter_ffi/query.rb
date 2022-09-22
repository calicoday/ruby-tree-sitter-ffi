# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/raw/query_raw'

### no subclasses, just reopen!!!

module TreeSitterFFI

### both Query and QueryCursor here for now!!!

	class Query < BossPointer
	end
	class QueryCapture < BossStruct
  end
end
