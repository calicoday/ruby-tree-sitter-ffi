require 'ffi'

    # module gets included before :[], :[]= are defined???
    # "alias_method': undefined method `[]=' for module `ShrubFFI::OthMemory' (NameError)"
    ###alias_method :orig_aget, :[]
#     alias orig_aget []
# so we can override array access to take special action for pointer members
class FFI::Struct
  alias_method :orig_aget, :[]
  alias_method :orig_aset, :[]=
end

module BossFFI

  # MultiStruct, ie array of struct
	module UnitMemory
    module Util
      module_function
      
      def parallel_units(to_ptr, to_klass, from_ptr, from_klass, count, &b)
        from_p = FFI::Pointer.new(from_klass, from_ptr)
        fresh_p = FFI::Pointer.new(to_klass, to_ptr)
        keeps = count.times.map do |i| 
          from_unit = from_klass.new(from_p[i])
          fresh_unit = to_klass.new(fresh_p[i])
          yield(fresh_unit, from_unit)
        end
      end
      
      # use caller m trick from dimsome!!! FIXME!!!
      def vet_same_klass(to, from, m)
        unless from && from.is_a?(to.class)
          raise "#{m}: from must be class #{to.class} (#{from.inspect})"
        end
      end
      
      # to, from are structs not blob_ptr
      # data_members, pointer_members_and_counts may be nil if not applicable
      def copy_values(to, from, data_members, pointer_members_and_counts)
        # is this nec if all copy_values already vet??? keep for now bc some might lack
        vet_same_klass(to, from, "#{to.class}#copy_values")
#         unless from && from.is_a?(to.class)
#           raise "#{to.class}#copy_value: to must be class #{to.class} (#{from.inspect})"
#         end
        # data members, eg [:simple_count]
        data_members.each{|k| to[k] = from[k]} if data_members
        return nil unless pointer_members_and_counts
      
        unless from.respond_to?(:keep_plan)
          raise "copy_values: no keep_plan for handling " +
            "#{pointer_members_and_counts.inspect}"
        end
        
        # pointer members and their counts, eg {simples: from[:simple_count]}
        pointer_members_and_counts.each do |k, v|
          v = from[v] if v && v.is_a?(Symbol) # get count
          next unless v > 0
        
          from_klass = from.keep_plan[k]
          from_ptr = from.get_keep_member(k)
          fresh = from_klass.new(from_ptr).make_copy(v)
          # we don't support ptr to struct, only :pointer!!!
          to.set_keep_member(k, fresh.to_ptr) 
        end
        nil # no useful return value expected
      end
      
      # can this be useful without struct info???
#       def copy_inline_array(to_arr, from_arr, count)
#         count.times.each{|i| to_arr[i] = from_arr[i]}
#       end
      
      def lazy_keeper()
        unless self.class_variable_defined?(:@@shrub_ffi_unit_memory_keep_blob)
          return self.class_variable_set(:@@shrub_ffi_unit_memory_keep_blob, {})
        end
        self.class_variable_get(:@@shrub_ffi_unit_memory_keep_blob)
      end
      
      # caller shdnt expect useful return value!!!
      def keep_blob(klass, keep_ptr, k, blob_ptr)
        addr = keep_ptr.address
        keeper = lazy_keeper
        return keeper.delete(addr) if k.nil?
        
        keeper[addr] ||= {}
        keeper[addr].delete(k) # if any
        keeper[addr][k] = FFI::AutoPointer.new(
          FFI::Pointer.new(blob_ptr), klass.method(:free_blob)) if blob_ptr        
      end
    end

    def util_parallel_units(from, count, &b)
      Util.parallel_units(self.to_ptr, self.class, from.to_ptr, from.class, count, &b)
    end

    def util_copy_values(from, data_members, pointer_members_and_keys_or_counts=nil)
      return Util.copy_values(self, from, 
        data_members, nil) unless pointer_members_and_keys_or_counts
        
      pointer_members_and_counts = pointer_members_and_keys_or_counts.map do |k, v|
        v.is_a?(Symbol) ? [k, v] : [k, from[k]]
      end.to_h
      Util.copy_values(self, from, data_members, pointer_members_and_counts)
    end
    
    def util_keep_blob(k, blob_ptr)
      Util.keep_blob(self.class, self.to_ptr, k, blob_ptr)
    end

	  def util_copy_inline_array(k, from, count)
	    to_arr = self[k]
	    from_arr = from[k]
	    count.times.each{|i| to_arr[i] = from_arr[i]}
# 	    Util.copy_inline_array(self[k], from[k], count)
	  end
	  
# 	  def util_copy_borrow_pointer(k, from)
# # 	    self[k].write_pointer(from[k].get_pointer(0))
#       self[k] = FFI::Pointer.new(from[k])
# 	  end
	  
	  def vet_copy_values_klass(from)
	    to = self
      Util.vet_same_klass(to, from, "#{to.class}#copy_values")
    end

    def make_copy(count=1)
      blob = FFI::MemoryPointer.new(self.class, count)
      blob.autorelease = false
      blob_ptr = FFI::Pointer.new(blob)
      fresh = self.class.new(blob_ptr)
      fresh.copy_multiple(self, count)
      fresh
    end

    def copy_multiple(from, count)
      util_parallel_units(from, count) do |fresh_unit, from_unit|
        fresh_unit.copy_values(from_unit)
      end
    end

	  def copy_values(from) 
		  raise "UnitMemory#copy_values must be overridden in #{self.class}."
	  end


    def [](k)
      return get_unit(k) if k.is_a?(Integer)
      return super unless keep_member?(k)
      raise "Can't access field by key :#{k}, use get_keep_member."
    end    

    def []=(k, v)
      return set_unit(k, v) if k.is_a?(Integer)
      return super unless keep_member?(k)
      raise "Can't set :pointer struct member :#{k} directly, use set_keep_member." 
    end    

    # these do the pointer hopping but cannot check i is in bounds, do that outside!!!
    def get_unit(i)
      unit_p = FFI::Pointer.new(self.class, self.to_ptr)
      unit = self.class.new(unit_p[i])
    end
    def set_unit(i, v)
      unit = get_unit(i)
      unit.copy_values(v)
    end
    def each_unit(count, &b)
      count.times do |i|
        yield(get_unit(i), i)
      end
    end
    
    
    def burst(count)
      count.times.map do |i|
        get_unit(i).make_copy(1)
      end
    end
		alias_method :make_units, :burst
    
    # assumes each arr elem is a single struct!!! FIXME!!!
    def glom(arr)
      klass = arr[0].class
      # vet arr element classes
      count = arr.length
      blob = FFI::MemoryPointer.new(klass, count)
#       blob.autorelease = false ### nope, not here, only inner mixed
      blob_ptr = FFI::Pointer.new(blob)
      fresh = self.class.new(blob_ptr)
      fresh.each_unit(count) do |unit, i|
        # copy arr[i] into unit
        unit.copy_values(arr[i])
      end
      fresh
    end
		alias_method :make_contig, :glom
		alias_method :make_contiguous, :glom
    
    
    def keep_member?(k)
      return false unless k && respond_to?(:keep_plan) && keep_plan
      keep_plan.keys.include?(k)
    end

    def get_keep_member(k)
      raise "bad get_keep_member key :#{k}." unless keep_member?(k)
      orig_aget(k)
    end
    
    def set_keep_member(k, v)
      raise "bad set_keep_member key :#{k}." unless keep_member?(k)
      util_keep_blob(k, v)
      orig_aset(k, v)
    end
    
    def get_member(k)
      return self[k] unless keep_member?(k)
      member = get_keep_member(k)
      klass = keep_plan[k]
      klass ? klass.new(member) : member
    end
    
    def set_member(k, v)
      return self[k] = v unless keep_member?(k)
      ptr = (v.is_a?(FFI::Pointer) ? v : v.to_ptr)
      set_keep_member(k, ptr)
      # nice the return value???
    end
    
    
    

  end
  
=begin
  module MixedStructExtra
    def keep_plan() 
		  raise "MixedStruct#keep_plan must be overridden in #{self.class} to supply {pointer_member_key: pointer_member_class}."
    end

    # this is needed for any mixed, make Mixed module??? MixedStruct superklass!!!
    def self.release(ptr)
      # remove keeps for pointer, so they get GC'd
      Util.keep_blob(self, ptr, nil, nil) # delete all for ptr.addr
    end
    
    def self.free_blob(ptr)
      # add for debug puts anyway 
      # as we're here bc autopointer, DO we need to ptr.free/ptr.autorelease=true???!!!
      # This gets warning: 'warning: calling free on non allocated pointer'
      # ptr.free
    end
  end
=end

  # to get the mem handling, class must be ManagedStruct but
  # we can dev a plan FFI::Struct by just including MixedStructExtra and allow leak
  class MixedStruct < FFI::ManagedStruct
    include UnitMemory
#     include MixedStructExtra ### nope, why???!!! extend???

    def initialize(blob_ptr=nil)
      unless blob_ptr
        blob = FFI::MemoryPointer.new(self.class, 1)
        blob.autorelease = false
        blob_ptr = FFI::Pointer.new(blob)
      end
      super(blob_ptr)
    end

    def keep_plan() 
		  raise "MixedStruct#keep_plan must be overridden in #{self.class} to supply {pointer_member_key: pointer_member_class}."
    end

    # this is needed for any mixed, make Mixed module??? MixedStruct superklass!!!
    def self.release(ptr)
      # remove keeps for pointer, so they get GC'd
      Util.keep_blob(self, ptr, nil, nil) # delete all for ptr.addr
    end
    
    def self.free_blob(ptr)
      # add for debug puts anyway 
      # as we're here bc autopointer, DO we need to ptr.free/ptr.autorelease=true???!!!
      # This gets warning: 'warning: calling free on non allocated pointer'
      # ptr.free
    end
  end
end