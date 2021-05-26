require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

# Create a parser.
parser = TreeSitterFFI.parser

# Set the parser's language (JSON in this case).
TreeSitterFFI.ts_parser_set_language(parser, TreeSitterFFI.parser_json)

# Build a syntax tree based on source code stored in a string.
source_code = '[1, null]'
tree = TreeSitterFFI.ts_parser_parse_string(parser, nil, source_code, source_code.length)

# Get the root node of the syntax tree.
root_node = TreeSitterFFI.ts_tree_root_node(tree)

# Get some child nodes.
array_node = TreeSitterFFI.ts_node_named_child(root_node, 0)
number_node = TreeSitterFFI.ts_node_named_child(array_node, 0)

# Check that the nodes have the expected types.
puts TreeSitterFFI.ts_node_type(root_node)
# => 'document'
puts TreeSitterFFI.ts_node_type(array_node)
# => 'array'
puts TreeSitterFFI.ts_node_type(number_node)
# => 'number'

# Check that the nodes have the expected child counts.
puts TreeSitterFFI.ts_node_child_count(root_node)
# => 1# puts array_node.child_count
puts TreeSitterFFI.ts_node_child_count(array_node)
# => 5
puts TreeSitterFFI.ts_node_named_child_count(array_node)
# => 2
puts TreeSitterFFI.ts_node_child_count(number_node)
# => 0

# Print the syntax tree as an S-expression.
puts "Syntax tree: #{root_node.string}"
# => (document (array (number) (null)))

