require 'ffi'

module TreeSitterFFI

  # type MUST be recorded in ffi::memptr somewhere, but I can't find it yet!!!
  # wrap to record type and overload value, value=
  # keep count and handle arrays???
  class Memory < FFI::MemoryPointer
    attr_reader :type
    def initialize(type, count=nil)
      super
      @type = type
    end
    # ret type???
    def value() read(type) end
    def value=(v)
      # vet type
      write(type, v)
    end
    def self.sase(arr)
      arr.map{|e| self.class.new(e)}
    end
    # doubtful this is useful now...
    # len, str = rsvp([:int32, :string]){|len_p, str_p| len_p.value=3; str_p.value="aha"}
    # => [3, "aha"]
    def self.rsvp(arr, &b)
      params = sase(arr)
      yield *params
      arr.zip(params.map(:value))
    end
  end


	module UnitMemory
### daisy
    def prev_make_copy
#       puts "make_copy match: #{self.inspect}"
#       if self[:capture_count] > 0
#         wrap = FFI::MemoryPointer.new(QueryCapture, self[:capture_count])
# 			  puts "  self[:capture_count]: #{self[:capture_count]}"
# 			  puts "  QueryCapture.size: #{QueryCapture.size}"
#         puts "  wrap.size: #{wrap.size}" # count * QueryCapture.size
#         puts "  wrap.type_size: #{wrap.type_size}" # QueryCapture.size
#       end
      self.class.new.copy_values(self).tap do |o|
#           puts "    o: #{o[:captures].inspect}"
      end
    end
    
    def make_copy(count=1)
      raise "make_copy: count must be > 0 (#{count})." unless count && count > 0
      blob = FFI::MemoryPointer.new(self, count)
      self.class.new(blob).tap do |o|
        o.copy_multiple(self, count)
      end
    end
    
    # TMP!!! ref
#     def blob_ptr
#       # pointer is blob_ptr, struct needs to_ptr call
#       self.respond_to?(:to_ptr) ? self.to_ptr : self
#     end
#     def make_blob(count=1)
#       blob = FFI::MemoryPointer.new(self.class, count)
#     end
#     def was_copy_blob(from, count)
#       from_ptr = from.blob_ptr
#       blob = FFI::MemoryPointer.new(self.class, count)
#       blob.put_bytes(0, from_ptr.get_bytes(0, blob.size)) 
# #       self.class.new(blob)
#     end

#     def unit_count() @_unit_count || 1 end #or 0??? what about null ptr???
    ### NOPE can't make this work
#     def unit_count()
#       ptr = (self.is_a?(FFI::Pointer) ? self : self.to_ptr)
#       # check nil ptr
#       if ptr.type_size == 0
#         raise "UnitMemory#unit_count: no type_size for #{self.inspect} ptr" 
#       end
#       # if remainder??? round? raise?
#       ptr.size / ptr.type_size
#     end
    
    
    # SHD be poss to alloc and copy whole chunk of C mem at once (then alloc and copy
    # further for deep members) but this isn't it. Hmm.
#     def make_copy_blob(count)
#       raise "make_copy_blob: count must be > 0 (#{count})." unless count && count > 0
#       # we'd LIKE to check count >= self unit_count but how???
# 
#       puts "make_copy_blob count: #{count}."
# #       puts "  unit_count: #{unit_count}."
#       puts "  self: #{self.inspect}"
# #       from_ptr = self.blob_ptr
#       from_ptr = self.to_ptr
# #       puts "  self.to_ptr: #{from_ptr}"
# #       puts "  from_ptr.size: #{from_ptr.size}" # count * QueryCapture.size
# #       puts "  from_ptr.type_size: #{from_ptr.type_size}" # QueryCapture.size
#       
#       blob = FFI::MemoryPointer.new(self, count)
#       blob.put_bytes(0, from_ptr.get_bytes(0, blob.size)) 
#       self.class.new(blob).tap do |o|
#         o.each_unit(count){|e, i| e.deep_blob(self[i])}
#       end
#     end
#     # copy_values when blob_copying for members that need further alloc
#     def deep_blob(from)
#       # override as nec!!!
#     end
#     # override in match...
#     def deep_blob(from)
#     	return unless from[:capture_count] > 0
#       fresh = from[:captures].make_copy_blob(from[:capture_count])
#       self[:captures] = fresh
#     end
    
		
		def copy_multiple(from, count)
		  self.each_unit(count){|e, i| e.copy_values(from[i])}
		  self
		end
		
	  def copy_values(from) 
		  raise "UnitMemory#copy_values must be overridden."
	  end
		def each_unit(count, &b)
		  count.times{|i| yield(self[i], i)}
	  end
	  
# 		alias_method :ffi_member, :[]
# 		alias_method :ffi_member=, :[]=
		def [](k)
		  return super(k) unless k.is_a?(Integer)
		  raise "BossStructArray#[]: k (#{k}) negative index" unless k > -1
		  self.class.new(self.to_ptr + k * self.class.size)
		end
		def []=(k, v)
		  return super(k, v) unless k.is_a?(Integer)
		  raise "#{self.class}#[]=: k (#{k}) negative index" unless k > -1
      unless v && v.is_a?(self.class)
        raise "#{self.class}#[]=: value must be class #{self.class} (#{v.inspect})"
      end
      self.class.new(self.to_ptr + k * self.class.size).tap do |o|
        o.copy_values(v)
      end
      # ret new or self???
      self
		end
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
			count.times.map{|i| self.class.new.copy_values(self[i])}
		end
		
		### module methods???
		# => Array of copies
# 		def from_contiguous(contig)
# 		end

    # takes array of 1 or more struct(_array), each of which is multiple 1 or more
    # doesn't check any overlapping???!!! what does this even mean???
		# => multi self
		def to_contiguous(arr)
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
		
		# blind blob copy???
		def womp(from, count)
		end
	end
end