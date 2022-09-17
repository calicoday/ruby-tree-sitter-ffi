# some stuff we need

require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

# require 'bind_rusty_helpers.rb'

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
# 	put_note(result, expect, caller.first.split('/').last){|result, expect| result == expect}
# 	put_note(result, expect, caller.first){|result, expect| result == expect}
# 	put_note(result, expect, caller.first.split(':')[1]){|result, expect| result == expect}
end

def assert_ne!(result, expect)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, expect, from){|result, expect| result != expect}
# 	put_note(result, expect, caller.first.split(':')[1]){|result, expect| result != expect}
end

def assert!(result)
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, true, from){|result, expect| result == true}
# 	put_note(result, true, caller.first.split(':')[1]){|result, expect| result == true}
end

def assert_array_eq!(result, expect)
# 	put_note(result, expect, caller.first.split(':')[1]) do |result, expect| 
  from = caller.first.split('/').last.split(/(\w+_test.rb:)/).last
	put_note(result, expect, from) do |result, expect| 
		got = result.zip(expect).map{|pair| pair[0] == pair[1]}
		!got.include?(false)
	end
end



# monkeypatching to make ruby calls match the rust bindings... mostly rubier anyway
# maybe make this a whole separate mod

module BindRusty
#   include BindRustyHelpers
# TMP!!!
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
	
	class TreeSitterFFI::QueryCursor
		def set_byte_range(range)
			raise "QueryCursor#set_byte_range expected Range (#{range.inspect})" unless 
				range.is_a?(::Range)
			first = range.begin
			last = range.max.to_i
			TreeSitterFFI.ts_query_cursor_set_byte_range(self, first, last)
			self
		end

    #### monkeypatching TreeSitterFFI classes while I restabilize the tests before
    # remaking the gem...

    # from wb/engine_rb.rb ParseRunner -- for ref!!!

      # will be QueryCursor#captures(match) => index or nil
    #   def cursor_captures()
      def cursor_captures(cursor)
        arr = []
        match = TreeSitterFFI::QueryMatch.new
        ###TMP!!! amend TreeSitterFFI!!!
    #     while(idx=cursor.next_capture(match))
        while(idx=next_capture(match, cursor))
          arr << match.captures[idx] #make_copy issue!!!
          # wait up, doesn't [] already create copy??? try it...
        end
        arr    
      end
      # ruby wrap for next_match, next_capture shd return obj/index or nil instead of bool!!!
    #   def next_match(match) #conv override
    #     ret = ts_query_cursor_next_match(self, match)
      def will_next_match(match, cursor) #conv override
        ret = ts_query_cursor_next_match(cursor, match)
        # ret is true or false, return match or nil
        ret ? match : nil
      end
    #   def next_capture() #conv override
    #     len_p = FFI::MemoryPointer.new(:uint32, 1)
    #     ret = ts_parser_included_ranges(self, len_p)
      def next_capture(match, cursor) #conv override
        len_p = FFI::MemoryPointer.new(:uint32, 1)
        ret = cursor.ts_query_cursor_next_capture(cursor, match, len_p) # weird monkey!!!
    #     ret = ts_query_cursor_next_capture(cursor, match, len_p)
        # ret is true or false, return index or nil
        len = len_p.get(:uint32, 0)
        ret ? len : nil
      end
    ####
		
		# QueryCursor already has #matches but it shdnt, shd be here in BindRusty
		# OR we shd backport some of the essential helpers to C!!!
    def captures(query, node, input)
		  self.exec(query, node)
		  arr = []
      match = QueryMatch.new
		  while(idx=next_capture(match, self)) # not cursor.next_capture bc return int!!! FIXME!!!
		    arr << match.captures[idx] #make_copy issue!!!
          # wait up, doesn't [] already create copy??? try it...
		  end
		  arr
    end
    # in gem:
# 		def matches(query, node, input)
# 		  self.exec(query, node)
# 		  arr = []
#       match = QueryMatch.new
# 		  while(next_match(match))
# 		    arr << match.make_copy #only single
# 		  end
# 		  arr
#     end
		
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
	  ### chimp now in gem
# 		def self.make(lang, str)
# 		  puts "=== Query.make run_rusty_helper.rb"
# 			offset_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# 			errtype_p = FFI::MemoryPointer.new(:pointer, 1) # TSQueryError is enum
# 			ret = TreeSitterFFI.ts_query_new(lang, str, str.length, offset_p, errtype_p)
# 			return ret unless ret.nil?
# 			# raise/return error stuff
# 			offset = offset_p.get(:uint32, 0)
# 			# start with this
# 			raise "TreeSitterFFI::Query.make failed, offset: #{offset}"
# # 			errtype = errtype_p.get(QueryError.ptr, 0)
# 		end
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


# general Rustiness
class String
  def trim() strip end
  def trim_start() lstrip end
  def trim_end() rstrip end
  def len() length end
end
  

QueryErrorKind = TreeSitterFFI::EnumQueryError
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
