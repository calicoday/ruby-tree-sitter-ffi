## Upgrade plan 0.20.0 to 0.20.6 (Reduced)

Status codes:
- `ok`, accounted for, no further action needed
- `auto`, not relevant to generating scripts or their output,  no action needed. Eg comments
- `api`, change in functions or types
- `test`, change in test data, results with be different
- `script`, affects generating scripts parsing

Notes
- git diff context is misleading: first line is (prob) the nearest enclosing expression, the line number is the line of the first of 3 lines immediately preceding the change. [put '...' between first line and context, add CHANGE line numbers]
- to get syntax highlighted block in HTML table cell, use `<pre lang="diff">...</pre>`
- copy-paste from displayed diff to table cell has spacing errors
- [add '  <br/>' to table cell for easier copy-replace]
- [drop dummy row in reduced tables]

### lib/include/tree_sitter/api.h

<table>
<tr><th>Location(s)</th><th>[Status] Notes</th></tr>
<tr>
<td>
-106,6 +106,14
</td>
<td>
[api] Added enum `TSQuantifier`
</td>
</tr>

<tr>
<td>
-131,6 +139,7
</td>
<td>
[api] Added member `TSQueryErrorLanguage` in enum `TSQueryError`
</td>
</tr>

<tr>
<td>
-726,7 +733,7
</td>
<td>
[api] Renamed function
<pre lang="diff">
-bool ts_query_step_is_definite(
+bool ts_query_is_pattern_guaranteed_at_step(
   const TSQuery *self,
   uint32_t byte_offset
 );
</pre>
</td>
</tr>

<tr>
<td>
-741,6 +748,17
</td>
<td>
[api] Added function
<pre lang="diff">
+TSQuantifier ts_query_capture_quantifier_for_id(
+  const TSQuery *,
+  uint32_t pattern_id,
+  uint32_t capture_id
+);
</pre>
</td>
</tr>

<tr>
<td>
-897,6 +915,33
</td>
<td>
[api] Added function
<pre lang="diff">
+void ts_set_allocator(
+  void *(*new_malloc)(size_t),
+	void *(*new_calloc)(size_t, size_t),
+	void *(*new_realloc)(void *, size_t),
+	void (*new_free)(void *)
+);
</pre>
</td>
</tr>

</table>



### cli/src/tests/tree_test.rs

<table>
<tr><th>Location(s)</th><th>[Status] Notes</th></tr>
<tr>
<td>
-280,16 +280,16
</td>
<td>
[test] Changed arg values (x7)
<pre lang="diff">
-    assert_eq!(c.goto_first_child_for_point(Point::new(6, 6)), None);
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 7)), None);
</pre>
</td>
</tr>

</table>



### cli/src/tests/query_test.rs

<table>
<tr><th>Location(s)</th><th>[Status] Notes</th></tr>
<tr>
<td>
-155,6 +167,22
</td>
<td>
[test] Added assert
<pre lang="diff>
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
</pre>
</td>
</tr>

<tr>
<td>
-3063,6 +3091,53
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_query_captures_with_matches_removed_before_they_finish() {
...
</pre>
</td>
</tr>

<tr>
<td>
-3420,7 +3495,66
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_query_random() {
...
</pre>
</td>
</tr>

<tr>
<td>
-3708,6 +3857,243
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_capture_quantifiers() {
...
</pre>
</td>
</tr>

</table>

## Upgrade plan 0.20.0 to 0.20.6


### lib/include/tree_sitter/api.h

<table>
<tr><th>Location</th><th>[Status] Notes</th></tr>
<tr>
<td>
-21,7 +21,7
</td>
<td>
[auto] Constant value change
</td>
</tr>

<tr>
<td>
-106,6 +106,14
</td>
<td>
[api] Added enum `TSQuantifier`
</td>
</tr>

<tr>
<td>
-131,6 +139,7
</td>
<td>
[api] Added member `TSQueryErrorLanguage` in enum `TSQueryError`
</td>
</tr>

<tr>
<td>
-179,9 +188,7
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-618,7 +625,7
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-726,7 +733,7
</td>
<td>
[api] Renamed function
<pre lang="diff">
-bool ts_query_step_is_definite(
+bool ts_query_is_pattern_guaranteed_at_step(
   const TSQuery *self,
   uint32_t byte_offset
 );
</pre>
</td>
</tr>

<tr>
<td>
-741,6 +748,17
</td>
<td>
[api] Added function
<pre lang="diff">
+TSQuantifier ts_query_capture_quantifier_for_id(
+  const TSQuery *,
+  uint32_t pattern_id,
+  uint32_t capture_id
+);
</pre>
</td>
</tr>

<tr>
<td>
-897,6 +915,33
</td>
<td>
[api] Added function
<pre lang="diff">
+void ts_set_allocator(
+  void *(*new_malloc)(size_t),
+	void *(*new_calloc)(size_t, size_t),
+	void *(*new_realloc)(void *, size_t),
+	void (*new_free)(void *)
+);
</pre>
</td>
</tr>

</table>




### cli/src/tests/node_test.rs

No changes.


### cli/src/tests/tree_test.rs

<table>
<tr><th>Location</th><th>[Status] Notes</th></tr>
<tr>
<td>
-280,16 +280,16
</td>
<td>
[test] Changed arg values (x3)
<pre lang="diff">
-    assert_eq!(c.goto_first_child_for_point(Point::new(6, 6)), None);
+    assert_eq!(c.goto_first_child_for_point(Point::new(6, 7)), None);
</pre>
</td>
</tr>

<tr>
<td>
-312,7 +312,7
</td>
<td>
[test] Same as -280,16 +280,16 (x1)
</td>
</tr>

<tr>
<td>
-326,7 +326,7
</td>
<td>
[test] Same as -280,16 +280,16 (x1)
</td>
</tr>

<tr>
<td>
-334,7 +334,7
</td>
<td>
[test] Same as -280,16 +280,16 (x1)
</td>
</tr>

<tr>
<td>
-354,7 +354,7
</td>
<td>
[test] Same as -280,16 +280,16 (x1)
</td>
</tr>

</table>




### cli/src/tests/query_test.rs

<table>
<tr><th>Location</th><th>[Status] Notes</th></tr>
<tr>
<td>
-1,9 +1,13
</td>
<td>
[auto] Changes to Rust set up
</td>
</tr>

<tr>
<td>
-78,6 +82,7
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-88,6 +93,8
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-98,6 +105,8
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-108,6 +117,8
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-144,6 +155,7
</td>
<td>
[auto] Comment
</td>
</tr>

<tr>
<td>
-155,6 +167,22
</td>
<td>
[test] Added assert
<pre lang="diff>
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
</pre>
</td>
</tr>

<tr>
<td>
-3063,6 +3091,53
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_query_captures_with_matches_removed_before_they_finish() {
...
</pre>
[auto] Renamed test
<pre lang="diff">
-fn test_query_step_is_definite() {
+fn test_query_is_pattern_guaranteed_at_step() {
</pre>
</td>
</tr>

<tr>
<td>
-3420,7 +3495,66
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_query_random() {
...
</pre>
</td>
</tr>

<tr>
<td>
-3430,19 +3564,19
</td>
<td>
[auto] Changes to test data descriptions
</td>
</tr>

<tr>
<td>
-3453,7 +3587,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3465,13 +3599,13
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3488,13 +3622,13
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3508,7 +3642,7
</td>
<td>

</td>
</tr>

<tr>
<td>
-3518,7 +3652,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3528,7 +3662,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3544,7 +3678,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3558,7 +3692,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3569,7 +3703,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3585,7 +3719,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3602,7 +3736,7
</td>
<td>
[auto] Same as -3430,19 +3564,19
</td>
</tr>

<tr>
<td>
-3621,7 +3755,7
</td>
<td>

</td>
</tr>
[auto] Same as -3430,19 +3564,19
<tr>
<td>
-3676,6 +3810,21
</td>
<td>
[auto] Added test data
</td>
</tr>

<tr>
<td>
-3692,7 +3841,7
</td>
<td>
[auto] Call renamed test
<pre lang="diff">
-                    query.step_is_definite(offset),
+                    query.is_pattern_guaranteed_at_step(offset),
</pre>
</td>
</tr>

<tr>
<td>
-3708,6 +3857,243
</td>
<td>
[test] Added test
<pre lang="diff">
+fn test_capture_quantifiers() {
...
</pre>
</td>
</tr>

</table>


