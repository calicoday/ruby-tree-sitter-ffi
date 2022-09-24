### Notes on how first

1. Prepare a difference report comparing the earlier repo to later one on these sections 

- `lib/include`
  - `api.h`
  - (glance at `parser.h` language lexing/symbol stuff)
- `cli/src/tests`
  - `node_test.rs`, `tree_test.rs`, `query_test.rs` for common patterns, then file-specific
  - (glance at other `src/tests` and `src/ diffs` for changes in approach/coding style/utilities)
- `lib/binding_rust`
  - (glance at `lib.rs` for changes in conv/idio methods; `bindings.rs` ought to show differences in Rust corresponding to the C api.h changes)


git diff --no-index --word-diff old_file.txt new_file.txt




### Difference Report tree-sitter-0.20.0 to tree-sitter-0.20.6

#### `lib/include`

##### In `api.h`

| 0.20.0 | 0.20.6 |
|---|---|
|`ts_query_step_is_definite`| `ts_query_is_pattern_guaranteed_at_step`|

blahblah

<table><tr><th></th><th>0.20.0</th><th></th><th>0.20.6</th></tr>
<tr>
  <td>
  
```
bool ts_query_step_is_definite(
  const TSQuery *self,
  uint32_t byte_offset
);
```
  </td>
  <td>
  
```
bool ts_query_is_pattern_guaranteed_at_step(
  const TSQuery *self,
  uint32_t byte_offset
);
```
  </td>
</tr>
<tr>
</tr>
</table>

diff-style

```diff
- bool ts_query_step_is_definite(
-   const TSQuery *self,
-   uint32_t byte_offset
- );
+ bool ts_query_is_pattern_guaranteed_at_step(
+   const TSQuery *self,
+   uint32_t byte_offset
+ );
```

all together now

<table><tr><th>0.20.0</th><th>0.20.6</th></tr>
<tr>
  <td>
  
```diff
- bool ts_query_step_is_definite(
    const TSQuery *self,
    uint32_t byte_offset
  );
```
  </td>
  <td>
  
```diff
+ bool ts_query_is_pattern_guaranteed_at_step(
    const TSQuery *self,
    uint32_t byte_offset
  );
```
  </td>
</tr>
<tr>
</tr>
</table>




<table><tr><th>0.20.0</th><th>0.20.6</th></tr>
<tr>
  <td>
```
```
  </td>
  <td>
```
```
  </td>
</tr>
<tr>
  <td>
  </td>
  <td>
  </td>
</tr>
</table>

yadayada

```
bool ts_query_step_is_definite(
  const TSQuery *self,
  uint32_t byte_offset
);
```


bool ts_query_is_pattern_guaranteed_at_step(
  const TSQuery *self,
  uint32_t byte_offset
);

#### `cli/src/tests`



git diff

```diff
diff --git a/tree-sitter-0.20.0/lib/include/tree_sitter/api.h b/tree-sitter-0.20.6/lib/include/tree_sitter/api.h
index f02789e..1ace7be 100644
--- a/tree-sitter-0.20.0/lib/include/tree_sitter/api.h
+++ b/tree-sitter-0.20.6/lib/include/tree_sitter/api.h
@@ -21,7 +21,7 @@ extern "C" {
  * The Tree-sitter library is generally backwards-compatible with languages
  * generated using older CLI versions, but is not forwards-compatible.
  */
-#define TREE_SITTER_LANGUAGE_VERSION 13
+#define TREE_SITTER_LANGUAGE_VERSION 14
 
 /**
  * The earliest ABI version that is supported by the current version of the
@@ -106,6 +106,14 @@ typedef struct {
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
@@ -131,6 +139,7 @@ typedef enum {
   TSQueryErrorField,
   TSQueryErrorCapture,
   TSQueryErrorStructure,
+  TSQueryErrorLanguage,
 } TSQueryError;
 
 /********************/
@@ -179,9 +188,7 @@ const TSLanguage *ts_parser_language(const TSParser *self);
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
@@ -618,7 +625,7 @@ TSNode ts_tree_cursor_current_node(const TSTreeCursor *);
 const char *ts_tree_cursor_current_field_name(const TSTreeCursor *);
 
 /**
- * Get the field name of the tree cursor's current node.
+ * Get the field id of the tree cursor's current node.
  *
  * This returns zero if the current node doesn't have a field.
  * See also `ts_node_child_by_field_id`, `ts_language_field_id_for_name`.
@@ -726,7 +733,7 @@ const TSQueryPredicateStep *ts_query_predicates_for_pattern(
   uint32_t *length
 );
 
-bool ts_query_step_is_definite(
+bool ts_query_is_pattern_guaranteed_at_step(
   const TSQuery *self,
   uint32_t byte_offset
 );
@@ -741,6 +748,17 @@ const char *ts_query_capture_name_for_id(
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
@@ -897,6 +915,33 @@ TSSymbolType ts_language_symbol_type(const TSLanguage *, TSSymbol);
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
