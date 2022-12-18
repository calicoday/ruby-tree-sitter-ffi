module TreeSitterFFI
  class Point < BossFFI::BossStruct
#     layout(
#       :row, :uint32_t,
#       :column, :uint32_t,
#     )
		
		def initialize(*args)
			if args.length == 2
				# popping from the end, so reverse order!!!
				column = args.pop
				row = args.pop
			end
			super(*args)
			if row && column
				self[:row] = row
				self[:column] = column
			end
		end
		def ==(v)
			return false unless !v.nil? && self.class == v.class # subclasses???
			self[:row] == v[:row] && self[:column] == v[:column]
		end

### chimp???
    def props()
      [self[:column], self[:row]]
    end
    def props=(colrow)
      self[:row] = colrow[1]
      self[:column] = colrow[0]
      self # for chaining
    end
  end
end