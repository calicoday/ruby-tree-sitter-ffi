# coding: utf-8
# frozen_string_literal: false

require 'ffi'
require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/types'
require 'tree_sitter_ffi/node' 
require 'tree_sitter_ffi/language' 

module TreeSitterFFI

### both Query and QueryCursor here for now!!!

	class Query < BossPointer
		def self.release(ptr)
			TreeSitterFFI.ts_query_delete(ptr)
		end

		TreeSitterFFI.attach_function(:ts_query_new, 
			[Language, :string, :uint32, :uint32_p, :query_error_p], 
			Query )
		TreeSitterFFI.attach_function :ts_query_delete, [Query], :void

		wrap_attach(:ts_query_, [
			[:ts_query_pattern_count, [Query], :uint32],
			[:ts_query_capture_count, [Query], :uint32],
			[:ts_query_string_count, [Query], :uint32],
			[:ts_query_start_byte_for_pattern, [Query, :uint32], :uint32],
			
			[:ts_query_predicates_for_pattern, 
				[Query, :uint32, :uint32_p],  
				QueryPredicateStep.by_ref], #TSQueryPredicateStep*!!! array???
			[:ts_query_step_is_definite, [Query, :uint32], :bool],
			[:ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string],
			[:ts_query_string_value_for_id, [Query, :uint32, :uint32_p], :string],
			[:ts_query_disable_capture, [Query, :string, :uint32], :void],
			[:ts_query_disable_pattern, [Query, :uint32], :void],
			])

		# currently not implemented
# 		def ts_query_capture_name_for_id(*args) nope_not_impl(__callee__) end
# 		def capture_name_for_id(*args) nope_not_impl(__callee__) end
# 
# 		def ts_query_string_value_for_id(*args) nope_not_impl(__callee__) end
# 		def string_value_for_id(*args) nope_not_impl(__callee__) end
	
	end

#### for QueryCursor...

	class QueryCapture < BossStruct
		layout(
			:node, Node,
			:index, :uint32,
			)
	end
	
	class QueryMatch < BossStruct
		layout(
			:id, :uint32,
			:pattern_index, :uint16,
			:capture_count, :uint16,
			:captures, :pointer # QueryCapture.ptr??? FIXME!!! come back re multiple
			)
			
		def captures()
			struct_array(self[:captures], self[:capture_count])
		end
	end
	
	class QueryCursor < BossPointer
		def self.release(ptr)
			TreeSitterFFI.ts_query_cursor_delete(ptr)
		end

		TreeSitterFFI.attach_function :ts_query_cursor_new, [], QueryCursor 
		TreeSitterFFI.attach_function :ts_query_cursor_delete, [QueryCursor], :void # mem delete

		wrap_attach(:ts_query_cursor_, [
			[:ts_query_cursor_exec, [QueryCursor, Query, Node.by_value], :void],
			[:ts_query_cursor_did_exceed_match_limit, [QueryCursor], :bool],
			[:ts_query_cursor_match_limit, [QueryCursor], :uint32],
			[:ts_query_cursor_set_match_limit, [QueryCursor, :uint32], :bool],
			[:ts_query_cursor_set_byte_range, [QueryCursor, :uint32, :uint32], :void],
			[:ts_query_cursor_set_point_range, [QueryCursor, Point], :void],
			[:ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool],
			[:ts_query_cursor_remove_match, [QueryCursor, :uint32], :void],
			[:ts_query_cursor_next_capture, 
				[QueryCursor, QueryMatch.by_ref, :uint32_p],
				:bool], 
			])
	end
end
