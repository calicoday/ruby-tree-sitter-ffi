require 'tree_sitter_ffi' 

if ENV['TREE_SITTER_RUNTIME_VERSION']
  # internal dev use only for versioning sys
  
else
  # Add desired language parser libraries here.
  TreeSitterFFI.add_lang(:tree_sitter_json, 
    '/usr/local/lib/tree-sitter-json/libtree-sitter-json.0.19.0.dylib')
end


ref_all_types = [:void, :bool, :string, :char, :uchar, :short, :ushort, :int, :uint, :long, :ulong, :long_long, :ulong_long, :float, :double, :long_double, :pointer, :int8, :uint8, :int16, :uint16, :int32, :uint32, :int64, :uint64, :buffer_in, :buffer_out, :buffer_inout, :varargs, ]

module SpecUtil
  # type_arr is array of type or [type, value]
  # eg [:uint32, [:string, "aha!!"]]
  def self.de_skid(type_p) type_p.to_s.gsub(/_p$/, '').to_sym end
  
  def self.value_pointer(type) # or type_p???
    ::FFI::MemoryPointer.new(type, 1)
  end
  
  def self.bufs(type_arr, &b)
    p_arr = type_arr.map{|e| e.is_a?(Array) ? e : [e]}.map do |type_p, v| 
      type = de_skid(type_p)
      o = value_pointer(type)
#       o = ::FFI::MemoryPointer.new(type, 1)
      o.put(type, v, 0) if v
#       o.write(type, v) if v
      [o, type]
    end
    # send just the mempointers, keep the types for reading after
    ret = yield *(p_arr.map{|e| e[0]})
    [ret, p_arr.map{|e, type| e.get(type, 0)}].flatten
  end
end

require 'boss_ffi'

module TreeSitterFFI
  class SpecObjBuild < ::BossFFI::SpecObjBuild
    # in super: attr_reader :plan, :extra_types
    
    # set up plan in subclass!!!
    def initialize
      @pars = TreeSitterFFI.parser
#       json = TreeSitterFFI.parser_json
      TreeSitterFFI.add_lang(:tree_sitter_json, 
        '/usr/local/lib/tree-sitter-json/libtree-sitter-json.0.19.0.dylib')
      json = TreeSitterFFI.tree_sitter_json
#       @pars.set_language(json).should == true
#        @pars.set_language(json)
      raise "set_language(json) failed." unless @pars.set_language(json)
      @input = "[1, null]"
      @tree = @pars.parse_string(nil, @input, @input.length)
      @root_node = @tree.root_node
      @array_node = @root_node.named_child(0)
      @number_node = @array_node.named_child(0)

      # from query_raw_spec.rb
      @sexp = '(document (array (number) (null)))'
      @err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
      @err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
      # 		@err_type_p = FFI::MemoryPointer.new(TreeSitterFFI::EnumQueryError, 1) # enum!!!
      @query = TreeSitterFFI.ts_query_new(@json, @sexp, @sexp.length,
      @err_offset_p, @err_type_p)

      #(plan, value_types)
#       @plan = plan
#       @extra_types = value_types.map{|value, name| [name, value]}.to_h
#       @extra_types = [[:uint16, :symbol], [:uint16, :field_id]]
      value_types = [[:uint16, :symbol], [:uint16, :field_id]]
      add_extra_types(value_types)
#       @plan = {}
#       add_plan_entry(TreeSitterFFI::Parser){@pars}
#       add_plan_entry(TreeSitterFFI::Tree){@tree}
#       add_plan_entry(TreeSitterFFI::Node){@number_node}

      add_plan_obj(TreeSitterFFI::Parser, @pars)
      add_plan_obj(TreeSitterFFI::Tree, @tree)
      add_plan_obj(TreeSitterFFI::Node, @number_node)
      add_plan_obj(TreeSitterFFI::Query, @query)
    end
  end
    
end
