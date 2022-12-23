module TreeSitterFFI
  class Point

	  def copy_values(from) 
      vet_copy_values_klass(from)
      util_copy_values(from, [:row, :column])
    end

    # mv these to types_patch_patch.rb??? FIXME!!!
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
  end
  
  class Range
	  def copy_values(from) 
      vet_copy_values_klass(from)
		  util_copy_values(from, [:start_point, :end_point, :start_byte, :end_byte])
    end

    ### TMP!!! FIXME!!! see types_patch_oth.rb
  end

  class Input
    ### TMP!!! FIXME!!! see types_patch_oth.rb
  end

	class Logger
    ### TMP!!! FIXME!!! see types_patch_oth.rb
	end
	
  class InputEdit
	  def copy_values(from) 
      vet_copy_values_klass(from)
		  util_copy_values(from, [:start_byte, :old_end_byte, :new_end_byte,
		    :start_point, :old_end_point, :new_end_point])
    end
  end

  class Node
		def copy_values(from)
      vet_copy_values_klass(from)
      util_copy_inline_array(:context, from, 4)
		  util_copy_values(from, [:id, :tree]) # treat borrows as data??? better phrasing???
		end

    ### TMP!!! FIXME!!! see types_patch_oth.rb
		
		#???
# 		def borrow_plan() {tree: TreeSitterFFI::Tree} end
# 		def borrow_plan() {tree: :tree} end # to prevent calling with self[:tree]???
		
		def tree()
		  TreeSitterFFI::Tree.new(self[:tree])
		end

		def context=(v)
		  raise "context= expected Array of 4 Integers" unless v.is_a?(Array) && 
		    v.length == 4
		  v.each_with_index{|e, i| self[:context][i] = e}
		end

	  def context()
	    4.times.map{|i| self[:context][i]}
	  end

		# alias??? use ruby form not ts_???
		# consider the NullNode/NotANode/whatever!!!
		def ==(v)
			v = TreeSitterFFI::Node.new unless v
			TreeSitterFFI.ts_node_eq(self, v)
		end
				
		### alias for rubier -- AFTER overrides!!!
		alias_method :to_sexp, :string

  end
  
  class QueryCapture
		def copy_values(from)
      vet_copy_values_klass(from)
      # shdnt this be get/set_member???
      self[:node].copy_values(from[:node])
      self[:index] = from[:index]
# 		  util_copy_values(from, [:index]) ###???
		end

		### from_array, to_contiguous are module method!!!
		def self.from_array(arr)
# 			BossStructArray.to_contiguous(arr) do |e, fresh|
			UnitMemory.to_contiguous(arr) do |e, fresh|
			  fresh.copy_values(e)
			end
		end
  end

#   class QueryMatch < BossFFI::BossMixedStruct
  class QueryMatch 

    # make a specifying method for data/pointer, equiv to define_method or ffi_lib???
    def keep_plan() {captures: TreeSitterFFI::QueryCapture} end

    def copy_values(from)
      vet_copy_values_klass(from)
      util_copy_values(from, [:id, :pattern_index, :capture_count], 
        {captures: :capture_count})
    end
    
    # nec???
    def each_capture(&b)
      get_member(:captures).each_unit(get_member(:capture_count), &b)
    end

    def captures() 
      # get_member returns struct, get_keep_member returns blob_ptr
      get_member(:captures).burst(get_member(:capture_count))
    end
  end

#### BossPointers

  class Language
  end
  
  class Parser
    ### TMP!!! FIXME!!! see types_patch_oth.rb
  end
  
  class QueryCursor
	  # override init???
	  def self.make()
      TreeSitterFFI.ts_query_cursor_new
	  end
	  
    ### Rusty!!!
		# TextProvider??? try String input first...
		def matches(query, node, input)
		  self.exec(query, node)
		  arr = []
      match = TreeSitterFFI::QueryMatch.new
		  while(next_match(match))
		    arr << match.make_copy #only single
		  end
		  arr
    end
  end
  
  class Query
    ### TMP!!! FIXME!!! see types_patch_oth.rb

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

# 		def ts_query_capture_name_for_id(*args) nope_not_impl(__callee__) end
# 		def capture_name_for_id(*args) #:uint32, :uint32_p => :string
		def capture_name_for_id(id) #:uint32 [, add len_p] => :string
      ret, *got = BossFFI::bufs([[:uint32_t_p]]) do |uint32_t_p_1|
        TreeSitterFFI.ts_query_capture_name_for_id(self, id, uint32_t_p_1)
      end
      # got[0] is string len
      ret
# # 		  nope_not_impl(__callee__) 
# 			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# # 			ret = yield(len_p)
#       ret = ts_query_capture_name_for_id(self, id, len_p)
# 			len = len_p.get(:uint32, 0)
#       ret
		end
  end

  class Tree
  end
  
  class TreeCursor
  end
  
  ### shd be gen to tree_sitter_raw.rb (with parser(), etc)!!!
	def self.tree_cursor(node) TreeSitterFFI.ts_tree_cursor_new(node) end

  
end