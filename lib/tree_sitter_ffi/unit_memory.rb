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
		def make_copy(count=1)
			self.class.new(FFI::MemoryPointer.new(self.class, 
			  count * self.class.size)).tap do |o|
			  o.copy_multiple(self, count)
			end
		end
		
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