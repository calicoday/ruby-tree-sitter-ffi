# coding: utf-8
# frozen_string_literal: false

require 'ffi'

# so we can override array access to take special action for pointer members
class FFI::Struct
  alias_method :orig_aget, :[]
  alias_method :orig_aset, :[]=
end

# monkeypatch missing typedefs for aarch64-linux (prob need more)
FFI.typedef(:__uint16_t, :uint16_t)
FFI.typedef(:__uint32_t, :uint32_t)
FFI.typedef(:__uint64_t, :uint64_t)


module BossFFI

#   def version() VERSION end #???

  # inout buffer
  class ShareData < ::FFI::MemoryPointer
    def initialize(type, count=1)
      super(type, count)
    end    
    def data=(v) put(type, v, 0) end
    def data(v=nil) v ? data=(v) : get(type, 0) end
  end

### from SpecUtil
  def ref_all_types
    [:void, :bool, :string, :char, :uchar, :short, :ushort, 
      :int, :uint, :long, :ulong, :long_long, :ulong_long, 
      :float, :double, :long_double, :pointer, 
      :int8, :uint8, :int16, :uint16, :int32, :uint32, :int64, :uint64, 
      :buffer_in, :buffer_out, :buffer_inout, :varargs, ].freeze
  end

  # type_arr is array of type or [type, value]
  # eg [:uint32, [:string, "aha!!"]]
  def self.de_skid(type_p) type_p.to_s.gsub(/_p$/, '').to_sym end
  
  # cd this be a class??? above???
  def self.shared_pointer(type)
    # pointer to shared data, eg set_cancellation_flag, which gets read periodically
    # for a sign the parser should bail.
    # but we need to keep it somewhere!!!
    value_pointer(type)
  end
  def self.value_pointer(type) # or type_p???
#     puts "value_pointer type: #{type.inspect}" if type.to_s =~ 'size'
#       type = :int if type.to_s =~ 'size' ###TMP!!! PATCH!!! FIXME!!!
      
    ::FFI::MemoryPointer.new(type, 1)
  end
  
  # pretty sure type_arr cd be hash and work fine!!! CONF!!!
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

#   def self.better_bufs(type_arr, init_vals=nil, &b)
#     p_arr = type_arr.map{|e| e.is_a?(Array) ? e : [e]}.map do |type_p, v| 
#       type = de_skid(type_p)
#       o = value_pointer(type)
# #       o = ::FFI::MemoryPointer.new(type, 1)
#       o.put(type, v, 0) if v
# #       o.write(type, v) if v
#       [o, type]
#     end
#     # send just the mempointers, keep the types for reading after
#     ret = yield *(p_arr.map{|e| e[0]})
#     [ret, p_arr.map{|e, type| e.get(type, 0)}].flatten
#   end

end
