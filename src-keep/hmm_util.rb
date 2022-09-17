# misc experimental scraps

require 'ffi'

##### Actu just notes so far!!!

module Hmm
	module_function

	# [16] pry(main)> len = File.size(filename)
	# => 10
	# [17] pry(main)> buf = FFI::Buffer.new(:char, len, true)
	# => #<FFI:Buffer:0x00007fb864b81690 address=0x00007fb864b85760 size=10>
	# [18] pry(main)> ret = FFI::LibC.fgets(buf, len, f)
	# => #<FFI::Pointer address=0x00007fb864b85760>
	# [19] pry(main)> buf.get_string(0)
	# => "ll]\n"
	# [20] pry(main)> f= FFI::LibC.fopen(filename, len)
	# TypeError: no implicit conversion of Integer into String
	# from (pry):20:in `fopen'
	# [21] pry(main)> f= FFI::LibC.fopen(filename, "r")
	# => #<FFI::Pointer address=0x00007fffade3a0c8>
	# [22] pry(main)> ret = FFI::LibC.fgets(buf, len, f)
	# => #<FFI::Pointer address=0x00007fb864b85760>
	# [23] pry(main)> buf.get_string(0)
	# => "[1, null]"

	require 'ffi/LibC'

	def fopen(filename, op='r', &b)
		f = FFI::LibC.fopen(filename, op)
		if block_given?
			raise "fopen failed for #{filename}, #{op}." if f.null?
			yield f, op
			fclose(f) ### errcode???!!!
			return true
		end
		f.null? ? nil : f
	end
	def fclose(f) FFI::LibC.fclose(f) end # do we care about errcodes???
	
	def write_dot(tree, filename='tree2.dot')
		fopen(filename, 'w') do |f|
			tree.print_dot_graph(f)
		end
		puts "wrote dot."
	end
# 	def write_dot(tree, filename='tree.dot')
# 		f = FFI::LibC.fopen(filename, 'w')
# 		if f.null?
# 			puts "  fopen failed. f.null?: #{f.null?}"
# 			return
# 		end
# 		tree.print_dot_graph(f)
# 		FFI::LibC.fclose(f)
# 		puts "wrote dot."
# 	end

	#### terminal color

	# color_code = 31
	# text = "Aha!!"
	def color_puts(color_code, text)
		puts "\e[#{color_code}m#{text}\e[0m"
		puts "\e[32m#{text}"
	end
	
	
#### inline C

	# this may not work yet but eg...
	
	require 'ffi/inline'
	# or RubyInline???

	### nope, try all c
	# 		tree.print_dot_graph(fp)
	def inline_write_dot(tree, filename='tree.dot')
		extend FFI::Inline
		inline('
			#include <stdio.h>
			//void ts_tree_print_dot_graph(const TSTree *, FILE *);
			void ts_tree_print_dot_graph(const void *, FILE *);
			void do_it(void *treep, char *filename) {
				FILE *fp = fopen(filename, "w");
				ts_tree_print_dot_graph(treep, fp);
				fclose(fp);
			}
			')
		do_it(tree, filename)
	end


end