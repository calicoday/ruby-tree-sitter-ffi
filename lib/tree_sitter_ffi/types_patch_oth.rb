### misc stuff that was in pre-nifty but hasn't been added back, may not be nec!!!

module TreeSitterFFI

  class Range
    # props, props=
  
    ### override init!!!
    def self.make(arr)
      # vet arr shape!!!
      self.new.tap do |o|
        o.props = (arr)
      end
    end

		### from_array, to_contiguous are module method!!!
		def self.from_array(arr)
# 			BossStructArray.to_contiguous(arr) do |e, fresh|
			UnitMemory.to_contiguous(arr) do |e, fresh|
			  fresh.copy_values(to)
			end
		end
  end

  ### TMP!!! FIXME!!! not_impl
  class Input
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

  ### TMP!!! FIXME!!! not_impl
# typedef struct {
#   void *payload;
#   void (*log)(void *payload, TSLogType, const char *);
# } TSLogger;
	class Logger
		def initialize(len=256)
			super()
			self[:payload] = FFI::MemoryPointer.new(:char, len)
		end
		def payload=(p)
			# raise "expected memptr" unless is_a?(MemPointer)???
			self[:payload] = p
		end
	end
	

  class InputEdit
	  def copy_values(from) 
      vet_copy_values_klass(from)
		  util_copy_values(from, [:start_byte, :old_end_byte, :new_end_byte,
		    :start_point, :old_end_point, :new_end_point])
    end

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

  class Node

    ### do we have this somewhere???
    
		### override for better args/rets types

		def string
			str, ptr = TreeSitterFFI.ts_node_string(self)
			what_about_this_ref = TreeSitterFFI::AdoptPointer.new(ptr)
			str
		end

    ### these are curr in run_rusty_helper.rb
    ### rusty bindings TMP!!! 
    def utf8_text(input)
      return '' if self.null? || self.is_null
      input[self.start_byte...self.end_byte]
    end

# 	  def tree() Tree.new(self[:tree]) end
		def inspect() four11(self, [:context, :id, :tree]) end
  end
  
  class QueryCapture
	  ### by hand for now!!!
	  def inspect()
	    ### from four11
	    return 'nil obj' if self.null?
	    node = (self[:node] && !self[:node].is_null ?
	      self[:node].string.inspect : self[:node].inspect)
      "<#{self.class.name.split(':').last}" + 
        " node: #{node}>"
	  end
  end

	class QueryMatch
		def inspect() 
		  four11(self, [:id, :pattern_index, :capture_count], 
		    {captures: captures}) 
		end
  end

#### BossPointers

  class Parser
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
			

    ### raw...
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
		
	### tidy...

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
  
  class Query
    ### TMP!!! by hand
		# currently not implemented
		### reattach ts_ form
    c_name, args, returns =  
      [:ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string]
    puts "c_name: #{c_name.inspect}, args: #{args.inspect}, returns: #{returns.inspect}"
    puts "=== vers: #{TreeSitterFFI::VERSION}"
    TreeSitterFFI.attach_function(c_name, args, returns)

# 		def ts_query_string_value_for_id(*args) nope_not_impl(__callee__) end
		def string_value_for_id(*args) 
# 		  nope_not_impl(__callee__) 
		end
    
  end
  
end