// lib/binding_rust/lib.rs
// extract (impl\s*[\w<>':: ]+\s+{|^[\t ]*((pub )?(fn|struct|enum) [^{\n]+)|^[^}\n]*ffi::\w+) to \1
// => catch cladef plus struct, enum and any ffi::, eg ffi::ts_language_version

use std::ffi::CStr
pub const LANGUAGE_VERSION: usize = ffi::TREE_SITTER_LANGUAGE_VERSION
pub const MIN_COMPATIBLE_LANGUAGE_VERSION: usize = ffi::TREE_SITTER_MIN_COMPATIBLE_LANGUAGE_VERSION
pub struct Language(*const ffi::TSLanguage);
pub struct Tree(NonNull<ffi::TSTree>);
pub struct Point 
pub struct Range 
pub struct InputEdit 
pub struct Node<'a>(ffi::TSNode, PhantomData<&'a ()>);
pub struct Parser(NonNull<ffi::TSParser>);
pub enum LogType 
pub struct TreeCursor<'a>(ffi::TSTreeCursor, PhantomData<&'a ()>);
pub struct Query 
    ptr: NonNull<ffi::TSQuery
pub struct QueryCursor(NonNull<ffi::TSQueryCursor>);
pub struct QueryProperty 
pub enum QueryPredicateArg 
pub struct QueryPredicate 
pub struct QueryMatch<'a> 
    cursor: *mut ffi::TSQueryCursor
pub struct QueryCaptures<'a, 'tree: 'a, T: AsRef<[u8]>> 
    ptr: *mut ffi::TSQueryCursor
pub struct QueryCapture<'a> 
pub struct LanguageError 
pub struct IncludedRangesError(pub usize);
pub struct QueryError 
pub enum QueryErrorKind 
enum TextPredicate 
pub struct LossyUtf8<'a> 
impl Language {
    pub fn version(&self) -> usize 
        unsafe { ffi::ts_language_version
    pub fn node_kind_count(&self) -> usize 
        unsafe { ffi::ts_language_symbol_count
    pub fn node_kind_for_id(&self, id: u16) -> Option<&'static str> 
        let ptr = unsafe { ffi::ts_language_symbol_name
    pub fn id_for_node_kind(&self, kind: &str, named: bool) -> u16 
            ffi::ts_language_symbol_for_name
    pub fn node_kind_is_named(&self, id: u16) -> bool 
        unsafe { ffi::ts_language_symbol_type(self.0, id) == ffi::TSSymbolType_TSSymbolTypeRegular
    pub fn node_kind_is_visible(&self, id: u16) -> bool 
            ffi::ts_language_symbol_type(self.0, id) <= ffi::TSSymbolType_TSSymbolTypeAnonymous
    pub fn field_count(&self) -> usize 
        unsafe { ffi::ts_language_field_count
    pub fn field_name_for_id(&self, field_id: u16) -> Option<&'static str> 
        let ptr = unsafe { ffi::ts_language_field_name_for_id
    pub fn field_id_for_name(&self, field_name: impl AsRef<[u8]>) -> Option<u16> 
            ffi::ts_language_field_id_for_name
impl Parser {
    pub fn new() -> Parser 
            let parser = ffi::ts_parser_new
    pub fn set_language(&mut self, language: Language) -> Result<(), LanguageError> 
                ffi::ts_parser_set_language
    pub fn language(&self) -> Option<Language> 
        let ptr = unsafe { ffi::ts_parser_language
    pub fn logger(&self) -> Option<&Logger> 
        let logger = unsafe { ffi::ts_parser_logger
    pub fn set_logger(&mut self, logger: Option<Logger>) 
        let prev_logger = unsafe { ffi::ts_parser_logger
                c_log_type: ffi::TSLogType
                    let log_type = if c_log_type == ffi::TSLogType_TSLogTypeParse
            c_logger = ffi::TSLogger
            c_logger = ffi::TSLogger
        unsafe { ffi::ts_parser_set_logger
    pub fn print_dot_graphs(&mut self, file: &impl AsRawFd) 
        unsafe { ffi::ts_parser_print_dot_graphs(self.0.as_ptr(), ffi::dup
    pub fn stop_printing_dot_graphs(&mut self) 
        unsafe { ffi::ts_parser_print_dot_graphs
    pub fn parse(&mut self, text: impl AsRef<[u8]>, old_tree: Option<&Tree>) -> Option<Tree> 
    pub fn parse_utf16(
    pub fn parse_with<'a, T: AsRef<[u8]>, F: FnMut(usize, Point) -> T>(
            position: ffi::TSPoint
        let c_input = ffi::TSInput
            encoding: ffi::TSInputEncoding_TSInputEncodingUTF8
            let c_new_tree = ffi::ts_parser_parse
    pub fn parse_utf16_with<'a, T: AsRef<[u16]>, F: FnMut(usize, Point) -> T>(
            position: ffi::TSPoint
        let c_input = ffi::TSInput
            encoding: ffi::TSInputEncoding_TSInputEncodingUTF16
            let c_new_tree = ffi::ts_parser_parse
    pub fn reset(&mut self) 
        unsafe { ffi::ts_parser_reset
    pub fn timeout_micros(&self) -> u64 
        unsafe { ffi::ts_parser_timeout_micros
    pub fn set_timeout_micros(&mut self, timeout_micros: u64) 
        unsafe { ffi::ts_parser_set_timeout_micros
    pub fn set_included_ranges<'a>(
        let ts_ranges: Vec<ffi::TSRange
            ffi::ts_parser_set_included_ranges
        (ffi::ts_parser_cancellation_flag
            ffi::ts_parser_set_cancellation_flag
            ffi::ts_parser_set_cancellation_flag
impl Drop for Parser {
    fn drop(&mut self) 
        unsafe { ffi::ts_parser_delete
impl Tree {
    pub fn root_node(&self) -> Node 
        Node::new(unsafe { ffi::ts_tree_root_node
    pub fn language(&self) -> Language 
        Language(unsafe { ffi::ts_tree_language
    pub fn edit(&mut self, edit: &InputEdit) 
        unsafe { ffi::ts_tree_edit
    pub fn walk(&self) -> TreeCursor 
    pub fn changed_ranges(&self, other: &Tree) -> impl ExactSizeIterator<Item = Range> 
            let ptr = ffi::ts_tree_get_changed_ranges
impl fmt::Debug for Tree {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> 
impl Drop for Tree {
    fn drop(&mut self) 
        unsafe { ffi::ts_tree_delete
impl Clone for Tree {
    fn clone(&self) -> Tree 
        unsafe { Tree(NonNull::new_unchecked(ffi::ts_tree_copy
impl<'tree> Node<'tree> {
    fn new(node: ffi::TSNode) -> Option<Self> 
    pub fn id(&self) -> usize 
    pub fn kind_id(&self) -> u16 
        unsafe { ffi::ts_node_symbol
    pub fn kind(&self) -> &'static str 
        unsafe { CStr::from_ptr(ffi::ts_node_type
    pub fn language(&self) -> Language 
        Language(unsafe { ffi::ts_tree_language
    pub fn is_named(&self) -> bool 
        unsafe { ffi::ts_node_is_named
    pub fn is_extra(&self) -> bool 
        unsafe { ffi::ts_node_is_extra
    pub fn has_changes(&self) -> bool 
        unsafe { ffi::ts_node_has_changes
    pub fn has_error(&self) -> bool 
        unsafe { ffi::ts_node_has_error
    pub fn is_error(&self) -> bool 
    pub fn is_missing(&self) -> bool 
        unsafe { ffi::ts_node_is_missing
    pub fn start_byte(&self) -> usize 
        unsafe { ffi::ts_node_start_byte
    pub fn end_byte(&self) -> usize 
        unsafe { ffi::ts_node_end_byte
    pub fn byte_range(&self) -> std::ops::Range<usize> 
    pub fn range(&self) -> Range 
    pub fn start_position(&self) -> Point 
        let result = unsafe { ffi::ts_node_start_point
    pub fn end_position(&self) -> Point 
        let result = unsafe { ffi::ts_node_end_point
    pub fn child(&self, i: usize) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_child
    pub fn child_count(&self) -> usize 
        unsafe { ffi::ts_node_child_count
    pub fn named_child<'a>(&'a self, i: usize) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_named_child
    pub fn named_child_count(&self) -> usize 
        unsafe { ffi::ts_node_named_child_count
    pub fn child_by_field_name(&self, field_name: impl AsRef<[u8]>) -> Option<Self> 
            ffi::ts_node_child_by_field_name
    pub fn child_by_field_id(&self, field_id: u16) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_child_by_field_id
    pub fn children<'a>(
    pub fn named_children<'a>(
    pub fn children_by_field_name<'a>(
    pub fn children_by_field_id<'a>(
    pub fn parent(&self) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_parent
    pub fn next_sibling(&self) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_next_sibling
    pub fn prev_sibling(&self) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_prev_sibling
    pub fn next_named_sibling(&self) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_next_named_sibling
    pub fn prev_named_sibling(&self) -> Option<Self> 
        Self::new(unsafe { ffi::ts_node_prev_named_sibling
    pub fn descendant_for_byte_range(&self, start: usize, end: usize) -> Option<Self> 
            ffi::ts_node_descendant_for_byte_range
    pub fn named_descendant_for_byte_range(&self, start: usize, end: usize) -> Option<Self> 
            ffi::ts_node_named_descendant_for_byte_range
    pub fn descendant_for_point_range(&self, start: Point, end: Point) -> Option<Self> 
            ffi::ts_node_descendant_for_point_range
    pub fn named_descendant_for_point_range(&self, start: Point, end: Point) -> Option<Self> 
            ffi::ts_node_named_descendant_for_point_range
    pub fn to_sexp(&self) -> String 
        let c_string = unsafe { ffi::ts_node_string
    pub fn utf8_text<'a>(&self, source: &'a [u8]) -> Result<&'a str, str::Utf8Error> 
    pub fn utf16_text<'a>(&self, source: &'a [u16]) -> &'a [u16] 
    pub fn walk(&self) -> TreeCursor<'tree> 
        TreeCursor(unsafe { ffi::ts_tree_cursor_new
    pub fn edit(&mut self, edit: &InputEdit) 
        unsafe { ffi::ts_node_edit(&mut self.0 as *mut ffi::TSNode
impl<'a> PartialEq for Node<'a> {
    fn eq(&self, other: &Self) -> bool 
impl<'a> Eq for Node<'a> {
impl<'a> hash::Hash for Node<'a> {
    fn hash<H: hash::Hasher>(&self, state: &mut H) 
impl<'a> fmt::Debug for Node<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> 
impl<'a> TreeCursor<'a> {
    pub fn node(&self) -> Node<'a> 
            unsafe { ffi::ts_tree_cursor_current_node
    pub fn field_id(&self) -> Option<u16> 
            let id = ffi::ts_tree_cursor_current_field_id
    pub fn field_name(&self) -> Option<&'static str> 
            let ptr = ffi::ts_tree_cursor_current_field_name
    pub fn goto_first_child(&mut self) -> bool 
        return unsafe { ffi::ts_tree_cursor_goto_first_child
    pub fn goto_parent(&mut self) -> bool 
        return unsafe { ffi::ts_tree_cursor_goto_parent
    pub fn goto_next_sibling(&mut self) -> bool 
        return unsafe { ffi::ts_tree_cursor_goto_next_sibling
    pub fn goto_first_child_for_byte(&mut self, index: usize) -> Option<usize> 
            unsafe { ffi::ts_tree_cursor_goto_first_child_for_byte
    pub fn reset(&mut self, node: Node<'a>) 
        unsafe { ffi::ts_tree_cursor_reset
impl<'a> Clone for TreeCursor<'a> {
    fn clone(&self) -> Self 
        TreeCursor(unsafe { ffi::ts_tree_cursor_copy
impl<'a> Drop for TreeCursor<'a> {
    fn drop(&mut self) 
        unsafe { ffi::ts_tree_cursor_delete
impl Query {
    pub fn new(language: Language, source: &str) -> Result<Self, QueryError> 
        let mut error_type: ffi::TSQueryError
            ffi::ts_query_new
                &mut error_type as *mut ffi::TSQueryError
                ffi::TSQueryError_TSQueryErrorNodeType
                | ffi::TSQueryError_TSQueryErrorField
                | ffi::TSQueryError_TSQueryErrorCapture
                        ffi::TSQueryError_TSQueryErrorNodeType
                        ffi::TSQueryError_TSQueryErrorField
                        ffi::TSQueryError_TSQueryErrorCapture
                        ffi::TSQueryError_TSQueryErrorStructure
        let string_count = unsafe { ffi::ts_query_string_count
        let capture_count = unsafe { ffi::ts_query_capture_count
        let pattern_count = unsafe { ffi::ts_query_pattern_count
                    ffi::ts_query_capture_name_for_id
                    ffi::ts_query_string_value_for_id
                    ffi::ts_query_predicates_for_pattern
            let byte_offset = unsafe { ffi::ts_query_start_byte_for_pattern
            let type_done = ffi::TSQueryPredicateStepType_TSQueryPredicateStepTypeDone
            let type_capture = ffi::TSQueryPredicateStepType_TSQueryPredicateStepTypeCapture
            let type_string = ffi::TSQueryPredicateStepType_TSQueryPredicateStepTypeString
    pub fn start_byte_for_pattern(&self, pattern_index: usize) -> usize 
            ffi::ts_query_start_byte_for_pattern
    pub fn pattern_count(&self) -> usize 
        unsafe { ffi::ts_query_pattern_count
    pub fn capture_names(&self) -> &[String] 
    pub fn property_predicates(&self, index: usize) -> &[(QueryProperty, bool)] 
    pub fn property_settings(&self, index: usize) -> &[QueryProperty] 
    pub fn general_predicates(&self, index: usize) -> &[QueryPredicate] 
    pub fn disable_capture(&mut self, name: &str) 
            ffi::ts_query_disable_capture
    pub fn disable_pattern(&mut self, index: usize) 
        unsafe { ffi::ts_query_disable_pattern
    pub fn step_is_definite(&self, byte_offset: usize) -> bool 
        unsafe { ffi::ts_query_step_is_definite
    fn parse_property(
        args: &[ffi::TSQueryPredicateStep
            if arg.type_ == ffi::TSQueryPredicateStepType_TSQueryPredicateStepTypeCapture
impl<'a> QueryCursor {
    pub fn new() -> Self 
        QueryCursor(unsafe { NonNull::new_unchecked(ffi::ts_query_cursor_new
    pub fn did_exceed_match_limit(&self) -> bool 
        unsafe { ffi::ts_query_cursor_did_exceed_match_limit
    pub fn matches<'tree: 'a, T: AsRef<[u8]>>(
        unsafe { ffi::ts_query_cursor_exec
                let mut m = MaybeUninit::<ffi::TSQueryMatch
                if ffi::ts_query_cursor_next_match
    pub fn captures<'tree, T: AsRef<[u8]>>(
        unsafe { ffi::ts_query_cursor_exec
    pub fn set_byte_range(&mut self, start: usize, end: usize) -> &mut Self 
            ffi::ts_query_cursor_set_byte_range
    pub fn set_point_range(&mut self, start: Point, end: Point) -> &mut Self 
            ffi::ts_query_cursor_set_point_range
impl<'a> QueryMatch<'a> {
    pub fn remove(self) 
        unsafe { ffi::ts_query_cursor_remove_match
    fn new(m: ffi::TSQueryMatch, cursor: *mut ffi::TSQueryCursor) -> Self 
    fn satisfies_text_predicates<T: AsRef<[u8]>>(
    fn capture_for_index(&self, capture_index: u32) -> Option<Node<'a>> 
impl QueryProperty {
    pub fn new(key: &str, value: Option<&str>, capture_id: Option<usize>) -> Self 
    fn next(&mut self) -> Option<Self::Item> 
                let mut m = MaybeUninit::<ffi::TSQueryMatch
                if ffi::ts_query_cursor_next_capture
impl<'a> fmt::Debug for QueryMatch<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result 
impl PartialEq for Query {
    fn eq(&self, other: &Self) -> bool 
impl Drop for Query {
    fn drop(&mut self) 
        unsafe { ffi::ts_query_delete
impl Drop for QueryCursor {
    fn drop(&mut self) 
        unsafe { ffi::ts_query_cursor_delete
impl Point {
    pub fn new(row: usize, column: usize) -> Self 
impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> Result<(), fmt::Error> 
impl Into<ffi::TSPoint> for Point {
    fn into(self) -> ffi::TSPoint 
        ffi::TSPoint
impl From<ffi::TSPoint> for Point {
    fn from(point: ffi::TSPoint) -> Self 
impl Into<ffi::TSRange> for Range {
    fn into(self) -> ffi::TSRange 
        ffi::TSRange
impl From<ffi::TSRange> for Range {
    fn from(range: ffi::TSRange) -> Self 
impl<'a> Into<ffi::TSInputEdit
    fn into(self) -> ffi::TSInputEdit 
        ffi::TSInputEdit
impl<'a> LossyUtf8<'a> {
    pub fn new(bytes: &'a [u8]) -> Self 
impl<'a> Iterator for LossyUtf8<'a> {
    fn next(&mut self) -> Option<&'a str> 
fn predicate_error(row: usize, message: String) -> QueryError 
impl fmt::Display for IncludedRangesError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result 
impl fmt::Display for LanguageError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result 
impl fmt::Display for QueryError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result 
impl error::Error for IncludedRangesError {
impl error::Error for LanguageError {
impl error::Error for QueryError {
impl Send for Language {
impl Send for Parser {
impl Send for Query {
impl Send for QueryCursor {
impl Send for Tree {
impl Sync for Language {
impl Sync for Query {
impl Sync for Tree {
