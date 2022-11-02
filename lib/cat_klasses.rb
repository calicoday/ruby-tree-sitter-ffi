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
# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'
require 'tree_sitter_ffi/raw/tree_raw'
require 'tree_sitter_ffi/raw/language_raw'

module TreeSitterFFI

	class Parser < BossPointer

		def self.release(ptr)
			TreeSitterFFI.ts_parser_delete(ptr)
		end
		
		TreeSitterFFI.attach_function :ts_parser_new, [], Parser
		TreeSitterFFI.attach_function :ts_parser_delete, [Parser], :void
	
		wrap_attach(:ts_parser_, [
			[:ts_parser_set_language, [Parser, Language], :bool],
			[:ts_parser_language, [Parser], Language],

			[:ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32], :bool],
			[:ts_parser_included_ranges, [Parser, :uint32_p], :array_of_range],

			[:ts_parser_parse, [Parser, Tree, Input.by_value], Tree],
			[:ts_parser_parse_string, [Parser, Tree, :string, :uint32], Tree],
			[:ts_parser_parse_string_encoding, 
				[Parser, Tree, :string, :uint32, EnumInputEncoding], 
				Tree],

			[:ts_parser_reset, [Parser], :void],
			[:ts_parser_set_timeout_micros, [Parser, :uint64], :void],
			[:ts_parser_timeout_micros, [Parser], :uint64],
			[:ts_parser_set_cancellation_flag, [Parser, :size_p], :void],
			[:ts_parser_cancellation_flag, [Parser], :size_p],
			
			[:ts_parser_set_logger, [Parser, Logger.by_value], :void],
			[:ts_parser_logger, [Parser], Logger.by_value],
			[:ts_parser_print_dot_graphs, 
				[Parser, :file_descriptor], 
				:void],
			])
			
		# or just wrap any set_, is_ ???
		wrap_alias([:language, :included_ranges, :timeout_micros, :cancellation_flag,
			:logger])

		# currently not implemented
		def ts_parser_parse(*args) nope_not_impl(__callee__) end
		###def parse(*args) nope_not_impl(__callee__) end # this IS impl now below

		def ts_parser_set_logger(*args) nope_not_impl(__callee__) end
		def set_logger(*args) nope_not_impl(__callee__) end

		def ts_parser_logger(*args) nope_not_impl(__callee__) end
		def logger(*args) nope_not_impl(__callee__) end
			
	end
		
### tidy

		### override for better args/rets types

# 			[:ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32], :bool],
    def will_set_included_ranges(ranges)
      ranges = UnitMemory.to_contiguous(ranges) if ranges.is_a?(Array)
			raise "Parser#set_included_ranges expected Range+ arg" unless ranges.is_a?(Range)
			TreeSitterFFI.ts_parser_set_included_ranges(self, ranges, ranges.unit_count)
    end
 		def will_included_ranges() # => Array
 		  # :uint32_p is Pointer
 		  len, ranges = UnitMemory.rsvp([:pointer], ranges) do |len_p, ranges| 
				ranges = ts_parser_included_ranges(self, len_p)
 		  end
    end
       
		def set_included_ranges(ranges)
		  len = 1
		  if ranges.is_a?(Array)
		    len = ranges.length		    
        ranges = UnitMemory.to_contiguous(ranges)
		  end
#       ranges = UnitMemory.to_contiguous(ranges) if ranges.is_a?(Array)
			raise "Parser#set_included_ranges expected Range+ arg" unless ranges.is_a?(Range)
			TreeSitterFFI.ts_parser_set_included_ranges(self, ranges, len)
# 			TreeSitterFFI.ts_parser_set_included_ranges(self, ranges, ranges.unit_count)

			# ranges is an Array of Range < BossStruct OR Range that knows it's multiple
# 			ranges = Range.from_array(ranges) if ranges.is_a?(Array)
# 			raise "set_included_ranges expected Range+ arg" unless ranges.is_a?(Range)
# 			# if it's meant to be a struct array but multiple isn't set...???
# # 			TreeSitterFFI.ts_parser_set_included_ranges(self, ranges, ranges.struct_multiple)
# 			TreeSitterFFI.ts_parser_set_included_ranges(self, ranges, ranges.unit_count)
		end
# 			[:ts_parser_included_ranges, [Parser, :uint32_p], :array_of_range],
		def included_ranges() # => Array
		  ### get rsvp working!!!
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
		  ret = ts_parser_included_ranges(self, len_p)
			len = len_p.get(:uint32, 0)
      # NOPE curr ret is Pointer we need to cast!!!
#       raise "Parser#included_ranges ret: #{ret.inspect}" unless ret && ret.is_a?(TreeSitterFFI::Range)
      # array of struct did:
# 			klass.new(ret, len).to_array

      TreeSitterFFI::Range.new(ret).burst(len)
#       TreeSitterFFI::Range.new(ret).tap do |o|
#         o.unit_count = len #if len > 0 ???
#       end.to_a
		  
# 			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
			###BossStructArray.array_of_struct(TreeSitterFFI::Range) do |len_p|
			###	ts_parser_included_ranges(self, len_p)
			###end
# 			ret = ts_parser_included_ranges(self, len_p)
# 			len = len_p.get(:uint32, 0)
# 			ranges = TreeSitterFFI::Range.new(ret, len)
# 			ranges.to_array
		end

end
# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'
require 'tree_sitter_ffi/raw/node_raw'
require 'tree_sitter_ffi/raw/language_raw'

### both Tree and TreeCursor here for now!!!

module TreeSitterFFI

	class Tree < BossPointer
		def self.release(ptr)
			TreeSitterFFI.ts_tree_delete(ptr)
		end

		TreeSitterFFI.attach_function :ts_tree_delete, [Tree], :void # mem delete
		
		wrap_attach(:ts_tree_, [
			[:ts_tree_copy, [Tree], Tree],
			[:ts_tree_root_node, [Tree], Node.by_value],
			[:ts_tree_language, [Tree], Language], # Lang.by_ref
			[:ts_tree_edit, [Tree, InputEdit.by_ref], :void],
			[:ts_tree_get_changed_ranges, [Tree, Tree, :uint32_p], :array_of_range],
			[:ts_tree_print_dot_graph, [Tree, :file_pointer], :void],
			])
	end

	class TreeCursor < BossStruct ### ManagedStruct???
# 	class TreeCursor < BossManagedStruct
		layout(
			:tree, :pointer,
			:id, :pointer,
			:context, [:uint32, 2],
			)

# 		def self.release(ptr)
# 			puts "TreeCursor says 'Release me!!'"
# # 			TreeSitterFFI.ts_tree_cursor_delete(ptr)
# 		end

		TreeSitterFFI.attach_function :ts_tree_cursor_new, [Node.by_value], TreeCursor.by_value
		TreeSitterFFI.attach_function :ts_tree_cursor_delete, [TreeCursor], :void 
		
		wrap_attach(:ts_tree_cursor_, [
			[:ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void],
			[:ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value],
			[:ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string],
			[:ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id], 
			[:ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool],
			[:ts_tree_cursor_goto_first_child_for_byte, 
				[TreeCursor.by_ref, :uint32], 
				:int64],
			[:ts_tree_cursor_goto_first_child_for_point, 
				[TreeCursor.by_ref, Point.by_value], 
				:int64],
			[:ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value],
			])
	end

end
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

# coding: utf-8
# frozen_string_literal: false

### util enums and structs from api.h (not boss or dependent)

require 'tree_sitter_ffi/boss' 


module TreeSitterFFI

# typedef uint16_t TSSymbol;
# typedef uint16_t TSFieldId;
# typedef struct TSLanguage TSLanguage;
# typedef struct TSParser TSParser;
# typedef struct TSTree TSTree;
# typedef struct TSQuery TSQuery;
# typedef struct TSQueryCursor TSQueryCursor;

	EnumInputEncoding = enum(:utf8, :utf16)

	EnumSymbolType = enum(:regular, :anonymous, :auxiliary)

	class Point < FFI::Struct
		layout(
			:row, :uint32,
			:column, :uint32,
			)
		
		def initialize(*args)
			if args.length == 2
				# popping from the end, so reverse order!!!
				column = args.pop
				row = args.pop
			end
			super(*args)
			if row && column
				self[:row] = row
				self[:column] = column
			end
		end
		def ==(v)
			return false unless !v.nil? && self.class == v.class # subclasses???
			self[:row] == v[:row] && self[:column] == v[:column]
		end

### chimp???
    def props()
      [self[:column], self[:row]]
    end
    def props=(colrow)
      self[:row] = colrow[1]
      self[:column] = colrow[0]
      self # for chaining
    end
	end

# 	class Range < BossStruct
	class Range < FFI::Struct
		include UnitMemory
# 		include BossStructArray
		layout(
			:start_point, Point,
			:end_point, Point,
			:start_byte, :uint32,
			:end_byte, :uint32,
			)
			
    def initialize(*args)
      super
#       self.unit_count = 1 if args.empty?
    end

		# untested bc not called yet??? prob need BossStructArray.to_multiple!!!
# 		def self.from_array(arr)
# 			to_multiple do |e, range|
# 				e[:start_point] = range[:start_point]
# 				e[:end_point] = range[:end_point]
# 				e[:start_byte] = range[:start_byte]
# 				e[:end_byte] = range[:end_byte]
# 			end
# 		end
    def props()
      [self[:start_point].props, self[:end_point].props, 
        [self[:start_byte], self[:end_byte]]]
    end
#     def props=(start_colrow, end_colrow, run)
    def props=(arr_or_h)
      # just arr for now (Array, Array, Array (Range?))
      start_colrow, end_colrow, run = arr_or_h
      self[:start_point].props = start_colrow
      self[:end_point].props = end_colrow
      self[:start_byte] = run[0]
      self[:end_byte] = run[1]
      self # for chaining
    end
    
    ### override init!!!
    def self.make(arr)
      # vet arr shape!!!
      self.new.tap do |o|
        o.props = (arr)
      end
    end
    
		def copy_values(from)
# 		  raise "BossStructArray#copy_values(to) must be overridden."
      # from, to must be this class!!!
      unless from && from.is_a?(self.class)
        raise "#{self.class}#copy_value: to must be class #{self.class} (#{from.inspect})"
      end
      self.props = from.props
		end

		### from_array, to_contiguous are module method!!!
		def self.from_array(arr)
# 			BossStructArray.to_contiguous(arr) do |e, fresh|
			UnitMemory.to_contiguous(arr) do |e, fresh|
			  fresh.copy_values(to)
			end
		end
	end

# typedef struct {
#   void *payload;
#   const char *(*read)(void *payload, uint32_t byte_index, TSPoint position, uint32_t *bytes_read);
#   TSInputEncoding encoding;
# } TSInput;

# if we needed to do something on release()...
# 	class Input < FFI::ManagedStruct
# 		def self.release(ptr) # if mng
# 			o[:payload] = nil # nec???
# 		end
#		end

	class Input < FFI::Struct
		layout(
			:payload, :pointer,
			# can these pointers be more specific???
			:read, callback([:pointer, :uint32, Point.by_value, :uint32_p], :pointer), # ret :string???
			:encoding, EnumInputEncoding,
			)
		### TMP!!!
# 		arg_1 = FFI::MemoryPointer.new(:uint32, 1)
# 		len = arg_1.get(:uint32, 0)
# 		len.should_not == nil
# 		len.is_a?(Integer).should == true
		def initialize(len=256)
			super()
			self[:payload] = FFI::MemoryPointer.new(:char, len)
		end
		def payload=(p)
			# raise "expected memptr" unless is_a?(MemPointer)???
			self[:payload] = p
		end
	end

	EnumLogType = enum(:parse, :lex)

# typedef struct {
#   void *payload;
#   void (*log)(void *payload, TSLogType, const char *);
# } TSLogger;
	class Logger < FFI::Struct
		layout(
			:payload, :pointer,
			### lily
			:log, callback([:pointer, EnumLogType, :pointer], :void)
# 			:log, callback([:pointer, EnumLogType, :string], :void)
			)
		def initialize(len=256)
			super()
			self[:payload] = FFI::MemoryPointer.new(:char, len)
		end
		def payload=(p)
			# raise "expected memptr" unless is_a?(MemPointer)???
			self[:payload] = p
		end
	end

	class InputEdit < FFI::Struct
		layout(
			:start_byte, :uint32,
			:old_end_byte, :uint32,
			:new_end_byte, :uint32,
			:start_point, Point,
			:old_end_point, Point,
			:new_end_point, Point,
			)

### tidy??? idio???

    def self.from_hash(h)
  # 		puts "TreeSitterFFI::InputEdit.from_hash..."
  # 		ap h
      self.new.tap do |o|
        o[:start_byte] = h[:start_byte]
        o[:old_end_byte] = h[:old_end_byte]
        o[:new_end_byte] = h[:new_end_byte]
        o[:start_point] = h[:start_position] # tree_test says start_position but shdv chgd
        o[:old_end_point] = h[:old_end_position]
        o[:new_end_point] = h[:new_end_position]
  #       o[:start_point] = h[:start_point] # tree_test says start_position but shdv chgd
  #       o[:old_end_point] = h[:old_end_point]
  #       o[:new_end_point] = h[:new_end_point]
      end
    end
	end

	EnumQueryPredicateStepType = enum(:done, :capture, :string)

	class QueryPredicateStep < FFI::Struct
		layout(
			:type, EnumQueryPredicateStepType,
			:value_id, :uint32
			)
	end
	EnumQueryError = enum(:none, 0, :syntax, :node_type, :field, :capture, :structure)


end
# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/types_raw'

module TreeSitterFFI

	class Node < BossStruct
		layout(
			:context, [:uint32, 4],
			:id, :pointer,
			:tree, :pointer
# 			:tree, Tree #???
		)

		wrap_attach(:ts_node_, [
			[:ts_node_type, [Node.by_value], :string],
			[:ts_node_symbol, [Node.by_value], :uint16],
			[:ts_node_start_byte, [Node.by_value], :uint32],

			[:ts_node_start_point, [Node.by_value], Point.by_value],
			[:ts_node_end_byte, [Node.by_value], :uint32],
			[:ts_node_end_point, [Node.by_value], Point.by_value],
	
			# not sure how best to do this. We need a pointer to wrap for freeing
			# and a string to return. Is a subclass equiv to :strptr poss???
			# for now, wrap attach AND override the rb_name form here
			# ts_ form in TreeSitterFFI will return [:string, :pointer]!!!
			[:ts_node_string, [Node.by_value], :adoptstring], # typedefd :strptr

			[:ts_node_is_null, [Node.by_value], :bool],
			[:ts_node_is_named, [Node.by_value], :bool],
			[:ts_node_is_missing, [Node.by_value], :bool],
			[:ts_node_is_extra, [Node.by_value], :bool],
			[:ts_node_has_changes, [Node.by_value], :bool],
			[:ts_node_has_error, [Node.by_value], :bool],
			[:ts_node_parent, [Node.by_value], Node.by_value],
	
			[:ts_node_child, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_field_name_for_child, [Node.by_value, :uint32], :string],
			[:ts_node_child_count, [Node.by_value], :uint32],
			[:ts_node_named_child, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_named_child_count, [Node.by_value], :uint32],
	
			[:ts_node_child_by_field_name, 
				[Node.by_value, :string, :uint32], 
				Node.by_value],
			[:ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value],

			[:ts_node_next_sibling, [Node.by_value], Node.by_value],
			[:ts_node_prev_sibling, [Node.by_value], Node.by_value],
			[:ts_node_next_named_sibling, [Node.by_value], Node.by_value],
			[:ts_node_prev_named_sibling, [Node.by_value], Node.by_value],

			[:ts_node_first_child_for_byte, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_first_named_child_for_byte, [Node.by_value, :uint32], Node.by_value],
			[:ts_node_descendant_for_byte_range, 
				[Node.by_value, :uint32, :uint32], 
				Node.by_value],
			[:ts_node_descendant_for_point_range, 
				[Node.by_value, Point.by_value, Point.by_value], 
				Node.by_value],
			[:ts_node_named_descendant_for_byte_range, 
				[Node.by_value, :uint32, :uint32], 
				Node.by_value],
			[:ts_node_named_descendant_for_point_range, 
				[Node.by_value, Point.by_value, Point.by_value], 
				Node.by_value],

			[:ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void], ### mem???
			[:ts_node_eq, [Node.by_value, Node.by_value], :bool],
	
			])

### tidy

		### override for better args/rets types

		def string
			str, ptr = TreeSitterFFI.ts_node_string(self)
			what_about_this_ref = TreeSitterFFI::AdoptPointer.new(ptr)
			str
		end
			
	end
end

