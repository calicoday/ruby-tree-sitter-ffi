# this is the generated patch blank or edited patch file to add tests we 
# couldn't entirely gsub for the tree-sitter test:
# tree-sitter/cli/src/tests/node_test.rs


def test_node_children()
#     puts "!! #{__callee__}() stub"
    tree = parse_json_example()
    cursor = TreeSitterFFI.tree_cursor(tree.root_node)
    array_node = tree.root_node().child(0)
    kinds = []
    array_node.child_count.times do |i|
      kinds << array_node.child(i).type
    end
    assert_eq!(kinds, ["[", "number", ",", "false", ",", "object", "]",])
    
#     array_node.named_child_count.times do |i|
#       kinds << array_node.named_child(i).type
#     end
#     assert_eq!(kinds, ["number", "false", "object"])
    
#     object_node = array_node
end

def test_node_children_by_field_name()
    puts "!!  #{__callee__}() stub"
end

def test_node_named_child_with_aliases_and_extras()
    puts "!!  #{__callee__}() stub"
end

def test_node_edit()
    puts "!!  #{__callee__}() stub"
end

def test_node_field_names()
    puts "!!  #{__callee__}() stub"
end

def test_node_field_calls_in_language_without_fields()
    puts "!!  #{__callee__}() stub"
end

def test_node_is_named_but_aliased_as_anonymous()
    puts "!!  #{__callee__}() stub"
end


