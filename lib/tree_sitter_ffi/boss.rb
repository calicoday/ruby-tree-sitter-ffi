# coding: utf-8
# frozen_string_literal: false

require 'ffi'
require 'ffi/LibC'

module TreeSitterFFI

	# wd like a ts_mem_free(p) in libtree-sitter!!!
	def self.libc_free(ptr) FFI::LibC.free(ptr) end

	module Wrap
		def cut_prefix(prefix, c_name)
			# if prefix matches, return amended method name
			prefix.to_s == c_name.to_s[0, prefix.length] ? c_name[prefix.length..-1] : nil
		end
			
		# batch attach for making instance methods that pass self as first arg
		# don't need this for module level/functions that don't need obj
		def wrap_attach(prefix, entries)
			entries.each do |e|
				c_name, args, returns = e

				raise "wrap_attach empty prefix" unless prefix && prefix.is_a?(Symbol)
					
				rb_name = cut_prefix(prefix, c_name)
				raise "wrap_attach prefix doesn't match function c_name" unless rb_name

				define_method(rb_name) do |*args|
					TreeSitterFFI.send(c_name, self, *args)
				end
				TreeSitterFFI.attach_function(c_name, args, returns)
			end
		end
		
		# chg set_thing to thing=, is_thing to thing?
		def wrap_alias(arr) 
		end
	end

	extend FFI::Library
	ffi_lib 'libtree-sitter' 

	typedef :strptr, :adoptstring
	typedef :uint16, :symbol
	typedef :uint16, :field_id
	
	typedef :pointer, :size_p
	typedef :buffer_out, :uint32_p
	typedef :buffer_out, :query_error_p
	typedef :int, :file_descriptor
	
	typedef :pointer, :file_pointer
	typedef :pointer, :array_of_range
	
	# shd return Array of objs of FFI::Struct subclass
	def self.struct_array(arr, len)
		len.times.map do |i|
			arr.class.new(arr + i * arr.class.size)
		end
	end
	def self.struct_at_index(arr, idx)
		# what about idx out of bounds???
		# arr is a pointer to a blob of len number of FFI::Struct subclass obj
		arr.class.new(arr + idx * arr.class.size)
	end
	
	def nope_not_impl(m, args=[])
		raise "Not implemented #{m} (#{args})"
	end
	
# 	def inspect()
# 		"<#{self.class.name} context: #{self[:context].to_a}, id: #{self[:id]}, tree: #{self[:tree]}>" 
# 	end
# 	def to_s() # shorter
# 	end
	
	# for received pointers to mem that the caller must free
	class AdoptPointer < FFI::AutoPointer
		def self.release(ptr)
			TreeSitterFFI.libc_free(ptr)
		end
	end

	class BossPointer < FFI::AutoPointer		
		extend Wrap
		include TreeSitterFFI

		# subclass must override with the appropriate freeing function
		def self.release(ptr) end
	end

#    s = FM::FTextItemT.new(tis[:val] + (i * FM::FTextItemT.size))	
	module BossStructArray
    include UnitMemory

		def initialize(*args)
		  # FFI::Struct expects 0 or 1 pointer 
		  # .: 1 arg not a pointer wd be error
		  # 2 args we can assume are pointer and len!!!
		  # do we want to be able to pass only pointer when multiple 1, ie opt len=nil???
			###puts "BossStructArray.init args: #{args.inspect}"
# 			len = args.pop if args.length == 2
# 			puts "BossStructArray.init args: #{args.inspect}, len: #{len}."
			super(*args)
		end

    
=begin
		def initialize(*args)
			len = args.pop if args.length == 2
			super(*args)
		end
		def struct_multiple() @struct_multiple || 1 end
		def struct_multiple=(v) 
			# vet v!!!
			@struct_multiple = v 
		end
		def struct_multiple?() @struct_multiple != nil end
		# cd be to_a???
		def to_array()
			len = struct_multiple
			len.times.map{|i| self.class.new(self.pointer + i * self.class.size)}
		end
		def self.array_of_struct(klass, &b)
			raise "array_of_struct: #{klass} not TreeSitterFFI::BossStructArray." unless 
				klass.method_defined?(:struct_multiple)
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
			ret = yield(len_p)
			len = len_p.get(:uint32, 0)
			klass.new(ret, len).to_array
		end
		# untested!!!
		# take a list of arg types, make mem pointers and pass them the block, then
		# return an array of the values
		def self.arg_p(*args, &b)
			arg_p_arr = args.map{|e| MemoryPointer.new(e, 1)}
			got = yield arg_p_arr
			values = []
			got.each_with_index{|e, i| values << e.get(args[i])}
			values
		end
		def self.to_multiple(arr, &b)
			# what if arr is nil??? pass NotARange???
			raise "to_multiple nil arr." unless arr
			# all arr members are expected to be the same class!!!
			klass = arr[0].class
			# might all be pointers into the same mem chunk but copy for now!!!
			MemoryPointer.new(klass, arr.length * klass.size).tap do |o|
				arr.each_with_index do |e, i| 
					raise "to_multiple mismatched class (#{e.class}, expected #{klass}" unless
						e.class == klass # which equals??? eq? ??? FIXME!!!
					yield(e, o.pointer + (i * o.class.size)) if block_given?
				end
				o.struct_multiple = arr.length if arr.length > 0
			end
		end
# 		def [](idx)
# 		  puts "+++ Boss [] class: #{self.class}"
# 			# does super(idx) expect anything but sym???
# 			if idx.is_a?(Symbol)
# 				raise "struct multiple set, need index." if struct_multiple?
# 				return super(idx)
# 			end
# 		  puts "+++ Boss [] class: #{self.class}"
# 			# what if I'm an empty struct pointer??? chk!!! FIXME!!!
# 			raise "struct multiple index out of bounds." unless idx >=0 && 
# 				idx < @struct_multiple
# 			self.class.new(self.pointer + (idx * self.class.size))
# 		end
=end

	end
	
	class BossStruct < FFI::Struct
		extend Wrap
		include TreeSitterFFI
	end
	
	class BossManagedStruct < FFI::ManagedStruct
		extend Wrap
		include TreeSitterFFI
	end
end


=begin
### why we need a #free...
/**
 * Compare an old edited syntax tree to a new syntax tree representing the same
 * document, returning an array of ranges whose syntactic structure has changed.
 *
 * For this to work correctly, the old syntax tree must have been edited such
 * that its ranges match up to the new tree. Generally, you'll want to call
 * this function right after calling one of the `ts_parser_parse` functions.
 * You need to pass the old tree that was passed to parse, as well as the new
 * tree that was returned from that function.
 *
 * The returned array is allocated using `malloc` and the caller is responsible
 * for freeing it using `free`. The length of the array will be written to the
 * given `length` pointer.
 */
TSRange *ts_tree_get_changed_ranges(
  const TSTree *old_tree,
  const TSTree *new_tree,
  uint32_t *length
);

/**
 * Get an S-expression representing the node as a string.
 *
 * This string is allocated with `malloc` and the caller is responsible for
 * freeing it using `free`.
 */
char *ts_node_string(TSNode);

=end