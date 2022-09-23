# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'
require 'tree_sitter_ffi/raw/node_raw' 
require 'tree_sitter_ffi/raw/language_raw' 

### separate module wrap for each!!!

module TreeSitterFFI

### both Query and QueryCursor here for now!!! Also QueryCapture, QueryMatch

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
	
### tidy

### chimp
		# add this to FFI::Enum or EnumUtils???
		def self.type_enum(v)
# 			v.is_a?(Symbol) ? QueryError[v] : 
			if v.is_a?(Symbol)
				got = QueryErrorKind.to_native(v, nil) # wants ctx it doesn't use!!!
# 				got = QueryError.to_native(v) 
				raise "type_enum: unknown #{v.inspect}" unless got
				got
				# how to something like this:
# 				QueryError.to_native(v) || raise "type_enum: unknown #{v.inspect}"
			else
				QueryErrorKind.from_native(v, nil) # wants ctx it doesn't use!!!
# 				QueryError.from_native(v)
      end
		end
		
		### come back when we figure out how to override initialize!!!
		# returns a Query or a QueryError
		def self.make(lang, sexp)
# 		  puts "=== Query.make"
			err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
			err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
			query = TreeSitterFFI.ts_query_new(lang, sexp, sexp.length, 
				err_offset_p, err_type_p)
			offset = err_offset_p.get(:uint32, 0)
			type = err_type_p.get(:uint32, 0)
# 			puts "=== type: #{type}, offset: #{offset}, "
# 			puts "  query: #{query.inspect}"
			# is it possible FFI will return nil??? or only null pointer???
			query.null? ? TreeSitterFFI::QueryError.make(sexp, offset, type) :
				query
		end	

    ### TMP!!! by hand
		# currently not implemented
		### reattach ts_ form
    c_name, args, returns =  
      [:ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string]
    puts "c_name: #{c_name.inspect}, args: #{args.inspect}, returns: #{returns.inspect}"
    puts "=== vers: #{TreeSitterFFI::VERSION}"
    TreeSitterFFI.attach_function(c_name, args, returns)
    
# 		def ts_query_capture_name_for_id(*args) nope_not_impl(__callee__) end
# 		def capture_name_for_id(*args) #:uint32, :uint32_p => :string
		def capture_name_for_id(id) #:uint32 [, add len_p] => :string
# 		  nope_not_impl(__callee__) 
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# 			ret = yield(len_p)
      ret = ts_query_capture_name_for_id(self, id, len_p)
			len = len_p.get(:uint32, 0)
      ret
		end

# 		def ts_query_string_value_for_id(*args) nope_not_impl(__callee__) end
		def string_value_for_id(*args) 
# 		  nope_not_impl(__callee__) 
		end
	end
	
end

#### for QueryCursor...

module TreeSitterFFI

	class QueryCapture < BossStruct
		layout(
			:node, Node,
			:index, :uint32,
			)
			
	  include UnitMemory
	  
	  # reconsider props, props=!!!
#     def props()
#       [self[:node].props, self[:index]]
#     end
# #     def props=(start_colrow, end_colrow, run)
#     def props=(arr_or_h)
#       # just arr for now [Node.by_value, :uint32]
#       # Node.by_value is [context[:uint32, :uint32, :uint32, :uint32], id_p, tree_p]
#       node, index = arr_or_h
#       self[:node].props = node #node.dup???
# #       self[:index].props = index ###???!!!
#       self[:index] = index
#       self # for chaining
#     end
    
    # values of an individual QueryCapture (equiv multiple = 1)
    # now a deep copy of values of an individual QueryCapture (equiv multiple = 1)
		def copy_values(from)
#       puts "QueryCapture#copy_values from: #{from.inspect}"
      unless from && from.is_a?(self.class)
        raise "#{self.class}#copy_value: to must be class #{self.class} (#{from.inspect})"
      end
      self[:node].copy_values(from[:node])
      self[:index] = from[:index]
      self
		end

		### from_array, to_contiguous are module method!!!
		def self.from_array(arr)
# 			BossStructArray.to_contiguous(arr) do |e, fresh|
			UnitMemory.to_contiguous(arr) do |e, fresh|
			  fresh.copy_values(e)
			end
		end
	end
end

module TreeSitterFFI

# 	class QueryMatch < BossStruct
	class QueryMatch < BossMixedStruct
		layout(
			:id, :uint32,
			:pattern_index, :uint16,
			:capture_count, :uint16,
			:captures, QueryCapture.ptr
# 			:captures, :pointer # QueryCapture.ptr??? FIXME!!! come back re multiple
			)
			
    include UnitMemory
    
    def keep_keys() [:captures] end
		
    def copy_values(from)
      unit_keeps = util_copy_values([:id, :pattern_index, :capture_count],
        {captures: from[:capture_count]}, from)
    end
    
    ###???def captures() self[:captures] || [] end
    def captures() 
      self[:capture_count] < 1 ||self[:captures].null? ? 
        [] : 
        self[:captures].burst(self[:capture_count]) 
    end
	end
end

module TreeSitterFFI

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

### tidy

	  # override init???
	  def self.make()
      TreeSitterFFI.ts_query_cursor_new
	  end
	end
	
end

