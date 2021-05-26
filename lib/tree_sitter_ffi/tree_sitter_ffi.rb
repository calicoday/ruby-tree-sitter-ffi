# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/parser'
require 'tree_sitter_ffi/language'


module TreeSitterFFI

# 	def self.parser_json() TreeSitterFFI.parser_json end
	def self.parser_json() TreeSitterFFILang::JSON.parser end

# json ruby bash c embedded-template html java javascript make markdown rust
	def self.parser_ruby() TreeSitterFFILang::Ruby.parser end
	def self.parser_bash() TreeSitterFFILang::Bash.parser end
	def self.parser_c() TreeSitterFFILang::C.parser end
	def self.parser_embedded_template() TreeSitterFFILang::EmbeddedTemplate.parser end
	def self.parser_html() TreeSitterFFILang::HTML.parser end
	def self.parser_java() TreeSitterFFILang::Java.parser end
	def self.parser_make() TreeSitterFFILang::Make.parser end
	def self.parser_markdown() TreeSitterFFILang::Markdown.parser end
	def self.parser_python() TreeSitterFFILang::Python.parser end
	def self.parser_not_a_lang() TreeSitterFFILang::NotALang.parser end

	def self.parser_rust() TreeSitterFFILang::Rust.parser end
	def self.parser_javascript() TreeSitterFFILang::JavaScript.parser end
	
	def self.parser() TreeSitterFFI.ts_parser_new end
	def self.tree_cursor(node) TreeSitterFFI.ts_tree_cursor_new(node) end

# class IOVec < FFI::Struct
#   layout :base, :pointer,
#          :len, :size_t
# end
# 
# iovlen = 3
# iov = FFI::MemoryPointer.new(IOVec, iovlen)
# iovs = iovlen.times.collect do |i|
#   IOVec.new(iov + i * IOVec.size)
# end
# 
# iovs[0][:base] = ...
# iovs[0][:len]  = ...
# iovs[1][:base] = ...
# iovs[1][:len]  = ...
# iovs[2][:base] = ...
# iovs[2][:len]  = ...
# 
# msghdr.msg_iov = iov
# msghdr.msg_iovlen = iovlen	

	
		# untested!!!
		# take a list of arg types, make mem pointers and pass them the block, then
		# return an array of the values
# 		def self.arg_p(*args, &b)
# 			arg_p_arr = args.map{|e| MemoryPointer.new(e, 1)}
# 			got = yield arg_p_arr
# 			values = []
# 			got.each_with_index{|e, i| values << e.get(args[i])}
# 			values
# 		end
# 		def self.array_of_struct(klass, &b)
# 			raise "array_of_struct: #{klass} not TreeSitterFFI::BossStructArray." unless 
# 				klass.method_defined?(:struct_multiple)
# 			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# 			ret = yield(len_p)
# 			len = len_p.get(:uint32, 0)
# 			klass.new(ret, len).to_array
# 		end

=begin
	def self.arg_shuttle(args_types)
		Shuttle.new(args_type)
	end
	class Shuttle
		attr_reader :plan
		
		def intialize(args_types)
			# args_types is hash of arg_name: type
			# plan is hash of arg_name: {type: type, memptr: memptr}
			@plan = {}
			args_types.each do |name, type|
				plan[name] = {type: type, memptr: FFI::MemoryPointer.new(type, 1)}
			end
		end
		def []=(v)
			type, memptr = plan[k]
			memptr.set(type, v)
		end
		def [](k)
			type, memptr = plan[k]
			memptr.get(type)
		end
		def memptr(k)
			type, memptr = plan[k]
			memptr
		end
		alias_method :star_p, :memptr
	end
	
	# unused so far!!!
	def self.value_p(size)
		raise "value_p unexpected #{size.inspect} (:size_p, :uint32_p)" unless [:size_p, 
			:uint32_p].include?(size)
		FFI::MemoryPointer.new(size, 1)
	end
=end		
	
end
