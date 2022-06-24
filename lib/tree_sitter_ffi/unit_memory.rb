require 'ffi'

require 'ffi'

module TreeSitterFFI

  # MultiStruct, ie array of struct
	module UnitMemory

    def make_copy(count=1)
      blob = FFI::MemoryPointer.new(self.class, count)
      fresh = self.class.new(blob)
      fresh.copy_multiple(self, count)
      fresh
    end
    def copy_multiple(from, count)
      from_p = FFI::Pointer.new(from.class, from.to_ptr)
      fresh_p = FFI::Pointer.new(self.class, self.to_ptr)
		  keeps = count.times.map do |i| 
		    from_unit = from.class.new(from_p[i])
		    fresh_unit = self.class.new(fresh_p[i])
		    fresh_unit.copy_values(from_unit)
		  end
		  keeps
    end
	  def copy_values(from) 
		  raise "UnitMemory#copy_values must be overridden in #{self.class}."
	  end
	  def util_copy_values(data_members, from)
      unless from && from.is_a?(self.class)
        raise "#{self.class}#copy_value: to must be class #{self.class} (#{from.inspect})"
      end
      data_members.each{|k| self[k] = from[k]}
	  end

    # assumes each arr elem is a single struct!!! FIXME!!!
    def make_contig(arr)
      klass = arr[0].class
      count = arr.length
      blob = FFI::MemoryPointer.new(klass, count)
      fresh = self.class.new(blob)
      fresh_p = FFI::Pointer.new(self.class, self.to_ptr)
      keeps = []
      arr.each_with_index do |e, i|
        fresh_unit = self.class.new(fresh_p[i])
        keeps << fresh_unit.copy_values(e)
      end
      fresh.mixed_set_keep(keeps) if fresh.respond_to?(:mixed_set_keep)
#       keeps
      fresh
    end
    
    def make_units(count)
      # self is the multi from!!!
      from_p = FFI::Pointer.new(self.class, self.to_ptr)
#       from_p = FFI::Pointer.new(from.class, from.to_ptr)
#       fresh_p = FFI::Pointer.new(self.class, self.to_ptr)
      arr = []
		  count.times.map do |i| 
		    from_unit = self.class.new(from_p[i])
        blob = FFI::MemoryPointer.new(self.class, 1)
        fresh = self.class.new(blob)
		    fresh_unit = fresh
# 		    fresh_unit = self.class.new(fresh_p[i])
		    keeps = fresh_unit.copy_values(from_unit)
		    # set keeps in fresh_unit if nec!!!
		    ### FIXME!!!
		    fresh_unit.mixed_set_keep(keeps) if fresh_unit.respond_to?(:mixed_set_keep)
		    arr << fresh_unit
		  end
# 		  keeps
      arr
    end
    

    ### treesit UnitMemory stuff...

    ### very sus!!! FIXME!!!
# 		alias_method :ffi_member, :[]
# 		alias_method :ffi_member=, :[]=
# 		def [](k)
#     #def get_by_index(k)
# 		  return super(k) unless k.is_a?(Integer)
# 		  raise "BossStructArray#[]: k (#{k}) negative index" unless k > -1
# 		  self.class.new(self.to_ptr + k * self.class.size)
# 		end
# 		def []=(k, v)
#     #def set_by_index(k, v)
# 		  return super(k, v) unless k.is_a?(Integer)
# 		  raise "#{self.class}#[]=: k (#{k}) negative index" unless k > -1
#       unless v && v.is_a?(self.class)
#         raise "#{self.class}#[]=: value must be class #{self.class} (#{v.inspect})"
#       end
#       self.class.new(self.to_ptr + k * self.class.size).tap do |o|
#         o.copy_values(v)
#       end
#       # ret new or self???
#       self
# 		end

		### array of unit pointers
		def to_a()
		  ### TMP!!! 
		  return burst(1)
# 		  puts "...UM#to_a"
# 		  return [] if unit_count < 1
# 			unit_count.times.map{|i| self.class.new(self.to_ptr + i * self.class.size)}
		end
		### array of unit copies, take count bc no multi TMP!!!
		def burst(count)
		  return [] if count < 1
		  make_units(count)
# 			count.times.map{|i| self.class.new.copy_values(self[i])}
		end
    ### burst needs updating!!! FIXME!!!

    # takes array of 1 or more struct(_array), each of which is multiple 1 or more
    # doesn't check any overlapping???!!! what does this even mean???
		# => multi self
		def to_contiguous(arr)
      ### TMP!!! FIXME!!!
		  return make_contig(arr)
		  
		  
			raise "UnitMemory#to_contiguous: nil arr." unless arr && arr.length > 0
			klass = arr[0].class
			raise "UnitMemory#to_contiguous: #{klass} does not include UnitMemory" unless 
			  arr[0].is_a?(UnitMemory)
			units = arr.map(:to_a).join.map do |e|
        raise "UnitMemory#to_contiguous mismatched class (#{e.class}, " +
          "expected #{klass}" unless e.class == klass
			end
			klass.new(FFI::MemoryPointer(klass, units.length * klass.size)).tap do |o|
# 		  klass.new(klass, units.length * klass.size).tap do |o|
        ### TMP!!!
		    puts "to_contig before each_unit"
		    o.each_unit(units.length){|e, i| e.copy_values(units[i])}
# 		    o.unit_count = units.length
# 		    puts "to_contig before each_unit"
# 		    o.each_unit{|e, i| e.copy_values(units[i])}
      end			
		end
		alias_method :to_contig, :to_contiguous
		
  end

  # MixedStruct wraps a C struct that contains one or more pointers (as opposed to a 
  # 'data struct' that has NO pointers and just values). When we want to set a pointer
  # member in Ruby, we need to keep a reference to the MemoryPointer (or other wrapper) 
  # holding the new allocated memory blob for as long as we need the blob or the Ruby
  # GC may collect it too early.
  class MixedStruct < FFI::Struct
    
    include UnitMemory
  
    def copy_multiple(from, count)
      @keep = super
    end

    def util_copy_values(data_members, pointer_members_and_counts, from)
      # data members, eg [:simple_count]
      data_members.each{|k| self[k] = from[k]}
      # pointer members and their counts, eg {simples: from[:simple_count]}
      unit_keeps = []
      pointer_members_and_counts.each do |k,v|
      if v > 0
        fresh = from[k].make_copy(v)
        unit_keeps << fresh
        mixed_set_member(k, fresh)
      end
      end
      unit_keeps
    end
    
    def keep_keys() 
		  raise "MixedStruct#keep_keys must be overridden in #{self.class}."
    end
    
#     def clear_keep(k=nil)
#       k ? @keep[k] = nil : @keep = {}
#     end
#     def add_keep(k, v)
#       @keep[k] ||= []
#       @keep[k] << v
#     end
    def mixed_set_keep(v)
      @keep = v
    end
#     def mixed_set_keep(k, v)
#       @keep ||= {}
#       @keep[k] = v
#       self.keep_simples = v
#     end

    alias_method :orig_aset, :[]=
    def []=(k, v)
      raise "can't set mixed struct member #{k} directly." if k && keep_keys.include?(k)
      super(k, v)
    end
    
    def mixed_set_member(k, v)
      raise "bad mixed_set_member." unless k && keep_keys.include?(k)
      orig_aset(k, v)
#       FFI::Struct.instance_method(:[]=).bind(self).call(k, v)
    end
  
  end
end