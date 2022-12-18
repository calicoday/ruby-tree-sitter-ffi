# various rewrites of the input sample JSON_EXAMPLE by walking the tree (not TreeCursor)

require 'tree_sitter_ffi'

require './demo/runner.rb'

JSON_EXAMPLE = <<-INDENTED_HEREDOC


[
  123,
  false,
  {
    "x": null
  }
]
	INDENTED_HEREDOC


# parse the input
tree = Runner.parse(:json, JSON_EXAMPLE)

puts "0. Demo input (note initial blank lines): "
puts JSON_EXAMPLE
puts
# =>
# 
# 
# [
#   123,
#   false,
#   {
#     "x": null
#   }
# ]


puts "1. Basic s-expression string: "
puts tree.root_node.string
puts
# => 
# (document (array (number) (false) (object (pair key: (string (string_content)) value: (null)))))

puts "2. Same string with added indenting, for reference: "
puts Runner.pretty_sexp_from_string(tree.root_node.string)
puts
# =>
# (document 
#   (array 
#     (number) 
#     (false) 
#     (object 
#       (pair key: 
#         (string 
#           (string_content)) value: 
#         (null)))))

puts "3. Walk the tree and put out nodes (delimited by '<', '>') and input text: "
puts Runner.pretty_node(tree.root_node, JSON_EXAMPLE)
puts
# =>
# <document>
#   <array>
#     <[>
#       [
#     <number>
#       123
#     <,>
#       ,
#     <false>
#       false
#     <,>
#       ,
#     <object>
#       <{>
#         {
#       <pair>
#         <string>
#           <">
#             "
#           <string_content>
#             x
#           <">
#             "
#         <:>
#           :
#         <null>
#           null
#       <}>
#         }
#     <]>
#       ]

puts "4. Walk the tree and put out only input text and input whitespace "
puts "(this will match the original input, character for character): "
puts Runner.compose_via_node(tree.root_node, JSON_EXAMPLE) # no block
puts
# =>
# 
# 
# [
#   123,
#   false,
#   {
#     "x": null
#   }
# ]

puts "5. Walk the tree, stripping (ie ignoring) all whitespace, even at the end: "
got =  Runner.compose_via_node(tree.root_node, JSON_EXAMPLE){} # empty block
puts got
# =>
# [123,false,{"x":null}]

puts "6. Walk the tree, indenting by 3 spaces * node depth in full ancestry "
puts "(eg first '[' is at depth 2, therefore 6 spaces): "
# newlines before text here, so mark whether it's the first call
first = true
got = Runner.compose_via_node(tree.root_node, JSON_EXAMPLE) do |n, depth, ws, text|
	newline = (first ? '' : "\n")
	first = false
	newline + '   ' * depth + text
end
puts got
puts
# =>
#       [
#       123
#       ,
#       false
#       ,
#          {
#                "
#                x
#                "
#             :
#             null
#          }
#       ]

puts "7. Walk the tree, indenting 3 spaces by text characters (eg '[', '{', etc): "
# calc indent by type and newlines AFTER text here
level = 0
ready_indent = ''
got = Runner.compose_via_node(tree.root_node, JSON_EXAMPLE) do |n, depth, ws, text|
	pretty = ""
	case text
	when '[', '{' 
		pretty += "#{ready_indent}#{text}"
		level += 1
		ready_indent = "\n#{'  ' * level}"
	when ']', '}'
		level -= 1
		ready_indent = "\n#{'  ' * level}"
		pretty += "#{ready_indent}#{text}"
	when ',' 
		pretty += "#{text}"
		ready_indent = "\n#{'  ' * level}"
	when ':'
		# shdnt ever be first after indent but add space after
		pretty += "#{ready_indent}#{text} " 
		ready_indent = ''
	else
		pretty += "#{ready_indent}#{text}"
		ready_indent = ''
	end
	pretty
end
puts got
puts
# =>
# [
#   123,
#   false,
#   {
#     "x": null
#   }
# ]

puts "8. Walk the tree, making newlines, tabs and spaces visible: "
got = Runner.compose_via_node(tree.root_node, JSON_EXAMPLE) do |n, depth, ws, text|
# got = Runner.compose(tree.root_node, JSON_EXAMPLE) do |n, depth, ws, text|
	# make this account for tab distance!!!
	ws.gsub(' ', '.').gsub("\t", '_').gsub("\n", "$\n") + text
end
puts got
puts
# =>
# $
# $
# [$
# ..123,$
# ..false,$
# ..{$
# ...."x":.null$
# ..}$
# ]


puts "done."

