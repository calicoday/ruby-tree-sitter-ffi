### from demo runner.rb -- meant for iterators!!!
	def compose_node(n, depth, input, offset, &b)
		return ['', offset] unless n.child_count == 0
		# text chunk from the input
		text = input[n.start_byte...n.end_byte]
		# whitespace chunk from the input since the previous text chunk or start
		ws = input[offset...n.start_byte]
		output = ws + text
		# yield for preferred output string, if block_given?
		output = yield(n, depth, ws, text) || text if block_given?
		[output, n.end_byte]
	end

class QueryErrorResult
	attr_reader :type, :offset
	
	def initialize(type, offset)
		@type = type
		@offset = offset
	end
	
	def to_s() "#{self.class.name} type: #{type.inspect}, offset: #{offset}" end
end

#   def self.is_monday(day)
#     # Compare to both enum value and enum symbol
#     return true if (day == Day[:monday] or day == :monday)
#   end

### redefine enum constants so we can reuse the names for rust bindings util objs

	# QueryErrorKind is macrod to QueryError, which is FFI::Enum
	# reopen and add util methods
# 	QueryError = enum(:none, 0, :syntax, :node_type, :field, :capture, :structure)
### try this TMP!!!
# 	class QueryErrorKind 
	class FFI::Enum 
		def None() :none end
		def Syntax() :syntax end
		def NodeType() :node_type end
		def Field() :field end
		def Capture() :capture end
		def Structure() :structure end
		### rs bindings added:
		def Predicate() :predicate end ### we don't have :predicate yet!!!
	end

class String
	def to_string() self end
	def as_bytes() self end
end

def four11(o, props, more={})
#   gather = props.zip(props.map{|e| (o.respond_to?(e) ? o.send(e) : o[e]).inspect})
  gather = props.map{|e| "#{e}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"}
  gather += more.map{|k,v| "#{k}: #{v}"}
  "<#{o.class.name.split(':').last} " + 
    gather.join(', ') + ">"
#   "<#{o.class.name.split(':').last} " + 
#     props.map{|e| "#{e}: #{o.respond_to?(e) ? o.send(e) : o[e]}"}.join(', ') + ">"
end
def was_four11(o, props)
  "<#{o.class.name.split(':').last} " + 
    props.map{|e| "#{e}: #{o.respond_to?(e) ? o.send(e) : o[e]}"}.join(', ') + ">"
end

module TreeSitterFFI
  module BossStructArray
    ### gets added to FFI::Struct, poss FFI::ManagedStruct (unused so far!!!)
    ### fix init stuff
  
		def initialize(*args)
		  # FFI::Struct expects 0 or 1 pointer 
		  # .: 1 arg not a pointer wd be error
		  # 2 args we can assume are pointer and len!!!
		  # do we want to be able to pass only pointer when multiple 1, ie opt len=nil???
			len = args.pop if args.length == 2
			super(*args)
		end
# 		def initialize(len=nil)
# # 		  puts "overridden BossStructArray#init"
# 		  super()
# # 		  @struct_multiple = len
# 		end
		def self.array_of_struct(klass, &b)
			raise "array_of_struct: #{klass} not TreeSitterFFI::BossStructArray." unless 
				klass.method_defined?(:struct_multiple)
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
			ret = yield(len_p)
			len = len_p.get(:uint32, 0)
			klass.new(ret).tap do |o|
			  o.struct_multiple = len
			end.to_array
		end
		def self.from_contiguous(klass, &b)
			raise "from_contiguous: #{klass} not TreeSitterFFI::BossStructArray." unless 
				klass.method_defined?(:struct_multiple)
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
			ret = yield(len_p)
			len = len_p.get(:uint32, 0)
			klass.new(ret).tap do |o|
			  o.struct_multiple = len
			end
		end

# 		def self.from_contiguous()
# 		end
		def to_array() #same
			len = struct_multiple
			len.times.map{|i| self.class.new(self.pointer + i * self.class.size)}
		end
		
		# require props set or from_array???
# 		def from_array(arr, &b=nil)
# 		  raise "BossStructArray#from_array(arr, &b=nil) must be overridden."
# 		end
		def copy_values(from)
		  raise "BossStructArray#copy_values(from) must be overridden."
		end
# 		def self.copy_values(to, from)
# 		  raise "BossStructArray.copy_values(to, from) must be overridden."
# 		end
		### wrong in gem, qual FFI::MemoryPointer!!!
		def self.to_contiguous(arr, &b)
			# what if arr is nil??? pass NotARange???
			raise "to_contiguous nil arr." unless arr
			# all arr members are expected to be the same class!!! vet!!!
			klass = arr[0].class
			# might all be pointers into the same mem chunk but copy for now!!! opt???
			contig = FFI::MemoryPointer.new(klass, arr.length * klass.size).tap do |o|
				arr.each_with_index do |e, i| 
					raise "to_contiguous mismatched class (#{e.class}, expected #{klass}" unless
						e.class == klass # which equals??? eq? ??? FIXME!!!
					yield(e, klass.new(o + (i * klass.size))) if block_given?
				end
			end
			klass.new(contig).tap do |o|
				o.struct_multiple = arr.length if arr.length > 0
			end
		end
  end
end

def Err(v) v end

# array to c function:
# arr = [Range, Range, Range]
# multi = copy_contig(arr)
# => <Range> # struct_multiple = 3
# func(multi)

# array_of_struct from c function:
# arr_stru = func(&count) # => count = 3
# Range.from_array(arr_stru)
# => [Range, Range, Range]


# fn assert_query_matches(
#     language: Language,
#     query: &Query,
#     source: &str,
#     expected: &[(usize, Vec<(&str, &str)>)],
# ) {
#     let mut parser = Parser::new();
#     parser.set_language(language).unwrap();
#     let tree = parser.parse(source, None).unwrap();
#     let mut cursor = QueryCursor::new();
#     let matches = cursor.matches(&query, tree.root_node(), source.as_bytes());
#     assert_eq!(collect_matches(matches, &query, source), expected);
#     assert_eq!(cursor.did_exceed_match_limit(), false);
# }
# mv to run_rusty_helper.rb???
# def assert_query_matches(h)
def assert_query_matches(language, query, source, expected)
	# TMP!!! just fail now and comeback
  parser = TreeSitterFFI.parser
  parser.set_language(language)
  tree = parser.parse(source, nil)
  cursor = TreeSitterFFI::QueryCursor.make
#   cursor = TreeSitterFFI::QueryCursor.new
  matches = cursor.matches(query, tree.root_node, source.as_bytes)
  # as_bytes???
  put_note(false, true, caller.first.split(':')[1], 
    "assert_query_matches disabled, just continue")
	false
end

# fn collect_matches<'a>(
#     matches: impl Iterator<Item = QueryMatch<'a, 'a>>,
#     query: &'a Query,
#     source: &'a str,
# ) -> Vec<(usize, Vec<(&'a str, &'a str)>)> {
#     matches
#         .map(|m| {
#             (
#                 m.pattern_index,
#                 format_captures(m.captures.iter().cloned(), query, source),
#             )
#         })
#         .collect()
# }

# => Array[Captures]*
def collect_matches(query, source, matches)
  matches.map do |e|
    e.captures.map{|cap| compose_capture(query, source, cap)}
  end
end
# was format_captures
def compose_capture(query, source, capture)
  puts "=== capture: #{capture.inspect}"
  [query.capture_name_for_id(capture[:index]),
    capture[:node].utf8_text(source)]
end

# ref:
# def parse_json_example()
#     parser = TreeSitterFFI.parser()
#     parser.set_language(get_language("json"))
#     parser.parse(JSON_EXAMPLE, nil)
# end


# fn collect_matches<'a>(
#     matches: impl Iterator<Item = QueryMatch<'a, 'a>>,
#     query: &'a Query,
#     source: &'a str,
# ) -> Vec<(usize, Vec<(&'a str, &'a str)>)> {
#     matches
#         .map(|m| {
#             (
#                 m.pattern_index,
#                 format_captures(m.captures.iter().cloned(), query, source),
#             )
#         })
#         .collect()
# }
# 
# fn collect_captures<'a>(
#     captures: impl Iterator<Item = (QueryMatch<'a, 'a>, usize)>,
#     query: &'a Query,
#     source: &'a str,
# ) -> Vec<(&'a str, &'a str)> {
#     format_captures(captures.map(|(m, i)| m.captures[i]), query, source)
# }
# 
# fn format_captures<'a>(
#     captures: impl Iterator<Item = QueryCapture<'a>>,
#     query: &'a Query,
#     source: &'a str,
# ) -> Vec<(&'a str, &'a str)> {
#     captures
#         .map(|capture| {
#             (
#                 query.capture_names()[capture.index as usize].as_str(),
#                 capture.node.utf8_text(source.as_bytes()).unwrap(),
#             )
#         })
#         .collect()
# }


module Rusty
	# QueryErrorKind is macrod to QueryError, which is FFI::Enum
	# reopen and add util methods
# 	QueryError = enum(:none, 0, :syntax, :node_type, :field, :capture, :structure)
# 	class QueryErrorKind 
# 		def self.None() :none end
# 		def self.Syntax() :syntax end
# 		def self.NodeType() :node_type end
# 		def self.Field() :field end
# 		def self.Capture() :capture end
# 		def self.Structure() :structure end
# 	end

	# An error that occurred when trying to create a `Query`.
	#[derive(Debug, PartialEq, Eq)]
	class QueryError # QueryError
		attr_accessor :row, :column, :offset, :message, :kind

    def self.source_line_row_col(source, offset)       
#       puts "^^^ source: #{source.inspect}, offset: #{offset.inspect}"  
      source.split("\n").each_with_index.inject(0) do |start, e|
        line, row = e
#         puts "  start: #{start.inspect}, line: #{line.inspect}, row: #{row.inspect}"
        return [line, row, offset - start] if start + line.length + 1 > offset
        start + line.length + 1
      end
    end

    def self.position_message(line, column)
      return "Unexpected EOF" unless line
      "#{line}\n" + ' ' * column + '^'
    end
    def self.name_message(source, offset)
      suffix = source[offset..-1]
      end_offset = suffix.index(/[^\w-]/) || source.length
      suffix[0...end_offset]
    end

    def self.make(sexp, error_offset, error_type)
      type = TreeSitterFFI::Query.type_enum(error_type)
#       puts "%%% sexp: #{sexp.inspect}"
#       puts "  err_offset: #{error_offset.inspect}"
#       puts "  err_type: #{error_type.inspect}"
#       puts "  type: #{type.inspect}"
      line, row, column = source_line_row_col(sexp, error_offset)
#       puts "%%% line: #{line.inspect}, row: #{row.inspect}, col: #{column.inspect}"
      message = case type
      when :node_type, :field, :capture
        name_message(sexp, error_offset)
      else
        position_message(line, column)
      end
      self.new(row, column, error_offset, message, type)
    end
    
		def initialize(*args)
			if args[0] && args[0].is_a?(Hash)
				args[0].each{|k,v| self.send("#{k.to_s}=", v)}
			else
				@row, @column, @offset, @message, @kind = args
			end
		end
		
		def ==(v)
			return false unless v && v.is_a?(self.class)
			[:row, :column, :offset, :message, :kind].each do |e|
				return false unless self.send(e) == v.send(e)
			end
			true
		end
	end
end

### try this topside TMP!!!
	# will be EnumQueryError
# 	QueryErrorKind = TreeSitterFFI::QueryError
# 
# 	# An error that occurred when trying to create a `Query`.
# 	#[derive(Debug, PartialEq, Eq)]
# 	class QueryError # QueryError
# 		attr_accessor :row, :column, :offset, :message, :kind
# 		def initialize(*args)
# 			@row, @column, @offset, @message, @kind = args
# 			#row: usize,
# 			#column: usize,
# 			#offset: usize,
# 			#message: String,
# 			#kind: QueryErrorKind,
# 		end
# 	end

# 	class BossStruct < FFI::Struct
# 		extend Wrap
# 		include TreeSitterFFI
# 
#     # bc StructPack/Array will want []
#     # also dyn add accessors!!!
# 		alias_method :member, :[]
# 		alias_method :member=, :[]=
# 	end
# 	
# 	class BossManagedStruct < FFI::ManagedStruct
# 		extend Wrap
# 		include TreeSitterFFI
# 
#     # bc consistent with BossStruct (can ManagedStruct be multiple???)
#     # also dyn add accessors!!!
# 		alias_method :member, :[]
# 		alias_method :member=, :[]=
# 	end

### add conv here first!!!
module TreeSitterFFI

  class Point
    ### note init in gem is currently chkg '== 2'!!!
# 		def initialize(*args)
# 			if args.length == 2
# 				# popping from the end, so reverse order!!!
# 				column = args.pop
# 				row = args.pop
# 			end
# 			super(*args)
# 			if row && column
# 				self[:row] = row
# 				self[:column] = column
# 			end
# 		end
    def props()
      [self[:column], self[:row]]
    end
    def props=(colrow)
      self[:row] = colrow[1]
      self[:column] = colrow[0]
      self # for chaining
    end
  end
  class Range
    def props()
      [self[:start_point].props, self[:end_point].props, 
        [self[:start_byte], self[:end_byte]]]
    end
#     def props=(start_colrow, end_colrow, run)
    def props=(arr_or_h)
      # just arr for now (Array, Array, Array (Range?))
      start_colrow, end_colrow, run = arr_or_h
      self[:start_point].props = start_colrow
      self[:end_point].props = end_colrow
      self[:start_byte] = run[0]
      self[:end_byte] = run[1]
      self # for chaining
    end
    
    ### override init!!!
    def self.make(arr)
      # vet arr shape!!!
      self.new.tap do |o|
        o.props = (arr)
      end
    end
    
		def copy_values(from)
# 		  raise "BossStructArray#copy_values(to) must be overridden."
      # from, to must be this class!!!
      unless from && from.is_a?(self.class)
        raise "#{self.class}#copy_value: to must be class #{self.class} (#{from.inspect})"
      end
      self.props = from.props
		end

		### from_array, to_contiguous are module method!!!
		def self.from_array(arr)
			BossStructArray.to_contiguous(arr) do |e, fresh|
			  fresh.copy_values(to)
			end
		end

  end


	QueryErrorKind = EnumQueryError
# 	Object.send :remove_const, "QueryError"
# 	Object.send :remove_const, "TreeSitterFFI::QueryError"
	TreeSitterFFI.send :remove_const, "EnumQueryError"

	include Rusty # extend???
	
	class Query
		# add this to FFI::Enum or EnumUtils???
# 		def toggle_rep(what, v)
# 			(raise "toggle_rep: expected FFI::Enum (#{what.inspect})" 
# 				unless what.is_a?(FFI::Enum) )
# 			return what.send(:from_native, v) unless v.is_a?(Symbol)
# # 			what.send(:to_native, v) ||
# # 				raise "toggle_rep: unknown #{what} symbol #{v.inspect}"
# 			got = what.send(:to_native, v)
# 			raise "toggle_rep: unknown #{what} symbol #{v.inspect}" unless got
# 			got
# # 			v.is_a?(Symbol) ? what.send(:to_native, v) : what.send(:from_native, v)
# 		end
		def self.type_enum(v)
# 			v.is_a?(Symbol) ? QueryError[v] : 
			if v.is_a?(Symbol)
				got = QueryErrorKind.to_native(v, nil) # wants ctx it doesn't use!!!
# 				got = QueryError.to_native(v) 
				raise "type_enum: unknown #{v.inspect}" unless got
				got
				# how to something like this:
# 				QueryError.to_native(v) || raise "type_enum: unknown #{v.inspect}"
			else
				QueryErrorKind.from_native(v, nil) # wants ctx it doesn't use!!!
# 				QueryError.from_native(v)
			end
		end
		
		### come back when we figure out how to override initialize!!!
		# returns a Query or a QueryErrorResult
		def self.make(lang, sexp)
# 			lang = TreeSitterFFI.parser_json
			err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
			err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
# 			sexp = '(document (array (number) (null)))'
# 			puts "=== Query.make sexp: #{sexp.inspect}"
			query = TreeSitterFFI.ts_query_new(lang, sexp, sexp.length, 
				err_offset_p, err_type_p)
			offset = err_offset_p.get(:uint32, 0)
			type = err_type_p.get(:uint32, 0)
# 			puts "  query: #{query.inspect}"
# 			puts "  query.null?: #{query.null?}"
# 			puts "  offset: #{offset.inspect}"
# 			puts "  type: #{type.inspect}"
# 			puts "  type sym: #{type_enum(type).inspect}"
			# is it possible FFI will return nil??? or only null pointer???
			query.null? ? TreeSitterFFI::QueryError.make(sexp, offset, type) :
				query
# 			query.null? ? TreeSitterFFI::QueryError.new(0, 0, offset, 
# 				"rusty query err", type_enum(type)) :
# 				query
		end	

    ### TMP!!! by hand
		# currently not implemented
		### reattach ts_ form
    c_name, args, returns =  
      [:ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string]
    puts "c_name: #{c_name.inspect}, args: #{args.inspect}, returns: #{returns.inspect}"
    TreeSitterFFI.attach_function(c_name, args, returns)
    
# 		def ts_query_capture_name_for_id(*args) nope_not_impl(__callee__) end
# 		def capture_name_for_id(*args) #:uint32, :uint32_p => :string
		def capture_name_for_id(id) #:uint32 [, add len_p] => :string
# 		  nope_not_impl(__callee__) 
			len_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# 			ret = yield(len_p)
      ret = ts_query_capture_name_for_id(self, id, len_p)
			len = len_p.get(:uint32, 0)
      puts "Query#capture_name_for_id(#{id}) ret: #{ret.inspect}, len: #{len}"
      ret
		end

# 		def ts_query_string_value_for_id(*args) nope_not_impl(__callee__) end
		def string_value_for_id(*args) 
# 		  nope_not_impl(__callee__) 
		end

	end
	
	class Node
	  # can't override this here!!! fix gem!!!
# 		layout(
# 			:context, [:uint32, 4],
# 			:id, :pointer,
# 			:tree, Tree
# 		)

    ### rusty bindings TMP!!! 
    def utf8_text(input)
      input[self[:start_byte]...self[:end_byte]]
    end

	  def copy_values(from)
# 	    from.context.each_with_index{|e, i| self[:context][i] = e}
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
	
	class QueryCapture
	  include BossStructArray
    def props()
      [self[:node].props, self[:index]]
    end
#     def props=(start_colrow, end_colrow, run)
    def props=(arr_or_h)
      # just arr for now [Node.by_value, :uint32]
      # Node.by_value is [context[:uint32, :uint32, :uint32, :uint32], id_p, tree_p]
      node, index = arr_or_h
      self[:node].props = node #node.dup???
#       self[:index].props = index ###???!!!
      self[:index] = index
      self # for chaining
    end
    
    def copy_values(from)
      self[:node].copy_values(from[:node])
      self[:index] = from[:index]
    end
#     def copy_values(to)
#       # vet to && to.is_a?(self.class)
#       self[:node].copy_values(to[:node])
#       to[:index] = self[:index]
#     end
		def self.from_array(arr)
			BossStructArray.to_contiguous(arr) do |e, fresh|
			  fresh.props = e.props
			end
		end

	  ### by hand for now!!!
	  def inspect()
	    node = (self[:node] && !self[:node].is_null ?
	      self[:node].string : self[:node].inspect)
      "<#{self.class.name.split(':').last}" + 
        " node: #{node}>"
#       "<#{self.class.name.split(':').last}" + 
#         " node: #{self[:node].inspect}>"
#         " node: #{self[:node].inspect} (null?: #{self[:node].is_null})>" # segfault!!!
#         " node: #{self[:node].inspect} (#{self[:node].string})>" ### nope, segfault!!!
#         props.map{|e| " #{e}: #{o.respond_to?(e) ? o.send(e) : o[e]}"}.join + ">"
	  end
		#def inspect() four11(self, [:node, :index]) end
#     def [](idx)
#       puts "=== QueryCapture/BossStructArray[#{idx.inspect}]"
#       super(idx)
#       puts "==="
#     end
	end
	class QueryMatch
# 	  include BossStructArray
    # ref parser#included_ranges
# 			BossStructArray.array_of_struct(TreeSitterFFI::Range) do |len_p|
# 				ts_parser_included_ranges(self, len_p)
# 			end
    # now
        # block happens once, handed len pointer, return lib-alloc'd chunk, read len
# 			BossStructArray.from_contiguous(TreeSitterFFI::Range) do |len_p|
          # block happens once, set len value, return struct_array mem chunk
# 				ts_parser_included_ranges(self, len_p)
# 			end
    
    def captures()
#       puts "QueryMatch#captures"
      # wrap our own capture struct_array, no need to call lib for new
			BossStructArray.from_contiguous(TreeSitterFFI::QueryCapture) do |len_p|
        # block happens once, set len value, return struct_array mem chunk
			  len_p.put(:uint32, 0, self[:capture_count])
				self[:captures]
			end.to_array
    end
  
    # wrong in gem!!! FIXME!!!
		def was_captures()
# 		  return "plingo"
			BossStructArray.array_of_struct(TreeSitterFFI::QueryCapture) do |len_p|
			  len_p.put(:uint32, 0, self[:capture_count])
			  self[:captures]
# 				ts_parser_included_ranges(self, len_p)
			end
		end
# 		def inspect() four11(self, [:id, :pattern_index, :capture_count, :grabs]) end
		def inspect() four11(self, [:id, :pattern_index, :capture_count, :captures]) end
	end

	class QueryCursor
	  # override init???
	  def self.make()
      TreeSitterFFI.ts_query_cursor_new
	    # can this fail???!!!
# 	    o = TreeSitterFFI.ts_query_cursor_new
# 	    puts "QueryCursor.make o: #{o.inspect}"
# 	    self.new(o)
# 	    self.new(TreeSitterFFI.ts_query_cursor_new)
	  end

# /// A sequence of `QueryMatch`es associated with a given `QueryCursor`.
# pub struct QueryMatches<'a, 'tree: 'a, T: TextProvider<'a>> {
#     ptr: *mut ffi::TSQueryCursor,
#     query: &'a Query,
#     text_provider: T,
#     buffer1: Vec<u8>,
#     buffer2: Vec<u8>,
#     _tree: PhantomData<&'tree ()>,
# }

		# TextProvider??? try String input first...
		def matches(query, node, input)
		  arr = []
# 		  match = QueryMatch.new
		  self.exec(query, node)
		  while(next_match(match = QueryMatch.new))
		    arr << match
		  end
		  arr
		end
		### lib.rs QueryCursor
#     /// Iterate over all of the matches in the order that they were found.
#     ///
#     /// Each match contains the index of the pattern that matched, and a list of captures.
#     /// Because multiple patterns can match the same set of nodes, one match may contain
#     /// captures that appear *before* some of the captures from a previous match.
#     pub fn matches<'a, 'tree: 'a, T: TextProvider<'a> + 'a>(
#         &'a mut self,
#         query: &'a Query,
#         node: Node<'tree>,
#         text_provider: T,
#     ) -> QueryMatches<'a, 'tree, T> {
#         let ptr = self.ptr.as_ptr();
#         unsafe { ffi::ts_query_cursor_exec(ptr, query.ptr.as_ptr(), node.0) };
#         QueryMatches {
#             ptr,
#             query,
#             text_provider,
#             buffer1: Default::default(),
#             buffer2: Default::default(),
#             _tree: PhantomData,
#         }
#     }
# 
		
	end

end