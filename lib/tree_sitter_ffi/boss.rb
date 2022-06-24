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

	end
	
	class BossStruct < FFI::Struct
		extend Wrap
		include TreeSitterFFI
	end
	
	class BossMixedStruct < MixedStruct # MixedStruct in unit_memory.rb
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