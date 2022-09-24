## Difference report 0.20.0 to 0.20.6


### lib/include/tree_sitter/api.h


```diff
diff --git a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/lib/include/tree_sitter/api.h b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/lib/include/tree_sitter/api.h
index f02789e..1ace7be 100644
--- a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/lib/include/tree_sitter/api.h
+++ b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/lib/include/tree_sitter/api.h

```

-21,7 +21,7

```diff
 extern "C" {
  * The Tree-sitter library is generally backwards-compatible with languages
  * generated using older CLI versions, but is not forwards-compatible.
  */
-#define TREE_SITTER_LANGUAGE_VERSION 13
+#define TREE_SITTER_LANGUAGE_VERSION 14
 
 /**
  * The earliest ABI version that is supported by the current version of the

```

-106,6 +106,14

```diff
 typedef struct {
   uint32_t index;
 } TSQueryCapture;
 
+typedef enum {
+  TSQuantifierZero = 0, // must match the array initialization value
+  TSQuantifierZeroOrOne,
+  TSQuantifierZeroOrMore,
+  TSQuantifierOne,
+  TSQuantifierOneOrMore,
+} TSQuantifier;
+
 typedef struct {
   uint32_t id;
   uint16_t pattern_index;

```

-131,6 +139,7

```diff
 typedef enum {
   TSQueryErrorField,
   TSQueryErrorCapture,
   TSQueryErrorStructure,
+  TSQueryErrorLanguage,
 } TSQueryError;
 
 /********************/

```

-179,9 +188,7

```diff
 const TSLanguage *ts_parser_language(const TSParser *self);
  * If `length` is zero, then the entire document will be parsed. Otherwise,
  * the given ranges must be ordered from earliest to latest in the document,
  * and they must not overlap. That is, the following must hold for all
- * `i` < `length - 1`:
- *
- *     ranges[i].end_byte <= ranges[i + 1].start_byte
+ * `i` < `length - 1`: ranges[i].end_byte <= ranges[i + 1].start_byte
  *
  * If this requirement is not satisfied, the operation will fail, the ranges
  * will not be assigned, and this function will return `false`. On success,

```

-618,7 +625,7

```diff
 TSNode ts_tree_cursor_current_node(const TSTreeCursor *);
 const char *ts_tree_cursor_current_field_name(const TSTreeCursor *);
 
 /**
- * Get the field name of the tree cursor's current node.
+ * Get the field id of the tree cursor's current node.
  *
  * This returns zero if the current node doesn't have a field.
  * See also `ts_node_child_by_field_id`, `ts_language_field_id_for_name`.

```

-726,7 +733,7

```diff
 const TSQueryPredicateStep *ts_query_predicates_for_pattern(
   uint32_t *length
 );
 
-bool ts_query_step_is_definite(
+bool ts_query_is_pattern_guaranteed_at_step(
   const TSQuery *self,
   uint32_t byte_offset
 );

```

-741,6 +748,17

```diff
 const char *ts_query_capture_name_for_id(
   uint32_t id,
   uint32_t *length
 );
+
+/**
+ * Get the quantifier of the query's captures. Each capture is * associated
+ * with a numeric id based on the order that it appeared in the query's source.
+ */
+TSQuantifier ts_query_capture_quantifier_for_id(
+  const TSQuery *,
+  uint32_t pattern_id,
+  uint32_t capture_id
+);
+
 const char *ts_query_string_value_for_id(
   const TSQuery *,
   uint32_t id,

```

-897,6 +915,33

```diff
 TSSymbolType ts_language_symbol_type(const TSLanguage *, TSSymbol);
  */
 uint32_t ts_language_version(const TSLanguage *);
 
+/**********************************/
+/* Section - Global Configuration */
+/**********************************/
+
+/**
+ * Set the allocation functions used by the library.
+ *
+ * By default, Tree-sitter uses the standard libc allocation functions,
+ * but aborts the process when an allocation fails. This function lets
+ * you supply alternative allocation functions at runtime.
+ * 
+ * If you pass `NULL` for any parameter, Tree-sitter will switch back to
+ * its default implementation of that function.
+ * 
+ * If you call this function after the library has already been used, then
+ * you must ensure that either:
+ *  1. All the existing objects have been freed.
+ *  2. The new allocator shares its state with the old one, so it is capable
+ *     of freeing memory that was allocated by the old allocator.
+ */
+void ts_set_allocator(
+  void *(*new_malloc)(size_t),
+	void *(*new_calloc)(size_t, size_t),
+	void *(*new_realloc)(void *, size_t),
+	void (*new_free)(void *)
+);
+
 #ifdef __cplusplus
 }
 #endif

```


### cli/src/tests/node_test.rs

No changes.

### cli/src/tests/tree_test.rs


```diff
diff --git a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/cli/src/tests/tree_test.rs b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/cli/src/tests/tree_test.rs
index db13ca3..d2b1eb8 100644
--- a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/cli/src/tests/tree_test.rs
+++ b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/cli/src/tests/tree_test.rs

```

-280,16 +280,16

```diff
 fn test_tree_cursor_child_for_point() {
     assert_eq!(c.node().kind(), "program");
 
     assert_eq!(c.goto_first_child_for_point(Point::new(7, 0)), None);
-    assert_eq!(c.goto_first_child_for_point(Point::new(6, 6)), None);
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 7)), None);
     assert_eq!(c.node().kind(), "program");
 
     // descend to expression statement
-    assert_eq!(c.goto_first_child_for_point(Point::new(6, 5)), Some(0));
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 6)), Some(0));
     assert_eq!(c.node().kind(), "expression_statement");
 
     // step into ';' and back up
     assert_eq!(c.goto_first_child_for_point(Point::new(7, 0)), None);
-    assert_eq!(c.goto_first_child_for_point(Point::new(6, 5)), Some(1));
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 6)), Some(1));
     assert_eq!(
         (c.node().kind(), c.node().start_position()),
         (";", Point::new(6, 5))

```

-312,7 +312,7

```diff
 fn test_tree_cursor_child_for_point() {
     assert!(c.goto_parent());
 
     // step into identifier 'one' and back up
-    assert_eq!(c.goto_first_child_for_point(Point::new(0, 5)), Some(1));
+    assert_eq!(c.goto_first_child_for_point(Point::new(1, 0)), Some(1));
     assert_eq!(
         (c.node().kind(), c.node().start_position()),
         ("identifier", Point::new(1, 8))

```

-326,7 +326,7

```diff
 fn test_tree_cursor_child_for_point() {
     assert!(c.goto_parent());
 
     // step into first ',' and back up
-    assert_eq!(c.goto_first_child_for_point(Point::new(1, 11)), Some(2));
+    assert_eq!(c.goto_first_child_for_point(Point::new(1, 12)), Some(2));
     assert_eq!(
         (c.node().kind(), c.node().start_position()),
         (",", Point::new(1, 11))

```

-334,7 +334,7

```diff
 fn test_tree_cursor_child_for_point() {
     assert!(c.goto_parent());
 
     // step into identifier 'four' and back up
-    assert_eq!(c.goto_first_child_for_point(Point::new(4, 10)), Some(5));
+    assert_eq!(c.goto_first_child_for_point(Point::new(5, 0)), Some(5));
     assert_eq!(
         (c.node().kind(), c.node().start_position()),
         ("identifier", Point::new(5, 8))

```

-354,7 +354,7

```diff
 fn test_tree_cursor_child_for_point() {
         ("]", Point::new(6, 4))
     );
     assert!(c.goto_parent());
-    assert_eq!(c.goto_first_child_for_point(Point::new(5, 23)), Some(10));
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 0)), Some(10));
     assert_eq!(
         (c.node().kind(), c.node().start_position()),
         ("]", Point::new(6, 4))

```


### cli/src/tests/query_test.rs


```diff
diff --git a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/cli/src/tests/query_test.rs b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/cli/src/tests/query_test.rs
index 9a1cd76..a9961b8 100644
--- a/gen/dev-tree-sitter-0.20.0/pull/tree-sitter-0.20.0/cli/src/tests/query_test.rs
+++ b/gen/dev-tree-sitter-0.20.6/pull/tree-sitter-0.20.6/cli/src/tests/query_test.rs

```

-1,9 +1,13

```diff

-use super::helpers::fixtures::get_language;
+use super::helpers::{
+    allocations,
+    fixtures::get_language,
+    query_helpers::{Match, Pattern},
+};
 use lazy_static::lazy_static;
-use std::env;
-use std::fmt::Write;
+use rand::{prelude::StdRng, SeedableRng};
+use std::{env, fmt::Write};
 use tree_sitter::{
-    allocations, Language, Node, Parser, Point, Query, QueryCapture, QueryCursor, QueryError,
+    CaptureQuantifier, Language, Node, Parser, Point, Query, QueryCapture, QueryCursor, QueryError,
     QueryErrorKind, QueryMatch, QueryPredicate, QueryPredicateArg, QueryProperty,
 };
 

```

-78,6 +82,7

```diff
 fn test_query_errors_on_invalid_syntax() {
             .join("\n")
         );
 
+        // Empty tree pattern
         assert_eq!(
             Query::new(language, r#"((identifier) ()"#)
                 .unwrap_err()

```

-88,6 +93,8

```diff
 fn test_query_errors_on_invalid_syntax() {
             ]
             .join("\n")
         );
+
+        // Empty alternation
         assert_eq!(
             Query::new(language, r#"((identifier) [])"#)
                 .unwrap_err()

```

-98,6 +105,8

```diff
 fn test_query_errors_on_invalid_syntax() {
             ]
             .join("\n")
         );
+
+        // Unclosed sibling expression with predicate
         assert_eq!(
             Query::new(language, r#"((identifier) (#a)"#)
                 .unwrap_err()

```

-108,6 +117,8

```diff
 fn test_query_errors_on_invalid_syntax() {
             ]
             .join("\n")
         );
+
+        // Unclosed predicate
         assert_eq!(
             Query::new(language, r#"((identifier) @x (#eq? @x a"#)
                 .unwrap_err()

```

-144,6 +155,7

```diff
 fn test_query_errors_on_invalid_syntax() {
             .join("\n")
         );
 
+        // Unclosed alternation within a tree
         // tree-sitter/tree-sitter/issues/968
         assert_eq!(
             Query::new(get_language("c"), r#"(parameter_list [ ")" @foo)"#)

```

-155,6 +167,22

```diff
 fn test_query_errors_on_invalid_syntax() {
             ]
             .join("\n")
         );
+
+        // Unclosed tree within an alternation
+        // tree-sitter/tree-sitter/issues/1436
+        assert_eq!(
+            Query::new(
+                get_language("python"),
+                r#"[(unary_operator (_) @operand) (not_operator (_) @operand]"#
+            )
+            .unwrap_err()
+            .message,
+            [
+                r#"[(unary_operator (_) @operand) (not_operator (_) @operand]"#,
+                r#"                                                         ^"#
+            ]
+            .join("\n")
+        );
     });
 }
 

```

-3063,6 +3091,53

```diff
 fn test_query_captures_with_matches_removed() {
     });
 }
 
+#[test]
+fn test_query_captures_with_matches_removed_before_they_finish() {
+    allocations::record(|| {
+        let language = get_language("javascript");
+        // When Tree-sitter detects that a pattern is guaranteed to match,
+        // it will start to eagerly return the captures that it has found,
+        // even though it hasn't matched the entire pattern yet. A
+        // namespace_import node always has "*", "as" and then an identifier
+        // for children, so captures will be emitted eagerly for this pattern.
+        let query = Query::new(
+            language,
+            r#"
+            (namespace_import
+              "*" @star
+              "as" @as
+              (identifier) @identifier)
+            "#,
+        )
+        .unwrap();
+
+        let source = "
+          import * as name from 'module-name';
+        ";
+
+        let mut parser = Parser::new();
+        parser.set_language(language).unwrap();
+        let tree = parser.parse(&source, None).unwrap();
+        let mut cursor = QueryCursor::new();
+
+        let mut captured_strings = Vec::new();
+        for (m, i) in cursor.captures(&query, tree.root_node(), source.as_bytes()) {
+            let capture = m.captures[i];
+            let text = capture.node.utf8_text(source.as_bytes()).unwrap();
+            if text == "as" {
+                m.remove();
+                continue;
+            }
+            captured_strings.push(text);
+        }
+
+        // .remove() removes the match before it is finished. The identifier
+        // "name" is part of this match, so we expect that removing the "as"
+        // capture from the match should prevent "name" from matching:
+        assert_eq!(captured_strings, &["*",]);
+    });
+}
+
 #[test]
 fn test_query_captures_and_matches_iterators_are_fused() {
     allocations::record(|| {

```

-3420,7 +3495,66

```diff
 fn test_query_alternative_predicate_prefix() {
 }
 
 #[test]
-fn test_query_step_is_definite() {
+fn test_query_random() {
+    use pretty_assertions::assert_eq;
+
+    allocations::record(|| {
+        let language = get_language("rust");
+        let mut parser = Parser::new();
+        parser.set_language(language).unwrap();
+        let mut cursor = QueryCursor::new();
+        cursor.set_match_limit(64);
+
+        let pattern_tree = parser
+            .parse(include_str!("helpers/query_helpers.rs"), None)
+            .unwrap();
+        let test_tree = parser
+            .parse(include_str!("helpers/query_helpers.rs"), None)
+            .unwrap();
+
+        // let start_seed = *SEED;
+        let start_seed = 0;
+
+        for i in 0..100 {
+            let seed = (start_seed + i) as u64;
+            let mut rand = StdRng::seed_from_u64(seed);
+            let (pattern_ast, _) = Pattern::random_pattern_in_tree(&pattern_tree, &mut rand);
+            let pattern = pattern_ast.to_string();
+            let expected_matches = pattern_ast.matches_in_tree(&test_tree);
+
+            let query = Query::new(language, &pattern).unwrap();
+            let mut actual_matches = cursor
+                .matches(
+                    &query,
+                    test_tree.root_node(),
+                    (include_str!("parser_test.rs")).as_bytes(),
+                )
+                .map(|mat| Match {
+                    last_node: None,
+                    captures: mat
+                        .captures
+                        .iter()
+                        .map(|c| (query.capture_names()[c.index as usize].as_str(), c.node))
+                        .collect::<Vec<_>>(),
+                })
+                .collect::<Vec<_>>();
+
+            // actual_matches.sort_unstable();
+            actual_matches.dedup();
+
+            if !cursor.did_exceed_match_limit() {
+                assert_eq!(
+                    actual_matches, expected_matches,
+                    "seed: {}, pattern:\n{}",
+                    seed, pattern
+                );
+            }
+        }
+    });
+}
+
+#[test]
+fn test_query_is_pattern_guaranteed_at_step() {
     struct Row {
         language: Language,
         description: &'static str,

```

-3430,19 +3564,19

```diff
 fn test_query_step_is_definite() {
 
     let rows = &[
         Row {
-            description: "no definite steps",
+            description: "no guaranteed steps",
             language: get_language("python"),
             pattern: r#"(expression_statement (string))"#,
             results_by_substring: &[("expression_statement", false), ("string", false)],
         },
         Row {
-            description: "all definite steps",
+            description: "all guaranteed steps",
             language: get_language("javascript"),
             pattern: r#"(object "{" "}")"#,
             results_by_substring: &[("object", false), ("{", true), ("}", true)],
         },
         Row {
-            description: "an indefinite step that is optional",
+            description: "a fallible step that is optional",
             language: get_language("javascript"),
             pattern: r#"(object "{" (identifier)? @foo "}")"#,
             results_by_substring: &[

```

-3453,7 +3587,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "multiple indefinite steps that are optional",
+            description: "multiple fallible steps that are optional",
             language: get_language("javascript"),
             pattern: r#"(object "{" (identifier)? @id1 ("," (identifier) @id2)? "}")"#,
             results_by_substring: &[

```

-3465,13 +3599,13

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "definite step after indefinite step",
+            description: "guaranteed step after fallibe step",
             language: get_language("javascript"),
             pattern: r#"(pair (property_identifier) ":")"#,
             results_by_substring: &[("pair", false), ("property_identifier", false), (":", true)],
         },
         Row {
-            description: "indefinite step in between two definite steps",
+            description: "fallible step in between two guaranteed steps",
             language: get_language("javascript"),
             pattern: r#"(ternary_expression
                 condition: (_)

```

-3488,13 +3622,13

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "one definite step after a repetition",
+            description: "one guaranteed step after a repetition",
             language: get_language("javascript"),
             pattern: r#"(object "{" (_) "}")"#,
             results_by_substring: &[("object", false), ("{", false), ("(_)", false), ("}", true)],
         },
         Row {
-            description: "definite steps after multiple repetitions",
+            description: "guaranteed steps after multiple repetitions",
             language: get_language("json"),
             pattern: r#"(object "{" (pair) "," (pair) "," (_) "}")"#,
             results_by_substring: &[

```

-3508,7 +3642,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "a definite with a field",
+            description: "a guaranteed step with a field",
             language: get_language("javascript"),
             pattern: r#"(binary_expression left: (identifier) right: (_))"#,
             results_by_substring: &[

```

-3518,7 +3652,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "multiple definite steps with fields",
+            description: "multiple guaranteed steps with fields",
             language: get_language("javascript"),
             pattern: r#"(function_declaration name: (identifier) body: (statement_block))"#,
             results_by_substring: &[

```

-3528,7 +3662,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "nesting, one definite step",
+            description: "nesting, one guaranteed step",
             language: get_language("javascript"),
             pattern: r#"
                 (function_declaration

```

-3544,7 +3678,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "definite step after some deeply nested hidden nodes",
+            description: "a guaranteed step after some deeply nested hidden nodes",
             language: get_language("ruby"),
             pattern: r#"
             (singleton_class

```

-3558,7 +3692,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "nesting, no definite steps",
+            description: "nesting, no guaranteed steps",
             language: get_language("javascript"),
             pattern: r#"
             (call_expression

```

-3569,7 +3703,7

```diff
 fn test_query_step_is_definite() {
             results_by_substring: &[("property_identifier", false), ("template_string", false)],
         },
         Row {
-            description: "a definite step after a nested node",
+            description: "a guaranteed step after a nested node",
             language: get_language("javascript"),
             pattern: r#"
             (subscript_expression

```

-3585,7 +3719,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "a step that is indefinite due to a predicate",
+            description: "a step that is fallible due to a predicate",
             language: get_language("javascript"),
             pattern: r#"
             (subscript_expression

```

-3602,7 +3736,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "alternation where one branch has definite steps",
+            description: "alternation where one branch has guaranteed steps",
             language: get_language("javascript"),
             pattern: r#"
             [

```

-3621,7 +3755,7

```diff
 fn test_query_step_is_definite() {
             ],
         },
         Row {
-            description: "aliased parent node",
+            description: "guaranteed step at the end of an aliased parent node",
             language: get_language("ruby"),
             pattern: r#"
             (method_parameters "(" (identifier) @id")")

```

-3676,6 +3810,21

```diff
 fn test_query_step_is_definite() {
                 ("(heredoc_end)", true),
             ],
         },
+        Row {
+            description: "multiple extra nodes",
+            language: get_language("rust"),
+            pattern: r#"
+            (call_expression
+                (line_comment) @a
+                (line_comment) @b
+                (arguments))
+            "#,
+            results_by_substring: &[
+                ("(line_comment) @a", false),
+                ("(line_comment) @b", false),
+                ("(arguments)", true),
+            ],
+        },
     ];
 
     allocations::record(|| {

```

-3692,7 +3841,7

```diff
 fn test_query_step_is_definite() {
             for (substring, is_definite) in row.results_by_substring {
                 let offset = row.pattern.find(substring).unwrap();
                 assert_eq!(
-                    query.step_is_definite(offset),
+                    query.is_pattern_guaranteed_at_step(offset),
                     *is_definite,
                     "Description: {}, Pattern: {:?}, substring: {:?}, expected is_definite to be {}",
                     row.description,

```

-3708,6 +3857,243

```diff
 fn test_query_step_is_definite() {
     });
 }
 
+#[test]
+fn test_capture_quantifiers() {
+    struct Row {
+        description: &'static str,
+        language: Language,
+        pattern: &'static str,
+        capture_quantifiers: &'static [(usize, &'static str, CaptureQuantifier)],
+    }
+
+    let rows = &[
+        // Simple quantifiers
+        Row {
+            description: "Top level capture",
+            language: get_language("python"),
+            pattern: r#"
+                (module) @mod
+            "#,
+            capture_quantifiers: &[(0, "mod", CaptureQuantifier::One)],
+        },
+        Row {
+            description: "Nested list capture capture",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array (_)* @elems) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "elems", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        Row {
+            description: "Nested non-empty list capture capture",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array (_)+ @elems) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "elems", CaptureQuantifier::OneOrMore),
+            ],
+        },
+        // Nested quantifiers
+        Row {
+            description: "capture nested in optional pattern",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array (call_expression (arguments (_) @arg))? @call) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "call", CaptureQuantifier::ZeroOrOne),
+                (0, "arg", CaptureQuantifier::ZeroOrOne),
+            ],
+        },
+        Row {
+            description: "optional capture nested in non-empty list pattern",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array (call_expression (arguments (_)? @arg))+ @call) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "call", CaptureQuantifier::OneOrMore),
+                (0, "arg", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        Row {
+            description: "non-empty list capture nested in optional pattern",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array (call_expression (arguments (_)+ @args))? @call) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "call", CaptureQuantifier::ZeroOrOne),
+                (0, "args", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        // Quantifiers in alternations
+        Row {
+            description: "capture is the same in all alternatives",
+            language: get_language("javascript"),
+            pattern: r#"[
+                (function_declaration name:(identifier) @name)
+                (call_expression function:(identifier) @name)
+            ]"#,
+            capture_quantifiers: &[(0, "name", CaptureQuantifier::One)],
+        },
+        Row {
+            description: "capture appears in some alternatives",
+            language: get_language("javascript"),
+            pattern: r#"[
+                (function_declaration name:(identifier) @name)
+                (function)
+            ] @fun"#,
+            capture_quantifiers: &[
+                (0, "fun", CaptureQuantifier::One),
+                (0, "name", CaptureQuantifier::ZeroOrOne),
+            ],
+        },
+        Row {
+            description: "capture has different quantifiers in alternatives",
+            language: get_language("javascript"),
+            pattern: r#"[
+                (call_expression arguments:(arguments (_)+ @args))
+                (new_expression  arguments:(arguments (_)? @args))
+            ] @call"#,
+            capture_quantifiers: &[
+                (0, "call", CaptureQuantifier::One),
+                (0, "args", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        // Quantifiers in siblings
+        Row {
+            description: "siblings have different captures with different quantifiers",
+            language: get_language("javascript"),
+            pattern: r#"
+                (call_expression (arguments (identifier)? @self (_)* @args)) @call
+            "#,
+            capture_quantifiers: &[
+                (0, "call", CaptureQuantifier::One),
+                (0, "self", CaptureQuantifier::ZeroOrOne),
+                (0, "args", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        Row {
+            description: "siblings have same capture with different quantifiers",
+            language: get_language("javascript"),
+            pattern: r#"
+                (call_expression (arguments (identifier) @args (_)* @args)) @call
+            "#,
+            capture_quantifiers: &[
+                (0, "call", CaptureQuantifier::One),
+                (0, "args", CaptureQuantifier::OneOrMore),
+            ],
+        },
+        // Combined scenarios
+        Row {
+            description: "combined nesting, alternatives, and siblings",
+            language: get_language("javascript"),
+            pattern: r#"
+                (array
+                    (call_expression
+                        (arguments [
+                            (identifier) @self
+                            (_)+ @args
+                        ])
+                    )+ @call
+                ) @array
+            "#,
+            capture_quantifiers: &[
+                (0, "array", CaptureQuantifier::One),
+                (0, "call", CaptureQuantifier::OneOrMore),
+                (0, "self", CaptureQuantifier::ZeroOrMore),
+                (0, "args", CaptureQuantifier::ZeroOrMore),
+            ],
+        },
+        // Multiple patterns
+        Row {
+            description: "multiple patterns",
+            language: get_language("javascript"),
+            pattern: r#"
+                (function_declaration name: (identifier) @x)
+                (statement_identifier) @y
+                (property_identifier)+ @z
+                (array (identifier)* @x)
+            "#,
+            capture_quantifiers: &[
+                // x
+                (0, "x", CaptureQuantifier::One),
+                (1, "x", CaptureQuantifier::Zero),
+                (2, "x", CaptureQuantifier::Zero),
+                (3, "x", CaptureQuantifier::ZeroOrMore),
+                // y
+                (0, "y", CaptureQuantifier::Zero),
+                (1, "y", CaptureQuantifier::One),
+                (2, "y", CaptureQuantifier::Zero),
+                (3, "y", CaptureQuantifier::Zero),
+                // z
+                (0, "z", CaptureQuantifier::Zero),
+                (1, "z", CaptureQuantifier::Zero),
+                (2, "z", CaptureQuantifier::OneOrMore),
+                (3, "z", CaptureQuantifier::Zero),
+            ],
+        },
+        Row {
+            description: "multiple alternatives",
+            language: get_language("javascript"),
+            pattern: r#"
+            [
+                (array (identifier) @x)
+                (function_declaration name: (identifier)+ @x)
+            ]
+            [
+                (array (identifier) @x)
+                (function_declaration name: (identifier)+ @x)
+            ]
+            "#,
+            capture_quantifiers: &[
+                (0, "x", CaptureQuantifier::OneOrMore),
+                (1, "x", CaptureQuantifier::OneOrMore),
+            ],
+        },
+    ];
+
+    allocations::record(|| {
+        eprintln!("");
+
+        for row in rows.iter() {
+            if let Some(filter) = EXAMPLE_FILTER.as_ref() {
+                if !row.description.contains(filter.as_str()) {
+                    continue;
+                }
+            }
+            eprintln!("  query example: {:?}", row.description);
+            let query = Query::new(row.language, row.pattern).unwrap();
+            for (pattern, capture, expected_quantifier) in row.capture_quantifiers {
+                let index = query.capture_index_for_name(capture).unwrap();
+                let actual_quantifier = query.capture_quantifiers(*pattern)[index as usize];
+                assert_eq!(
+                    actual_quantifier,
+                    *expected_quantifier,
+                    "Description: {}, Pattern: {:?}, expected quantifier of @{} to be {:?} instead of {:?}",
+                    row.description,
+                    row.pattern
+                        .split_ascii_whitespace()
+                        .collect::<Vec<_>>()
+                        .join(" "),
+                    capture,
+                    *expected_quantifier,
+                    actual_quantifier,
+                )
+            }
+        }
+    });
+}
+
 fn assert_query_matches(
     language: Language,
     query: &Query,

```
