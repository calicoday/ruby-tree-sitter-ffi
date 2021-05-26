require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'

# Create a parser.
parser = TreeSitterFFI.parser

# Set the parser's language (JSON in this case).
parser.set_language(TreeSitterFFI.parser_json)

# Build a syntax tree based on source code stored in a string.
source_code = '[1, null]'
tree = parser.parse_string(nil, source_code, source_code.length)

# Get the root node of the syntax tree.
root_node = tree.root_node

# Get some child nodes.
array_node = root_node.named_child(0)
number_node = array_node.named_child(0)

# Check that the nodes have the expected types.
puts root_node.type
# => 'document'
puts array_node.type
# => 'array'
puts number_node.type
# => 'number'

# Check that the nodes have the expected child counts.
puts root_node.child_count
# => 1
puts array_node.child_count
# => 5
puts array_node.named_child_count
# => 2
puts number_node.child_count
# => 0

# Print the syntax tree as an S-expression.
puts "Syntax tree: #{root_node.string}"
# => (document (array (number) (null)))

