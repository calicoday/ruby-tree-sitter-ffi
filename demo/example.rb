require 'tree_sitter_ffi'

# Create a parser.
parser = TreeSitterFFI.parser

# Add the language parser library (JSON in this case) with an absolute path
TreeSitterFFI.add_lang(:tree_sitter_json, 
  '/usr/local/lib/tree-sitter-json/libtree-sitter-json.0.19.0.dylib')

# Create the language object
json_obj = TreeSitterFFI.tree_sitter_json

# Set the parser's language.
parser.set_language(json_obj)

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

