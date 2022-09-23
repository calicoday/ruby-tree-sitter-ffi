# coding: utf-8
# frozen_string_literal: false

### util enums and structs from api.h (not boss or dependent)

# require 'ffi'
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
