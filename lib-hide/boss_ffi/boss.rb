# coding: utf-8
# frozen_string_literal: false

require 'ffi'
require 'ffi/LibC'
require 'boss_ffi/unit_memory'

module BossFFI

	# wd like a ts_mem_free(p) in libtree-sitter!!!
	def self.libc_free(ptr) FFI::LibC.free(ptr) end

	module Attach
	  module_function

    # have to specify the mod bc we may have multiple ancestors between class and mod
	  def wrap_attach(mod, prefix, entries)
	    Attach.wrap(mod, self, prefix, entries)
	  end
	  def class_attach(c_name, args, returns)
	    Attach.to_module(self, c_name, args, returns)
	  end
	  def module_attach(mod, c_name, args, returns)
	    Attach.to_module(mod, c_name, args, returns)
	  end
	  
	  
	  def lib_and_typedefs(lib, arr)
      extend FFI::Library
	    ffi_lib(lib) 
	    arr.each do |type, aka|
	      typedef type, aka
	    end
	  end
	  
# 	  def lib(lib) FFI::Library.ffi_lib(lib) end
	  def lib(lib) 
      extend FFI::Library
	    ffi_lib(lib) 
# 	    FFI::Library.ffi_lib(lib) 
	  end
	  
	  def typedefs(arr)
	    arr.each do |type, aka|
	      typedef type, aka
	    end
	  end
	  
	  def to_module(mod, *args) mod.attach_function(*args) end
	  def to_double(mod, klass, rb_name, c_name, args, returns)
      klass.define_method(rb_name) do |*args|
        mod.send(c_name, self, *args)
      end
      mod.attach_function(c_name, args, returns)
	  end

		def cut_prefix(prefix, c_name)
			# if prefix matches, return amended method name
			prefix.to_s == c_name.to_s[0, prefix.length] ? c_name[prefix.length..-1] : nil
		end
		def wrap(mod, klass, prefix, entries)
			entries.each do |e|
				c_name, args, returns = e

				raise "wrap_attach empty prefix" unless prefix && prefix.is_a?(Symbol)
					
				rb_name = cut_prefix(prefix, c_name)
				raise "wrap_attach prefix doesn't match function c_name" unless rb_name
				to_double(mod, klass, rb_name, c_name, args, returns)
      end
		end
	end
	
	def nope_not_impl(m, args=[])
		raise "Not implemented #{m} (#{args})"
	end

	# for received pointers to mem that the caller must free
	class AdoptPointer < FFI::AutoPointer
		def self.release(ptr)
			BossFFI.libc_free(ptr) ### does FFI::Pointer#free do this???!!! CONF!!!
		end
	end
	
	# BorrowPointer <= basic, non-freeing Pointer. name only for docs
	#   receive alloc'd mem to use, leave lib to free it
	# AdoptPointer < FFI::AutoPointer
	#   receive alloc'd mem and free() when we're done with it -- FFI::Pointer#free???!!!
	# FosterPointer < FFI::MemoryPointer
	#   alloc mem and hand off to lib, leave lib to free it -- does this happen???
	# Struct -- data-only Struct
	# MixedStruct -- data and/or one or more pointer

	class BossPointer < FFI::AutoPointer		
		extend Attach
# 		include BossFFI

		# subclass must override with the appropriate freeing function
		def self.release(ptr) end
	end

	class BossStruct < FFI::Struct
		extend Attach
# 		include BossFFI
    include UnitMemory
	end
	
	class BossMixedStruct < MixedStruct # MixedStruct in unit_memory.rb
		extend Attach
# 	  include BossFFI
	end
	
# 	class BossManagedStruct < FFI::ManagedStruct
# 		extend Attach
# # 		include BossFFI
# 	end
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