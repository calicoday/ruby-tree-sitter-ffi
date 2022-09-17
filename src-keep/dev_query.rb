# various rewrites of the input sample JSON_EXAMPLE by walking the tree (not TreeCursor)

require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

require './src/gen/query_util.rb'

require 'awesome_print'
require 'pastel'

$pa = Pastel.new
# class Object
#   def pa(v) inspect.pa(v) end
# end
# class String
#   def pa(v) $pa.send(v) end
# #   def pa(v) $pa.send(v); self end
# end

# in monkey_gem.rb:
# def four11(o, props, more={})
#   return 'nil obj' unless o && !o.null?
# #   gather = props.zip(props.map{|e| (o.respond_to?(e) ? o.send(e) : o[e]).inspect})
#   gather = props.map{|e| "#{e}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"}
#   gather += more.map{|k,v| "#{k}: #{v}"}
#   "<#{o.class.name.split(':').last} " + 
#     gather.join(', ') + ">"
# #   "<#{o.class.name.split(':').last} " + 
# #     props.map{|e| "#{e}: #{o.respond_to?(e) ? o.send(e) : o[e]}"}.join(', ') + ">"
# end
    
alias orig_four11 four11
def four11(o, props, more={})
  return $pa.on_magenta('<nil>') unless o && !o.null?
  gather = props.map{|e| "#{$pa.blue(e)}: #{(o.respond_to?(e) ? o.send(e) : o[e]).inspect}"}
  gather += more.map{|k,v| "#{$pa.bright_blue(k)}: #{v}"}
  "<#{$pa.red(o.class.name.split(':').last)} " + 
    gather.join(', ') + ">"
end  

# JSON_EXAMPLE = <<-INDENTED_HEREDOC
RUBY_EXAMPLE = <<-INDENTED_HEREDOC


[
  123,
  false,
  {
    x: nil
  },
  {
    4 => 'aha!!'
  },
  true
]
	INDENTED_HEREDOC

puts "+=+=+=+= #{`date`}"

parser = TreeSitterFFI.parser
lang = TreeSitterFFI.parser_ruby
parser.set_language(lang)
tree = parser.parse(RUBY_EXAMPLE)

puts "0. Demo input (note initial blank lines): "
puts RUBY_EXAMPLE
puts
# =>
# 
# 
# [
#   123,
#   false,
#   {
#     x: nil
#   },
#   {
#     4 => 'aha!!'
#   },
#   true
# ]

puts "1. Basic input as s-expression: "
puts tree.root_node.string
puts
# => 
# (program (array (integer) (false) (hash (pair key: (hash_key_symbol) value: (nil))) (hash (pair key: (integer) value: (string (string_content)))) (true)))

sexp = '(hash)'
query = TreeSitterFFI::Query.make(lang, sexp)

puts "2. Simple query: "
puts sexp, query
puts
# =>
# (hash)
# #<TreeSitterFFI::Query address=0x00007fa83f55d060>

cursor = TreeSitterFFI::QueryCursor.make
matches = cursor.matches(query, tree.root_node, RUBY_EXAMPLE)
puts

puts "3. Matches: "
puts cursor #, matches.inspect
# puts "  !!! matches.inspect: #{matches.inspect}"
matches.each_with_index do |e, i|
  puts "  #{i} #{e.inspect}"
end
puts
# =>
# #<TreeSitterFFI::QueryCursor address=0x00007fa83f7fad90>
#   0 <QueryMatch id: 0 pattern_index: 0 capture_count: 0 captures: []>
#   1 <QueryMatch id: 1 pattern_index: 0 capture_count: 0 captures: []>

sexp = '(hash) @yum'
query = TreeSitterFFI::Query.make(lang, sexp)

# pa = Pastel.new
puts "4. Query with named capture: "
# puts sexp.pa(:on_green), query.pa(:on_yellow)
# puts pa.on_green(sexp), pa.on_yellow(query)
puts sexp, query
puts
# =>
# (hash)
# #<TreeSitterFFI::Query address=0x00007fa83f55d060>

cursor = TreeSitterFFI::QueryCursor.make
matches = cursor.matches(query, tree.root_node, RUBY_EXAMPLE)
# puts "mrr: #{matches.inspect}"
puts

puts "5. Matches: "
puts "tree: #{tree.inspect}"
puts "root_node: #{tree.root_node.inspect}"
cand = tree.root_node.named_child(0).named_child(2)
puts "root.0.0.2: #{cand.inspect}, '#{cand.string}'"
puts
puts cursor #, matches.inspect
matches.each_with_index do |e, i|
#   names = e.captures.map{|cap| query.capture_name_for_id(cap[:index])}
  puts "  #{i} #{e.inspect}"
  e.captures.map{|cap| puts "      #{compose_capture(query, RUBY_EXAMPLE, cap).inspect}"}
  
#   caps = e.captures
#   puts "    caps: #{caps.inspect}"
#   caps.each_with_index{|cap, j| puts "      #{j} #{cap.inspect}"}
end
puts
# =>
# tree: #<TreeSitterFFI::Tree address=0x00007f8e4b0191e0>
# root_node: <Node context: [2, 2, 0, 0], id: #<FFI::Pointer address=0x00007f8e4b0191e0>, tree: #<FFI::Pointer address=0x00007f8e4b0191e0>>
# root.0.0.2: <Node context: [22, 5, 2, 0], id: #<FFI::Pointer address=0x00007f8e4b00f100>, tree: #<FFI::Pointer address=0x00007f8e4b0191e0>>, '(hash (pair key: (hash_key_symbol) value: (nil)))'
# #<TreeSitterFFI::QueryCursor address=0x00007f8e48db20f0>
#   0 <QueryMatch id: 0, pattern_index: 0, capture_count: 1, captures: [#<TreeSitterFFI::Range:0x00007f8e498cd4b0>]>
#   1 <QueryMatch id: 1, pattern_index: 0, capture_count: 1, captures: [#<TreeSitterFFI::Range:0x00007f8e490638b0>]>



###

# sexp = '(hash) @yum "false" (hash) @ooh "true"'
# Traceback (most recent call last):
# 	3: from fresh/run_query.rb:90:in `<main>'
# 	2: from /Users/cal/dev/rubymotion/tang/ta-treesit/vet-rusty-gen/fresh/gen-step/query_util.rb:340:in `matches'
# 	1: from /Users/cal/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/tree_sitter_ffi-0.0.2/lib/tree_sitter_ffi/boss.rb:30:in `block (2 levels) in wrap_attach'
# /Users/cal/.rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/tree_sitter_ffi-0.0.2/lib/tree_sitter_ffi/boss.rb:30:in `ts_query_cursor_exec': :pointer argument is not a valid pointer (ArgumentError)

lang = TreeSitterFFI.parser_javascript
sexp = "(function_declaration name: (identifier) @fn-name)"
query = TreeSitterFFI::Query.make(
    lang,
    sexp
)
# assert_query_matches(
#     language,
#     query,
input = 
    "function one() { two(); function three() {} }"
expect = 
    [
        [0, [["fn-name", "one"]]],
        [0, [["fn-name", "three"]]],
    ]
# )

parser = TreeSitterFFI.parser
parser.set_language(lang)
tree = parser.parse(input)

# sexp = '((hash) @yum "false" (hash) @ooh "true")'
# sexp = '((hash) @yum "false")'
# query = TreeSitterFFI::Query.make(lang, sexp)

puts "input: #{input}"
puts
puts "6. Query from rusty query: "

# puts sexp.pa(:on_green), query.pa(:on_yellow)
puts sexp, query
puts
# =>
# (hash)
# #<TreeSitterFFI::Query address=0x00007fa83f55d060>

cursor = TreeSitterFFI::QueryCursor.make
matches = cursor.matches(query, tree.root_node, input)
puts


puts "7. Matches: "
puts cursor #, matches.inspect
matches.each_with_index do |e, i|
  puts "  #{i} #{e.inspect}"
  cap = e[:captures]
  puts "    first cap: #{cap.inspect}"
  
end
puts

# coll = collect_matches(query, input, matches) # resig collect_matches for rusty
coll = collect_matches(matches, query, input)
puts "collect_matches: "
puts "        #{coll}"
# puts "        #{collect_matches(query, input, matches)}"
puts "expect: #{expect.inspect}"
# ap expect
puts "success: #{coll == expect}"
puts

# =>
# #<TreeSitterFFI::QueryCursor address=0x00007fa83f7fad90>
#   0 <QueryMatch id: 0 pattern_index: 0 capture_count: 0 captures: []>
#   1 <QueryMatch id: 1 pattern_index: 0 capture_count: 0 captures: []>

lang = TreeSitterFFI.parser_javascript
sexp = "(class_declaration
                name: (identifier) @the-class-name
                (class_body
                    (method_definition
                        name: (property_identifier) @the-method-name)))"
query = TreeSitterFFI::Query.make(lang, sexp)

input = "
            class Person {
                # the constructor
                constructor(name) { this.name = name; }

                # the getter
                getFullName() { return this.name; }
            }
            "
expect = [
                [
                    0,
                    [
                        ["the-class-name", "Person"],
                        ["the-method-name", "constructor"],
                    ],
                ],
                [
                    0,
                    [
                        ["the-class-name", "Person"],
                        ["the-method-name", "getFullName"],
                    ],
                ],
            ]

puts "input: #{input}"
puts
puts "8. Query from rusty query test_query_matches_with_multiple_on_same_root: "
# puts sexp.pa(:on_green), query.pa(:on_yellow)
puts sexp, query
puts
# =>

parser = TreeSitterFFI.parser
parser.set_language(lang)
tree = parser.parse(input)

cursor = TreeSitterFFI::QueryCursor.make
matches = cursor.matches(query, tree.root_node, input)

puts "9. Matches: "
puts cursor, matches.inspect
matches.each_with_index do |e, i|
  puts "  #{i} #{e.inspect}"
end
puts

# coll = collect_matches(query, input, matches) # resig collect_matches for rusty
coll = collect_matches(matches, query, input)
puts "collect_matches: "
puts "        #{coll}"
# puts "        #{collect_matches(query, input, matches)}"
puts "expect: #{expect.inspect}"
# ap expect
puts "success: #{coll == expect}"
puts

# =>

puts
puts "+=+=+=+= #{`date`}"
puts "done for now."
exit 0



=begin

#### doubtful!!! what even is this???
# cap1 = TreeSitterFFI.struct_at_index(matches[0][:captures], 0)
# puts "cap1: #{cap1.inspect}"
# puts

# ref parser
# 	it "set_included_ranges(Range|Array) # => :bool" do
# 		ranges = TreeSitterFFI::Range.new
# 		ret = @pars.set_included_ranges(ranges)
# 		[true, false].include?(ret).should == true
# 	end
# 
# 	it "included_ranges() # => Array" do
# 		ret = @pars.included_ranges()
# 		ret.should_not == nil
# 		ret.is_a?(Array).should == true
# 	end

### all good but suppress for now, so we can see the other...

puts "A. get/set included ranges..."
ret = parser.included_ranges()
puts "  included ret: #{ret.inspect}"
ret.each_with_index do |e, i|
  puts "  (#{i}) props: #{ret[i].props.inspect}"
end
ranges = TreeSitterFFI::Range.new
# ranges.props=([4,4], [8,8], [37, 58])
ret = parser.set_included_ranges(ranges)
puts "  set_included zero ret: #{ret.inspect}"
ret = parser.included_ranges()
puts "  included ret: #{ret.inspect}"
ret.each_with_index do |e, i|
  puts "  (#{i}) props: #{ret[i].props.inspect}"
end

ranges = TreeSitterFFI::Range.new
ranges.props=([[4,4], [8,8], [37, 58]])
ret = parser.set_included_ranges(ranges)
puts "  set_included [4,4], [8,8], [37, 58] ret: #{ret.inspect}"
ret = parser.included_ranges()
puts "  included ret: #{ret.inspect}"
ret.each_with_index do |e, i|
  puts "  (#{i}) props: #{ret[i].props.inspect}"
end

# multi = [[[2, 2], [4, 4], [8, 16]],
#   [[3, 3], [6, 6], [9, 18]],
#   [[4, 4], [0, 0], [20, 30]]].map do |props|

# how to fail set_included_ranges:
#       if (
#         range->start_byte < previous_byte ||
#         range->end_byte < range->start_byte
#       ) return false;
#       previous_byte = range->end_byte;

ranges = [[[2, 2], [4, 4], [8, 16]],
  [[5, 5], [7, 7], [17, 20]],
  [[8, 8], [10, 10], [22, 30]]].map do |props|
  TreeSitterFFI::Range.new.tap do |o|
    o.props = props
  end
end
puts "ranges inputs: #{ranges.inspect}"
prev = 0
ranges.each_with_index do |e, i|
#   prev = e[:start_byte] unless prev
  overlap = (e[:start_byte] < prev || e[:end_byte] < e[:start_byte])
  puts "  (#{i}) props: #{ranges[i].props.inspect}, ok: #{!overlap}"
  prev = e[:end_byte]
end

multi = TreeSitterFFI::Range.from_array(ranges)
puts "multi: #{multi.inspect}"

# iovlen = 3
# # iov = FFI::MemoryPointer.new(IOVec, iovlen)
# iovs = iovlen.times.collect do |i|
#   o = TreeSitterFFI::Range.new(multi.to_ptr + i * TreeSitterFFI::Range.size)
#   puts "  (#{i}) multi props: #{o.props}"
# end


ret = parser.set_included_ranges(multi)
puts "  set_included multi ret: #{ret.inspect}"
ret = parser.included_ranges()
puts "  included multi ret: #{ret.inspect}"
ret.each_with_index do |e, i|
  puts "  (#{i}) props: #{ret[i].props.inspect}"
end

puts
puts "done for now."
exit 0
=end

