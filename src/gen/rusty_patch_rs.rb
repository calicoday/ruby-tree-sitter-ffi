# rusty test functions translated to ruby by hand (test util functions at end)

# Keep 4-space indents bc that's what in the orig _text.rs files and what the
# generated rusty_ test files have copied. Only matters for string literal matching
# but let's stay consistant.
# Mark string literals that were 'r#""' with '%q%%'

    # need: parse_json_example()
    # need: node.children(cursor) => Array
    # need: node.kind() # got it???
    # need: node.named_children(cursor) => Array
    # need: children_by_field_name(name, cursor) => Array
    # need: something to convert TSRange to Range
    # need: TSRange.to_range => Range
    # need: generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS) # app cli!!!
    # => see if we can pre generate suitable!!!
    # need: tree.clone()

# node_test.rs

def test_node_children
    tree = parse_json_example()
    cursor = tree.walk()
    array_node = tree.root_node().child(0)

    # need: node.children(cursor) => array
    # need: node.kind() # got it???
    assert_eq!(
        array_node.children(cursor).map{|e| e.kind}, 
        ["[", "number", ",", "false", ",", "object", "]",]
        )
      
    # need: node.named_children(cursor) => array
    assert_eq!(
        array_node.named_children(cursor).map{|e| e.kind}, 
        ["[", "number", ",", "false", ",", "object", "]",]
        )
    
    object_node = array_node.named_children(cursor).select{|e| e.kind == "object"}
    assert_eq!(
        object_node.children(cursor).map{|e| e.kind}, 
        ["{", "pair", "}",]
        )
end
    
def test_node_children_by_field_name
    parser = Parser.new
    parser.set_language(get_language("python"))
    # watch literal spaces!!! FIXME!!!
    source = "
        if one:
            a()
        elif two:
            b()
        elif three:
            c()
        elif four:
            d()
    "
    
    # use ruby api!!! FIXME!!!
    tree = parser.parse(source)
    node = tree.root_node.child(0)
    assert_eq!(node.kind(), "if_statement")
    
    cursor = tree.walk
    # need: children_by_field_name(name, cursor) => Array
    alternatives = node.children_by_field_name("alternative", cursor)
    # need: TSRange.to_range => Range
    
    alternative_texts = alternatives.map do |e|
        source[e.child_by_field_name("condition").byte_range.to_range]
    end
    assert_eq!(
        alternative_texts,
        ["two", "three", "four",]
    )
end

def test_node_named_child_with_aliases_and_extras
  # skip
  # need: generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS) # app cli!!!
end

def test_node_edit
#     let mut code = JSON_EXAMPLE.as_bytes().to_vec();
    code = JSON_EXAMPLE.bytes # same as rust as_bytes??? CONF!!!
    tree = parse_json_example

    10.times do |i|
        nodes_before = get_all_nodes(tree)
      
        edit = get_random_edit(code)
        # need: tree.clone()
        tree2 = tree.clone
        edit2 = perform_edit(tree2, code, edit)
        nodes_before.each{|e| e.edit(edit2)}
      
        nodes_after = get_all_nodes(tree2)
        nodes_before.each_with_index do |node, i|
            node2 = nodes_after[i]
            assert_eq!(
                [node.king, node.start_byte, node.start_position],
                [node2.king, node2.start_byte, node2.start_position]
                )
        end
        tree = tree2
    end
end

def test_node_field_names
  # skip
  # need: generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS) # app cli!!!
end

def test_node_field_calls_in_language_without_fields
  # skip
  # need: generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS) # app cli!!!
end

def test_node_is_named_but_aliased_as_anonymous
  # skip
  # need: generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS) # app cli!!!
end


# tree_test.rs

def test_get_changed_ranges
end

# deps : index_of(text, substring), range_of(text, substring), 
#   get_changed_ranges(parser, tree, source_code, edit)


### rusty test util functions (shd prob be somewhere else!!! FIXME!!!)

# node_test.rs

# => Vec<Node> now Array
def get_all_nodes(tree)
    result = []
    visited_children = false
    cursor = tree.walk
  
    while true
        result << cursor.node
        if !visited_children && cursor.goto_first_child
            next
        elsif cursor.goto_next_sibling
            visited_children = false
        elsif cursor.goto_parent
            visited_children = true
        else
          break
        end
    end
    result
end
