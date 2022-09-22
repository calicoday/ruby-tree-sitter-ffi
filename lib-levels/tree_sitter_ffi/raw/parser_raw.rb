# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/types'
require 'tree_sitter_ffi/tree'
require 'tree_sitter_ffi/language'
# require 'tree_sitter_ffi/raw/types'
# require 'tree_sitter_ffi/raw/tree'
# require 'tree_sitter_ffi/raw/language'

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

=begin
#     include ParserTidy #???
    extend ParserTidy
    include ParserIdio
=end

    ### mv to tidy/
=begin
		# currently not implemented
		def ts_parser_parse(*args) nope_not_impl(__callee__) end
		###def parse(*args) nope_not_impl(__callee__) end # this IS impl now below

		def ts_parser_set_logger(*args) nope_not_impl(__callee__) end
		def set_logger(*args) nope_not_impl(__callee__) end

		def ts_parser_logger(*args) nope_not_impl(__callee__) end
		def logger(*args) nope_not_impl(__callee__) end
			
			
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
=end

	end

end
