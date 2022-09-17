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
	def repeat(v) self * v end
end

def four11(o, props, more={})
  return 'nil obj' unless o && (o.respond_to?('null?') ? !o.null? : true)
#   gather = props.zip(props.map{|e| (o.respond_to?(e) ? o.send(e) : o[e]).inspect})

  gather = props.map{|e| "#{e}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"}
#   gather = props.map do |e| 
#     if e.respond_to?(:each_unit)
#       ### TMP!!!
#       "#{e}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"
#     else
#       "#{e}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"
#     end
#   end

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
#   put_note(false, true, caller.first.split(':')[1], 
#     "assert_query_matches disabled, just continue")
# 	false
#   result = collect_matches(query, source, matches) # resig for rusty
  result = collect_matches(matches, query, source)
  put_note(result, expected, caller.first.split(':')[1]){|result, expect| result == expect}
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
# def collect_matches(query, source, matches) # resig for rusty
def collect_matches(matches, query, source)
  matches.map do |e|
    [e[:pattern_index],
     e.captures.map{|cap| compose_capture(query, source, cap)}]
  end
end
# TMP!!! 
# was format_captures
def compose_capture(query, source, capture)
  [query.capture_name_for_id(capture[:index]),
    capture[:node].utf8_text(source)]
end

# ref:
# def parse_json_example()
#     parser = TreeSitterFFI.parser()
#     parser.set_language(get_language("json"))
#     parser.parse(JSON_EXAMPLE, nil)
# end

#         assert_eq!(
#             collect_captures(captures, query, source),
#             [
#                 ["function", "DEFUN"],
#                 ["string.arg", "\"safe-length\""],
#                 ["string", "\"safe-length\""],
#             ]
#         )
# captures is Array???
def collect_captures(captures, query, source)
  captures.map{|capture| compose_capture(query, source, capture)}
end

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
	# An error that occurred when trying to create a `Query`.
	#[derive(Debug, PartialEq, Eq)]
	class QueryError # QueryError
		attr_accessor :row, :column, :offset, :message, :kind

		def inspect() four11(self, [:row, :column, :offset, :message, :kind]) end

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

module TreeSitterFFI
	QueryErrorKind = EnumQueryError
# 	Object.send :remove_const, "QueryError"
# 	Object.send :remove_const, "TreeSitterFFI::QueryError"
	TreeSitterFFI.send :remove_const, "EnumQueryError"

	include Rusty # extend???
end	
