# hacky hacky hacky -- generated by src/gen/rusty_gen.rb, NOT hand-tweaked

# this is a simplistic translation-by-regexp to ruby of the tree-sitter test:
# tree-sitter/cli/src/tests/node_test.rs


def test_node_child()
    tree = parse_json_example()
    array_node = tree.root_node().child(0)

    assert_eq!(array_node.type(), "array")
    assert_eq!(array_node.named_child_count(), 3)
    assert_eq!(array_node.start_byte(), JSON_EXAMPLE.index("["))
    assert_eq!(array_node.end_byte(), JSON_EXAMPLE.index("]") + 1)
    assert_eq!(array_node.start_point(), TreeSitterFFI::Point.new(2, 0))
    assert_eq!(array_node.end_point(), TreeSitterFFI::Point.new(8, 1))
    assert_eq!(array_node.child_count(), 7)

    left_bracket_node = array_node.child(0)
    number_node = array_node.child(1)
    comma_node1 = array_node.child(2)
    false_node = array_node.child(3)
    comma_node2 = array_node.child(4)
    object_node = array_node.child(5)
    right_bracket_node = array_node.child(6)

    assert_eq!(left_bracket_node.type(), "[")
    assert_eq!(number_node.type(), "number")
    assert_eq!(comma_node1.type(), ",")
    assert_eq!(false_node.type(), "false")
    assert_eq!(comma_node2.type(), ",")
    assert_eq!(object_node.type(), "object")
    assert_eq!(right_bracket_node.type(), "]")

    assert_eq!(left_bracket_node.is_named(), false)
    assert_eq!(number_node.is_named(), true)
    assert_eq!(comma_node1.is_named(), false)
    assert_eq!(false_node.is_named(), true)
    assert_eq!(comma_node2.is_named(), false)
    assert_eq!(object_node.is_named(), true)
    assert_eq!(right_bracket_node.is_named(), false)

    assert_eq!(number_node.start_byte(), JSON_EXAMPLE.index("123"))
    assert_eq!(
        number_node.end_byte(),
        JSON_EXAMPLE.index("123") + 3
    )
    assert_eq!(number_node.start_point(), TreeSitterFFI::Point.new(3, 2))
    assert_eq!(number_node.end_point(), TreeSitterFFI::Point.new(3, 5))

    assert_eq!(false_node.start_byte(), JSON_EXAMPLE.index("false"))
    assert_eq!(
        false_node.end_byte(),
        JSON_EXAMPLE.index("false") + 5
    )
    assert_eq!(false_node.start_point(), TreeSitterFFI::Point.new(4, 2))
    assert_eq!(false_node.end_point(), TreeSitterFFI::Point.new(4, 7))

    assert_eq!(object_node.start_byte(), JSON_EXAMPLE.index("{"))
    assert_eq!(object_node.start_point(), TreeSitterFFI::Point.new(5, 2))
    assert_eq!(object_node.end_point(), TreeSitterFFI::Point.new(7, 3))

    assert_eq!(object_node.child_count(), 3)
    left_brace_node = object_node.child(0)
    pair_node = object_node.child(1)
    right_brace_node = object_node.child(2)

    assert_eq!(left_brace_node.type(), "{")
    assert_eq!(pair_node.type(), "pair")
    assert_eq!(right_brace_node.type(), "}")

    assert_eq!(left_brace_node.is_named(), false)
    assert_eq!(pair_node.is_named(), true)
    assert_eq!(right_brace_node.is_named(), false)

    assert_eq!(pair_node.start_byte(), JSON_EXAMPLE.index("\"x\""))
    assert_eq!(pair_node.end_byte(), JSON_EXAMPLE.index("null") + 4)
    assert_eq!(pair_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(pair_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    assert_eq!(pair_node.child_count(), 3)
    string_node = pair_node.child(0)
    colon_node = pair_node.child(1)
    null_node = pair_node.child(2)

    assert_eq!(string_node.type(), "string")
    assert_eq!(colon_node.type(), ":")
    assert_eq!(null_node.type(), "null")

    assert_eq!(string_node.is_named(), true)
    assert_eq!(colon_node.is_named(), false)
    assert_eq!(null_node.is_named(), true)

    assert_eq!(
        string_node.start_byte(),
        JSON_EXAMPLE.index("\"x\"")
    )
    assert_eq!(
        string_node.end_byte(),
        JSON_EXAMPLE.index("\"x\"") + 3
    )
    assert_eq!(string_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(string_node.end_point(), TreeSitterFFI::Point.new(6, 7))

    assert_eq!(null_node.start_byte(), JSON_EXAMPLE.index("null"))
    assert_eq!(null_node.end_byte(), JSON_EXAMPLE.index("null") + 4)
    assert_eq!(null_node.start_point(), TreeSitterFFI::Point.new(6, 9))
    assert_eq!(null_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    assert_eq!(string_node.parent(), pair_node)
    assert_eq!(null_node.parent(), pair_node)
    assert_eq!(pair_node.parent(), object_node)
    assert_eq!(number_node.parent(), array_node)
    assert_eq!(false_node.parent(), array_node)
    assert_eq!(object_node.parent(), array_node)
    assert_eq!(array_node.parent(), tree.root_node())
    assert_eq!(tree.root_node().parent(), nil)
end

=begin
def test_node_children()
    tree = parse_json_example()
    cursor = tree.walk()
    array_node = tree.root_node().child(0)
#     assert_eq!(
#         array_node
#             .children(cursor)
#             .map(|n| n.type())
#             .TreeSitterFFI::collect.<Vec<_>>(),
#         &["[", "number", ",", "false", ",", "object", "]",]
#     )
#     assert_eq!(
#         array_node
#             .named_children(cursor)
#             .map(|n| n.type())
#             .TreeSitterFFI::collect.<Vec<_>>(),
#         &["number", "false", "object"]
#     )
    object_node = array_node
        .named_children(cursor)
        .index(|n| n.type() == "object")
#     assert_eq!(
#         object_node
#             .children(cursor)
#             .map(|n| n.type())
#             .TreeSitterFFI::collect.<Vec<_>>(),
#         &["{", "pair", "}",]
#     )
end
=end

=begin
def test_node_children_by_field_name()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("python"))
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

    tree = parser.parse(source, nil)
    node = tree.root_node().child(0)
    assert_eq!(node.type(), "if_statement")
    cursor = tree.walk()
    alternatives = node.children_by_field_name("alternative", cursor)
#     alternative_texts =
#         alternatives.map(|n| &source[n.child_by_field_name("condition").byte_range()])
#     assert_eq!(
#         alternative_texts.TreeSitterFFI::collect.<Vec<_>>(),
#         &["two", "three", "four",]
#     )
end
=end

def test_node_parent_of_child_by_field_name()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("javascript"))
    tree = parser.parse("foo(a().b[0].c.d.e())", nil)
    call_node = tree
        .root_node()
        .named_child(0)
        .named_child(0)
    assert_eq!(call_node.type(), "call_expression")

    # Regression test - when a field points to a hidden node (in this case, `_expression`)
    # the hidden node should not be added to the node parent cache.
    assert_eq!(
        call_node.child_by_field_name("function").parent(),
        (call_node)
    )
end

def test_node_field_name_for_child()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("c"))
    tree = parser.parse("x + y;", nil)
    translation_unit_node = tree.root_node()
    binary_expression_node = translation_unit_node
        .named_child(0)
        .named_child(0)

    assert_eq!(binary_expression_node.field_name_for_child(0), ("left"))
    assert_eq!(
        binary_expression_node.field_name_for_child(1),
        ("operator")
    )
    assert_eq!(
        binary_expression_node.field_name_for_child(2),
        ("right")
    )
    # Negative test - Not a valid child index
    assert_eq!(binary_expression_node.field_name_for_child(3), nil)
end

def test_node_child_by_field_name_with_extra_hidden_children()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("python"))

    # In the Python grammar, some fields are applied to `suite` nodes,
    # which consist of an invisible `indent` token followed by a block.
    # Check that when searching for a child with a field name, we don't
    #
    tree = parser.parse("while a:\n  pass", nil)
    while_node = tree.root_node().child(0)
    assert_eq!(while_node.type(), "while_statement")
    assert_eq!(
        while_node.child_by_field_name("body"),
        while_node.child(3),
    )
end

def test_node_named_child()
    tree = parse_json_example()
    array_node = tree.root_node().child(0)

    number_node = array_node.named_child(0)
    false_node = array_node.named_child(1)
    object_node = array_node.named_child(2)

    assert_eq!(number_node.type(), "number")
    assert_eq!(number_node.start_byte(), JSON_EXAMPLE.index("123"))
    assert_eq!(
        number_node.end_byte(),
        JSON_EXAMPLE.index("123") + 3
    )
    assert_eq!(number_node.start_point(), TreeSitterFFI::Point.new(3, 2))
    assert_eq!(number_node.end_point(), TreeSitterFFI::Point.new(3, 5))

    assert_eq!(false_node.type(), "false")
    assert_eq!(false_node.start_byte(), JSON_EXAMPLE.index("false"))
    assert_eq!(
        false_node.end_byte(),
        JSON_EXAMPLE.index("false") + 5
    )
    assert_eq!(false_node.start_point(), TreeSitterFFI::Point.new(4, 2))
    assert_eq!(false_node.end_point(), TreeSitterFFI::Point.new(4, 7))

    assert_eq!(object_node.type(), "object")
    assert_eq!(object_node.start_byte(), JSON_EXAMPLE.index("{"))
    assert_eq!(object_node.start_point(), TreeSitterFFI::Point.new(5, 2))
    assert_eq!(object_node.end_point(), TreeSitterFFI::Point.new(7, 3))

    assert_eq!(object_node.named_child_count(), 1)

    pair_node = object_node.named_child(0)
    assert_eq!(pair_node.type(), "pair")
    assert_eq!(pair_node.start_byte(), JSON_EXAMPLE.index("\"x\""))
    assert_eq!(pair_node.end_byte(), JSON_EXAMPLE.index("null") + 4)
    assert_eq!(pair_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(pair_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    string_node = pair_node.named_child(0)
    null_node = pair_node.named_child(1)

    assert_eq!(string_node.type(), "string")
    assert_eq!(null_node.type(), "null")

    assert_eq!(
        string_node.start_byte(),
        JSON_EXAMPLE.index("\"x\"")
    )
    assert_eq!(
        string_node.end_byte(),
        JSON_EXAMPLE.index("\"x\"") + 3
    )
    assert_eq!(string_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(string_node.end_point(), TreeSitterFFI::Point.new(6, 7))

    assert_eq!(null_node.start_byte(), JSON_EXAMPLE.index("null"))
    assert_eq!(null_node.end_byte(), JSON_EXAMPLE.index("null") + 4)
    assert_eq!(null_node.start_point(), TreeSitterFFI::Point.new(6, 9))
    assert_eq!(null_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    assert_eq!(string_node.parent(), pair_node)
    assert_eq!(null_node.parent(), pair_node)
    assert_eq!(pair_node.parent(), object_node)
    assert_eq!(number_node.parent(), array_node)
    assert_eq!(false_node.parent(), array_node)
    assert_eq!(object_node.parent(), array_node)
    assert_eq!(array_node.parent(), tree.root_node())
    assert_eq!(tree.root_node().parent(), nil)
end

=begin
def test_node_named_child_with_aliases_and_extras()
    (parser_name, parser_code) =
        generate_parser_for_grammar(GRAMMAR_WITH_ALIASES_AND_EXTRAS)

    parser = TreeSitterFFI.parser()
#     parser
#         .set_language(get_test_language(&parser_name, &parser_code, nil))

    tree = parser.parse("b ... b ... c", nil)
    root = tree.root_node()
    assert_eq!(root.to_sexp(), "(a (b) (comment) (B) (comment) (C))")
    assert_eq!(root.named_child_count(), 5)
    assert_eq!(root.named_child(0).type(), "b")
    assert_eq!(root.named_child(1).type(), "comment")
    assert_eq!(root.named_child(2).type(), "B")
    assert_eq!(root.named_child(3).type(), "comment")
    assert_eq!(root.named_child(4).type(), "C")
end
=end

def test_node_descendant_for_range()
    tree = parse_json_example()
    array_node = tree.root_node().child(0)

    # Leaf node exactly matches the given bounds - byte query
    colon_index = JSON_EXAMPLE.index(":")
    colon_node = array_node
        .descendant_for_byte_range(colon_index, colon_index + 1)
    assert_eq!(colon_node.type(), ":")
    assert_eq!(colon_node.start_byte(), colon_index)
    assert_eq!(colon_node.end_byte(), colon_index + 1)
    assert_eq!(colon_node.start_point(), TreeSitterFFI::Point.new(6, 7))
    assert_eq!(colon_node.end_point(), TreeSitterFFI::Point.new(6, 8))

    # Leaf node exactly matches the given bounds - point query
    colon_node = array_node
        .descendant_for_point_range(TreeSitterFFI::Point.new(6, 7), TreeSitterFFI::Point.new(6, 8))
    assert_eq!(colon_node.type(), ":")
    assert_eq!(colon_node.start_byte(), colon_index)
    assert_eq!(colon_node.end_byte(), colon_index + 1)
    assert_eq!(colon_node.start_point(), TreeSitterFFI::Point.new(6, 7))
    assert_eq!(colon_node.end_point(), TreeSitterFFI::Point.new(6, 8))

    # The given point is between two adjacent leaf nodes - byte query
    colon_index = JSON_EXAMPLE.index(":")
    colon_node = array_node
        .descendant_for_byte_range(colon_index, colon_index)
    assert_eq!(colon_node.type(), ":")
    assert_eq!(colon_node.start_byte(), colon_index)
    assert_eq!(colon_node.end_byte(), colon_index + 1)
    assert_eq!(colon_node.start_point(), TreeSitterFFI::Point.new(6, 7))
    assert_eq!(colon_node.end_point(), TreeSitterFFI::Point.new(6, 8))

    # The given point is between two adjacent leaf nodes - point query
    colon_node = array_node
        .descendant_for_point_range(TreeSitterFFI::Point.new(6, 7), TreeSitterFFI::Point.new(6, 7))
    assert_eq!(colon_node.type(), ":")
    assert_eq!(colon_node.start_byte(), colon_index)
    assert_eq!(colon_node.end_byte(), colon_index + 1)
    assert_eq!(colon_node.start_point(), TreeSitterFFI::Point.new(6, 7))
    assert_eq!(colon_node.end_point(), TreeSitterFFI::Point.new(6, 8))

    # Leaf node starts at the lower bound, ends after the upper bound - byte query
    string_index = JSON_EXAMPLE.index("\"x\"")
    string_node = array_node
        .descendant_for_byte_range(string_index, string_index + 2)
    assert_eq!(string_node.type(), "string")
    assert_eq!(string_node.start_byte(), string_index)
    assert_eq!(string_node.end_byte(), string_index + 3)
    assert_eq!(string_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(string_node.end_point(), TreeSitterFFI::Point.new(6, 7))

    # Leaf node starts at the lower bound, ends after the upper bound - point query
    string_node = array_node
        .descendant_for_point_range(TreeSitterFFI::Point.new(6, 4), TreeSitterFFI::Point.new(6, 6))
    assert_eq!(string_node.type(), "string")
    assert_eq!(string_node.start_byte(), string_index)
    assert_eq!(string_node.end_byte(), string_index + 3)
    assert_eq!(string_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(string_node.end_point(), TreeSitterFFI::Point.new(6, 7))

    # Leaf node starts before the lower bound, ends at the upper bound - byte query
    null_index = JSON_EXAMPLE.index("null")
    null_node = array_node
        .descendant_for_byte_range(null_index + 1, null_index + 4)
    assert_eq!(null_node.type(), "null")
    assert_eq!(null_node.start_byte(), null_index)
    assert_eq!(null_node.end_byte(), null_index + 4)
    assert_eq!(null_node.start_point(), TreeSitterFFI::Point.new(6, 9))
    assert_eq!(null_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    # Leaf node starts before the lower bound, ends at the upper bound - point query
    null_node = array_node
        .descendant_for_point_range(TreeSitterFFI::Point.new(6, 11), TreeSitterFFI::Point.new(6, 13))
    assert_eq!(null_node.type(), "null")
    assert_eq!(null_node.start_byte(), null_index)
    assert_eq!(null_node.end_byte(), null_index + 4)
    assert_eq!(null_node.start_point(), TreeSitterFFI::Point.new(6, 9))
    assert_eq!(null_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    # The bounds span multiple leaf nodes - return the smallest node that does span it.
    pair_node = array_node
        .descendant_for_byte_range(string_index + 2, string_index + 4)
    assert_eq!(pair_node.type(), "pair")
    assert_eq!(pair_node.start_byte(), string_index)
    assert_eq!(pair_node.end_byte(), string_index + 9)
    assert_eq!(pair_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(pair_node.end_point(), TreeSitterFFI::Point.new(6, 13))

    assert_eq!(colon_node.parent(), (pair_node))

    # no leaf spans the given range - return the smallest node that does span it.
    pair_node = array_node
        .named_descendant_for_point_range(TreeSitterFFI::Point.new(6, 6), TreeSitterFFI::Point.new(6, 8))
    assert_eq!(pair_node.type(), "pair")
    assert_eq!(pair_node.start_byte(), string_index)
    assert_eq!(pair_node.end_byte(), string_index + 9)
    assert_eq!(pair_node.start_point(), TreeSitterFFI::Point.new(6, 4))
    assert_eq!(pair_node.end_point(), TreeSitterFFI::Point.new(6, 13))
end

=begin
def test_node_edit()
    code = JSON_EXAMPLE.as_bytes().to_vec()
    tree = parse_json_example()
    rand = TreeSitterFFI::Rand.new(0)

#     for _ in 0..10 {
#         nodes_before = get_all_nodes(&tree)

        edit = get_random_edit(rand, code)
        tree2 = tree.copy()
#         edit = perform_edit(tree2, code, &edit)
#         for node in nodes_before.iter_mut() {
#             node.edit(&edit)
#         }

#         nodes_after = get_all_nodes(&tree2)
        for (i, node) in nodes_before.into_iter().enumerate() {
            assert_eq!(
                (node.type(), node.start_byte(), node.start_point()),
                (
                    nodes_after[i].type(),
                    nodes_after[i].start_byte(),
                    nodes_after[i].start_point()
                ),
            )
        }

        tree = tree2
    }
end
=end

def test_node_is_extra()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("javascript"))
    tree = parser.parse("foo(/* hi */);", nil)

    root_node = tree.root_node()
    comment_node = root_node.descendant_for_byte_range(7, 7)

    assert_eq!(root_node.type(), "program")
    assert_eq!(comment_node.type(), "comment")
    assert!(!root_node.is_extra())
    assert!(comment_node.is_extra())
end

def test_node_sexp()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("javascript"))
    tree = parser.parse("if (a) b", nil)
    root_node = tree.root_node()
    if_node = root_node.descendant_for_byte_range(0, 0)
    paren_node = root_node.descendant_for_byte_range(3, 3)
    identifier_node = root_node.descendant_for_byte_range(4, 4)
    assert_eq!(if_node.type(), "if")
    assert_eq!(if_node.to_sexp(), "(\"if\")")
    assert_eq!(paren_node.type(), "(")
    assert_eq!(paren_node.to_sexp(), "(\"(\")")
    assert_eq!(identifier_node.type(), "identifier")
    assert_eq!(identifier_node.to_sexp(), "(identifier)")
end

=begin
def test_node_field_names()
    # (parser_name, parser_code) = generate_parser_for_grammar(
#         <<-HEREDOC
#         {
#             "name": "test_grammar_with_fields",
#             "extras": [
#                 {"type": "PATTERN", "value": "\\s+"}
#             ],
#             "rules": {
#                 "rule_a": {
#                     "type": "SEQ",
#                     "members": [
#                         {
#                             "type": "FIELD",
#                             "name": "field_1",
#                             "content": {"type": "STRING", "value": "child-0"}
#                         },
#                         {
#                             "type": "CHOICE",
#                             "members": [
#                                 {"type": "STRING", "value": "child-1"},
#                                 {"type": "BLANK"},

#                                 # This isn't used in the test, but prevents `_hidden_rule1`
#                                 # from being eliminated as a unit reduction.
#                                 {
#                                     "type": "ALIAS",
#                                     "value": "x",
#                                     "named": true,
#                                     "content": {
#                                         "type": "SYMBOL",
#                                         "name": "_hidden_rule1"
#                                     }
#                                 }
#                             ]
#                         },
#                         {
#                             "type": "FIELD",
#                             "name": "field_2",
#                             "content": {"type": "SYMBOL", "name": "_hidden_rule1"}
#                         },
#                         {"type": "SYMBOL", "name": "_hidden_rule2"}
#                     ]
#                 },

#                 # Fields pointing to hidden nodes with a single child resolve to the child.
#                 "_hidden_rule1": {
#                     "type": "CHOICE",
#                     "members": [
#                         {"type": "STRING", "value": "child-2"},
#                         {"type": "STRING", "value": "child-2.5"}
#                     ]
#                 },

#                 # Fields within hidden nodes can be referenced through the parent node.
#                 "_hidden_rule2": {
#                     "type": "SEQ",
#                     "members": [
#                         {"type": "STRING", "value": "child-3"},
#                         {
#                             "type": "FIELD",
#                             "name": "field_3",
#                             "content": {"type": "STRING", "value": "child-4"}
#                         }
#                     ]
#                 }
#             }
#         }
#     HEREDOC
#     ,
#     );

#     parser = TreeSitterFFI.parser();
#     language = get_test_language(&parser_name, &parser_code, nil);
#     parser.set_language(language);

#     tree = parser
#         .parse("child-0 child-1 child-2 child-3 child-4", nil);
#     root_node = tree.root_node();

#     assert_eq!(root_node.child_by_field_name("field_1"), root_node.child(0));
#     assert_eq!(root_node.child_by_field_name("field_2"), root_node.child(2));
#     assert_eq!(root_node.child_by_field_name("field_3"), root_node.child(4));
#     assert_eq!(
#         root_node.child(0).child_by_field_name("field_1"),
#         nil
#     );
#     assert_eq!(root_node.child_by_field_name("not_a_real_field"), nil);

#     cursor = root_node.walk();
#     assert_eq!(cursor.field_name(), nil);
#     cursor.goto_first_child();
#     assert_eq!(cursor.node().type(), "child-0");
#     assert_eq!(cursor.field_name(), ("field_1"));
#     cursor.goto_next_sibling();
#     assert_eq!(cursor.node().type(), "child-1");
#     assert_eq!(cursor.field_name(), nil);
#     cursor.goto_next_sibling();
#     assert_eq!(cursor.node().type(), "child-2");
#     assert_eq!(cursor.field_name(), ("field_2"));
#     cursor.goto_next_sibling();
#     assert_eq!(cursor.node().type(), "child-3");
#     assert_eq!(cursor.field_name(), nil);
#     cursor.goto_next_sibling();
#     assert_eq!(cursor.node().type(), "child-4");
#     assert_eq!(cursor.field_name(), ("field_3"))
end
=end

=begin
def test_node_field_calls_in_language_without_fields()
    # (parser_name, parser_code) = generate_parser_for_grammar(
#         <<-HEREDOC
#         {
#             "name": "test_grammar_with_no_fields",
#             "extras": [
#                 {"type": "PATTERN", "value": "\\s+"}
#             ],
#             "rules": {
#                 "a": {
#                     "type": "SEQ",
#                     "members": [
#                         {
#                             "type": "STRING",
#                             "value": "b"
#                         },
#                         {
#                             "type": "STRING",
#                             "value": "c"
#                         },
#                         {
#                             "type": "STRING",
#                             "value": "d"
#                         }
#                     ]
#                 }
#             }
#         }
#     HEREDOC
#     ,
#     );

#     parser = TreeSitterFFI.parser();
#     language = get_test_language(&parser_name, &parser_code, nil);
#     parser.set_language(language);

#     tree = parser.parse("b c d", nil);

#     root_node = tree.root_node();
#     assert_eq!(root_node.type(), "a");
#     assert_eq!(root_node.child_by_field_name("something"), nil)

    cursor = root_node.walk()
    assert_eq!(cursor.field_name(), nil)
    assert_eq!(cursor.goto_first_child(), true)
    assert_eq!(cursor.field_name(), nil)
end
=end

=begin
def test_node_is_named_but_aliased_as_anonymous()
    # (parser_name, parser_code) = generate_parser_for_grammar(
#         &TreeSitterFFI::fs.read_to_string(
#             &fixtures_dir()
#                 .join("test_grammars")
#                 .join("named_rule_aliased_as_anonymous")
#                 .join("grammar.json"),
#         ),
#     )

    parser = TreeSitterFFI.parser()
#     language = get_test_language(&parser_name, &parser_code, nil)
    parser.set_language(language)

    tree = parser.parse("B C B", nil)

    root_node = tree.root_node()
    assert!(!root_node.has_error())
    assert_eq!(root_node.child_count(), 3)
    assert_eq!(root_node.named_child_count(), 2)

    aliased = root_node.child(0)
    assert!(!aliased.is_named())
    assert_eq!(aliased.type(), "the-alias")

    assert_eq!(root_node.named_child(0).type(), "c")
end
=end

def test_node_numeric_symbols_respect_simple_aliases()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("python"))

    # Example 1:
    # Python argument lists can contain "splat" arguments, which are not allowed within
    # other expressions. This includes `parenthesized_list_splat` nodes like `(*b)`. These
    # `parenthesized_list_splat` nodes are aliased as `parenthesized_expression`. Their numeric
    # `symbol`, aka `kind_id` should match that of a normal `parenthesized_expression`.
    tree = parser.parse("(a((*b)))", nil)
    root = tree.root_node()
    assert_eq!(
        root.to_sexp(),
        "(module (expression_statement (parenthesized_expression (call function: (identifier) arguments: (argument_list (parenthesized_expression (list_splat (identifier))))))))",
    )

    outer_expr_node = root.child(0).child(0)
    assert_eq!(outer_expr_node.type(), "parenthesized_expression")

    inner_expr_node = outer_expr_node
        .named_child(0)
        .child_by_field_name("arguments")
        .named_child(0)
    assert_eq!(inner_expr_node.type(), "parenthesized_expression")
    assert_eq!(inner_expr_node.type_id(), outer_expr_node.type_id())

    # Example 2:
    # Ruby handles the unary (negative) and binary (minus) `-` operators using two different
    # tokens. One or more of these is an external token that's aliased as `-`. Their numeric
    # kind ids should match.
    parser.set_language(get_language("ruby"))
    tree = parser.parse("-a - b", nil)
    root = tree.root_node()
    assert_eq!(
        root.to_sexp(),
        "(program (binary left: (unary operand: (identifier)) right: (identifier)))",
    )

    binary_node = root.child(0)
    assert_eq!(binary_node.type(), "binary")

    unary_minus_node = binary_node
        .child_by_field_name("left")
        .child(0)
    assert_eq!(unary_minus_node.type(), "-")

    binary_minus_node = binary_node.child_by_field_name("operator")
    assert_eq!(binary_minus_node.type(), "-")
    assert_eq!(unary_minus_node.type_id(), binary_minus_node.type_id())
end

=begin
def get_all_nodes(tree: &Tree)
    # result = TreeSitterFFI::Vec.new()
    visited_children = false
    cursor = tree.walk()
    loop {
        result.push(cursor.node())
        if !visited_children && cursor.goto_first_child() {
            continue
        } else if cursor.goto_next_sibling() {
            visited_children = false
        } else if cursor.goto_parent() {
            visited_children = true
        } else {
            break
        }
    }
    return result
end
=end

def parse_json_example()
    parser = TreeSitterFFI.parser()
    parser.set_language(get_language("json"))
    parser.parse(JSON_EXAMPLE, nil)
end


