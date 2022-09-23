# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/node_raw'

module TreeSitterFFI

	class Node < BossStruct

		### override for better sigs

		# prev:  child_by_field_name(String, Integer) => Tree
		# now:   child_by_field_name(String) => Tree
		alias_method :prev_child_by_field_name, :child_by_field_name
		def child_by_field_name(str)
			TreeSitterFFI.ts_node_child_by_field_name(self, str, str.length)
		end

### nope, tidy
=begin
		### override for better args/rets types

		def string
			str, ptr = TreeSitterFFI.ts_node_string(self)
			what_about_this_ref = TreeSitterFFI::AdoptPointer.new(ptr)
			str
		end
=end

		# alias??? use ruby form not ts_???
		# consider the NullNode/NotANode/whatever!!!
		def ==(v)
			v = TreeSitterFFI::Node.new unless v
			TreeSitterFFI.ts_node_eq(self, v)
		end
				
		### alias for rubier -- AFTER overrides!!!
		alias_method :to_sexp, :string

# 	def inspect() 
# 		"<Node context: #{self[:context].to_a}, id: #{self[:id]}, tree: #{self[:tree]}>" 
# 	end

### chimp
    ### rusty bindings TMP!!! 
    def utf8_text(input)
#       puts "$$$ input.inspect: #{input.inspect}"
#       puts "  self.inspect: #{self.inspect}, null?: #{self.null?}"
      ###return 'self is null node' if self.null? || self.is_null
      return '' if self.null? || self.is_null
      input[self.start_byte...self.end_byte]
    end

	  def copy_values(from)
	    4.times.each{|i| self[:context][i] = from[:context][i]}
	    self[:id] = from[:id]
	    self[:tree] = from[:tree]    
	  end
	  def context()
	    4.times.map{|i| self[:context][i]}
	  end
# 	  def tree() Tree.new(self[:tree]) end
		def inspect() four11(self, [:context, :id, :tree]) end
	end

end
