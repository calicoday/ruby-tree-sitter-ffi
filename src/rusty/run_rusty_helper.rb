# some stuff we need

require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

### gather all these run rusty util top-level methods into a module!!!

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

# helpful for failures
def put_more(o)
	case o
	when TreeSitterFFI::Point
		"#<Point row: #{o[:row]}, column: #{o[:column]}>"
	else
		o.inspect
	end
end

def init_tally
  $assert_count = 0
  $assert_fails = []
end
def report_tally
  puts "==="
  puts "total asserts: #{$assert_count}"
  puts "  ok: #{$assert_count - $assert_fails.length}"
  puts "  failed: #{$assert_fails.length}"
  puts "  #{$assert_fails.inspect}" if $assert_fails.length > 0
  puts
end

# def put_note(result, expect, from, &b)
def put_note(result, expect, from, msg=nil, &b)
  return puts "#{from}: #{msg}" if msg # handy during dev
	success = yield(result, expect)
	$assert_count += 1
	$assert_fails << from unless success
	msg = (success ? 'ok' : 'failed')
	return puts "#{from}: #{msg}" if success #yield(result, expect)
	puts "#{from}: #{msg}"
	puts "  result: #{put_more(result)}"
	puts "  expect: #{put_more(expect)}"
end

def assert_eq!(result, expect)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, expect, from){|result, expect| result == expect}
end

def assert_ne!(result, expect)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, expect, from){|result, expect| result != expect}
end

def assert!(result)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, true, from){|result, expect| result == true}
end

def assert_array_eq!(result, expect)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, expect, from) do |result, expect| 
		got = result.zip(expect).map{|pair| pair[0] == pair[1]}
		!got.include?(false)
	end
end

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


# in tree_sitter_ffi but not TreeSitterFFI namespace!!!
include BindRust

require 'awesome_print'

### general Rustiness, ie language Rustisms or cli/test utils ### separate these!!!

### redefine enum constants so we can reuse the names for rust bindings util objs

	# QueryErrorKind is macrod to TreeSitterFFI::EnumQueryError, which is FFI::Enum
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
  def trim() strip end
  def trim_start() lstrip end
  def trim_end() rstrip end
  def len() length end
end

def Err(v) v end
  
### unused
# QueryErrorKind = TreeSitterFFI::EnumQueryError ### in tmp_query_util
=begin
class StuntQueryError
	attr_accessor :row, :column, :offset, :message, :kind
	def initialize(h)
		h.each do |k,v|
			self.send(k, v)
		end
	end
end
def mk_query_error(h)	h end
=end

### mv to lib/ types_raw.rb
=begin
class TreeSitterFFI::InputEdit
	def self.from_hash(h)
# 		puts "TreeSitterFFI::InputEdit.from_hash..."
# 		ap h
		self.new.tap do |o|
      o[:start_byte] = h[:start_byte]
      o[:old_end_byte] = h[:old_end_byte]
      o[:new_end_byte] = h[:new_end_byte]
      o[:start_point] = h[:start_position] # tree_test says start_position but shdv chgd
      o[:old_end_point] = h[:old_end_position]
      o[:new_end_point] = h[:new_end_position]
#       o[:start_point] = h[:start_point] # tree_test says start_position but shdv chgd
#       o[:old_end_point] = h[:old_end_point]
#       o[:new_end_point] = h[:new_end_point]
		end
	end
end
=end

# from tree-sitter/cli/src/parse.rs, 351
def position_for_offset(input, offset)
	result = TreeSitterFFI::Point.new
	# input is String
	(0..offset).times do |i|
		if input[i] == "\n" 
			result[:row] += 1
			result[:column] = 0
		else
			result[:column] += 1
		end
	end
	result
end
# fn position_for_offset(input: &Vec<u8>, offset: usize) -> Point {
#     let mut result = Point { row: 0, column: 0 };
#     for c in &input[0..offset] {
#         if *c as char == '\n' {
#             result.row += 1;
#             result.column = 0;
#         } else {
#             result.column += 1;
#         }
#     }
#     result
# }

# general rusty:
# let mut vec = vec![1, 5];
# let slice = &[2, 3, 4];
# 
# vec.splice(1..1, slice.iter().cloned());
# 
# println!("{:?}", vec); // [1, 2, 3, 4, 5]

# from tree-sitter/cli/src/parse.rs, 11
# stunt obj
class Edit
	attr_accessor :position, :deleted_length, :inserted_text
	def initialize(pos, len, text)
		@position = pos
		@deleted_length = len
		@inserted_text = text
	end
end
# pub struct Edit {
#     pub position: usize,
#     pub deleted_length: usize,
#     pub inserted_text: Vec<u8>,
# }

# from tree-sitter/cli/src/parse.rs, 276
def perform_edit(tree, input, edit)
    start_byte = edit.position
    old_end_byte = edit.position + edit.deleted_length
    new_end_byte = edit.position + edit.inserted_text.len()
    # input is String
    start_position = position_for_offset(input, start_byte)
    old_end_position = position_for_offset(input, old_end_byte)
    input.slice!(start_byte...old_end_byte) # cuts the unwanted substring
    input.insert(start_byte, edit.inserted_text) # where is inserted_text???
		new_end_position = position_for_offset(input, new_end_byte)

# 		edit = InputEdit.new.tap do |o|
#       o[:start_byte] = start_byte
#       o[:old_end_byte] = old_end_byte
#       o[:new_end_byte] = new_end_byte
#       o[:start_position] = start_position
#       o[:old_end_position] = old_end_position
#       o[:new_end_position] = new_end_position
# 		end
		
end
# pub fn perform_edit(tree: &mut Tree, input: &mut Vec<u8>, edit: &Edit) -> InputEdit {
#     let start_byte = edit.position;
#     let old_end_byte = edit.position + edit.deleted_length;
#     let new_end_byte = edit.position + edit.inserted_text.len();
#     let start_position = position_for_offset(input, start_byte);
#     let old_end_position = position_for_offset(input, old_end_byte);
#     input.splice(start_byte..old_end_byte, edit.inserted_text.iter().cloned());
#     let new_end_position = position_for_offset(input, new_end_byte);
#     let edit = InputEdit {
#         start_byte,
#         old_end_byte,
#         new_end_byte,
#         start_position,
#         old_end_position,
#         new_end_position,
#     };
#     tree.edit(&edit);
#     edit
# }

### get these into TreeSitterFFI idio utils!!! FIXME!!!

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

JSON_EXAMPLE = <<-INDENTED_HEREDOC


[
  123,
  false,
  {
    "x": null
  }
]
	INDENTED_HEREDOC

# JSON_EXAMPLE = "
# 
# [
#   123,
#   false,
#   {
#     \"x\": null
#   }
# ]
# "

def pre_node_test()
#     tree = parse_json_example()
#     array_node = tree.root_node().child(0)
	a = TreeSitterFFI::Node.new
	b = TreeSitterFFI::Node.new
	puts "nodes a == b: #{TreeSitterFFI.ts_node_eq(a, b)}"
end

### merge Rustism, RustyTest stuff!!! FIXME!!!

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
