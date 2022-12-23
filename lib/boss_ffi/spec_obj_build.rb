module BossFFI
  class SpecObjBuild
    attr_reader :plan, :extra_types, :stock_objs
    
    # set up plan in subclass!!!
#     def initialize(plan, value_types)
#       @plan = plan
#       @extra_types = value_types.map{|value, name| [name, value]}.to_h
#     end
    
    def obj(type, idx)
#       puts "+++ #{type.inspect}, #{idx.inspect}"
      obj = stock_objs[type]
      obj = (obj[idx] || obj[0]) if obj
#       puts "  stock obj: #{obj}"
      return obj if obj
      # reduce any typedefd sym to builtin and make default obj
      extra_type = extra_types[type]
      type = extra_type if extra_type
#       puts "  extra type: #{type.inspect}" if type == extra_type
      obj = default_obj(type, idx)
#       puts "  dflt obj: #{obj.inspect}"
      obj ? obj : type.new
    end
    def was_obj(type, idx)
      raise "BossFFI::SpecObjBuild plan must be set up in subclass." unless plan
      call_frag = plan[type]
      call_frag = call_frag[idx] if call_frag.is_a?(Array)
      return call_frag if call_frag
      # reduce any typedefd sym to builtin and make default obj
      type = extra_types[type] if extra_types[type]
      call_frag = default_obj(type, idx)
      call_frag ? call_frag : "#{type}.new"
    end
#   def create(type, i)
# #     type = type.inspect if type.is_a?(Symbol)
#     b = plan[type]
# #     puts "no creator for #{type.inspect}." unless b
#     return nil unless b
#     b.call(i)
#   end

    def add_plan_obj(type, obj, i=nil)
      @stock_objs ||= {}
      if i
        @stock_objs[type] ||= {}
        @stock_objs[type][i] = obj
      else
        @stock_objs[type] ||= {}
        @stock_objs[type][0] = obj
      end
    end
    
    def add_plan_entry(type, idx=nil, &b)
      @plan ||= {}
      if idx
        @plan[type] ||= {}
        @plan[type][idx] = b
      else
        @plan[type] = b
      end
#       @plan[type] = (i ? 
    end
    
    def add_extra_types(value_types)
      @extra_types = value_types.map{|value, name| [name, value]}.to_h
    end

    ### from spec_plan.rb
    def common_type_frag(type)
      type = type.inspect if type.is_a?(Symbol)
      case type
      # :bool, :void ??? or are they only boss???
      when /:u?int\d*/ then 'Integer'
    #   when :char, :uchar, :short, :ushort, :int, :uint, :long, :ulong, :long_long, 
    #     :ulong_long, :int8, :uint8, :int16, :uint16, :int32, :uint32, :int64, :uint64
      when ':string' then 'String'
      when ':strptr' then 'FFI::Pointer'
      when /^:\w+_p$/ then 'FFI::Pointer'
      else
        nil
      end
    end
    
    # for builtins
    def default_obj(type, idx)
      common = common_type_frag(type)
#       puts "  common: #{common.inspect}"
      type = common if common
      case type
      when 'String' then "string_#{letter(idx)}"
      when 'Integer' then (4 + idx) #.to_s
      else
      end
    end

    #  i = 3
    # ('a'.ord + i).chr
    # => "d"
    def letter(idx) ('a'.ord + idx).chr end
  end
end