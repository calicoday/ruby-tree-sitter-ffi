# some stuff we need

require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

# helpful for failures
def put_more(o)
	case o
	when TreeSitterFFI::Point
		"#<Point row: #{o[:row]}, column: #{o[:column]}>"
	else
		o.inspect
	end
end

def put_note(result, expect, from, &b)
	success = yield(result, expect)
	msg = (success ? 'ok' : 'failed')
	return puts "#{from}: #{msg}" if success #yield(result, expect)
	puts "#{from}: #{msg}"
	puts "  result: #{put_more(result)}"
	puts "  expect: #{put_more(expect)}"
end

def assert_eq!(result, expect, from=nil)
	put_note(result, expect, caller.first.split(':')[1]){|result, expect| result == expect}
end

def assert_ne!(result, expect)
	put_note(result, expect, caller.first.split(':')[1]){|result, expect| result != expect}
end

def assert!(result)
	put_note(result, true, caller.first.split(':')[1]){|result, expect| result == true}
end

def assert_array_eq!(result, expect)
	put_note(result, expect, caller.first.split(':')[1]) do |result, expect| 
		got = result.zip(expect).map{|pair| pair[0] == pair[1]}
		!got.include?(false)
	end
end

# monkeypatching to make ruby calls match the rust bindings... mostly rubier anyway
# maybe make this a whole separate mod

module BindRusty
	def get_language(lang)
		case lang
		when "json" then TreeSitterFFI.parser_json
		when "javascript" then TreeSitterFFI.parser_javascript
		when "python" then TreeSitterFFI.parser_python
		when "ruby" then TreeSitterFFI.parser_ruby
		when "c" then TreeSitterFFI.parser_c
		when "html" then TreeSitterFFI.parser_html
		when "java" then TreeSitterFFI.parser_java
		when "rust" then TreeSitterFFI.parser_rust
		else
			raise "don't know how to get_language(#{lang.inspect})."
		end
	end

	class TreeSitterFFI::Node
		def type_id() symbol() end
		def walk() TreeSitterFFI.ts_tree_cursor_new(self) end
	end

	class TreeSitterFFI::Tree
		def walk() TreeSitterFFI.ts_tree_cursor_new(self.root_node) end
	end

	class TreeSitterFFI::TreeCursor
		def node() TreeSitterFFI.ts_tree_cursor_current_node(self) end
		def field_name() TreeSitterFFI.ts_tree_cursor_current_field_name(self) end
	end
	
# /**
#  * Create a new query from a string containing one or more S-expression
#  * patterns. The query is associated with a particular language, and can
#  * only be run on syntax nodes parsed with that language.
#  *
#  * If all of the given patterns are valid, this returns a `TSQuery`.
#  * If a pattern is invalid, this returns `NULL`, and provides two pieces
#  * of information about the problem:
#  * 1. The byte offset of the error is written to the `error_offset` parameter.
#  * 2. The type of error is written to the `error_type` parameter.
#  */
# TSQuery *ts_query_new(
#   const TSLanguage *language,
#   const char *source,
#   uint32_t source_len,
#   uint32_t *error_offset,
#   TSQueryError *error_type
# );

	class TreeSitterFFI::Query
		def is_ok() true end
		def self.make(lang, str)
			offset_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
			errtype_p = FFI::MemoryPointer.new(:pointer, 1) # TSQueryError is enum
			ret = TreeSitterFFI.ts_query_new(lang, str, str.length, offset_p, errtype_p)
			return ret unless ret.nil?
			# raise/return error stuff
			offset = offset_p.get(:uint32, 0)
			# start with this
			raise "TreeSitterFFI::Query.make failed, offset: #{offset}"
# 			errtype = errtype_p.get(QueryError.ptr, 0)
		end
	end
# ###QueryError {
# 	class TreeSitterFFI::QueryError
# 		def self.make(h)
# 			
# 		end
# 	end

# /// An error that occurred when trying to create a `Query`.
# #[derive(Debug, PartialEq, Eq)]
# pub struct QueryError {
#     pub row: usize,
#     pub column: usize,
#     pub offset: usize,
#     pub message: String,
#     pub kind: QueryErrorKind,
# }
# 
# #[derive(Debug, PartialEq, Eq)]
# pub enum QueryErrorKind {
#     Syntax,
#     NodeType,
#     Field,
#     Capture,
#     Predicate,
#     Structure,
# }

end

include BindRusty

require 'awesome_print'

QueryErrorKind = TreeSitterFFI::QueryError
class StuntQueryError
	attr_accessor :row, :column, :offset, :message, :kind
	def initialize(h)
		h.each do |k,v|
			self.send(k, v)
		end
	end
end
def mk_query_error(h)	h end

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
