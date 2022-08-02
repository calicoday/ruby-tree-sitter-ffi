// lib/binding_rust/lib.rs
// extract (impl\s+\w+\s+{|^\s*(pub fn [^{]+)) to \1

impl Language {
    pub fn version(&self) -> usize 
    pub fn node_kind_count(&self) -> usize 
    pub fn node_kind_for_id(&self, id: u16) -> Option<&'static str> 
    pub fn id_for_node_kind(&self, kind: &str, named: bool) -> u16 
    pub fn node_kind_is_named(&self, id: u16) -> bool 

    pub fn node_kind_is_visible(&self, id: u16) -> bool 
    pub fn field_count(&self) -> usize 
    pub fn field_name_for_id(&self, field_id: u16) -> Option<&'static str> 
    pub fn field_id_for_name(&self, field_name: impl AsRef<[u8]>) -> Option<u16> 
impl Parser {
    pub fn new() -> Parser 
    pub fn set_language(&mut self, language: Language) -> Result<(), LanguageError> 
    pub fn language(&self) -> Option<Language> 
    pub fn logger(&self) -> Option<&Logger> 
    pub fn set_logger(&mut self, logger: Option<Logger>) 
    pub fn print_dot_graphs(&mut self, file: &impl AsRawFd) 
    pub fn stop_printing_dot_graphs(&mut self) 
    pub fn parse(&mut self, text: impl AsRef<[u8]>, old_tree: Option<&Tree>) -> Option<Tree> 
    pub fn parse_utf16(
        &mut self,
        input: impl AsRef<[u16]>,
        old_tree: Option<&Tree>,
    ) -> Option<Tree> 
    pub fn parse_with<'a, T: AsRef<[u8]>, F: FnMut(usize, Point) -> T>(
        &mut self,
        callback: &mut F,
        old_tree: Option<&Tree>,
    ) -> Option<Tree> 
    pub fn parse_utf16_with<'a, T: AsRef<[u16]>, F: FnMut(usize, Point) -> T>(
        &mut self,
        callback: &mut F,
        old_tree: Option<&Tree>,
    ) -> Option<Tree> 
    pub fn reset(&mut self) 
    pub fn timeout_micros(&self) -> u64 
    pub fn set_timeout_micros(&mut self, timeout_micros: u64) 
    pub fn set_included_ranges<'a>(
        &mut self,
        ranges: &'a [Range],
    ) -> Result<(), IncludedRangesError> 
impl Tree {
    pub fn root_node(&self) -> Node 
    pub fn language(&self) -> Language 
    pub fn edit(&mut self, edit: &InputEdit) 
    pub fn walk(&self) -> TreeCursor 
    pub fn changed_ranges(&self, other: &Tree) -> impl ExactSizeIterator<Item = Range> 
    pub fn id(&self) -> usize 
    pub fn kind_id(&self) -> u16 
    pub fn kind(&self) -> &'static str 
    pub fn language(&self) -> Language 
    pub fn is_named(&self) -> bool 
    pub fn is_extra(&self) -> bool 
    pub fn has_changes(&self) -> bool 
    pub fn has_error(&self) -> bool 
    pub fn is_error(&self) -> bool 
    pub fn is_missing(&self) -> bool 
    pub fn start_byte(&self) -> usize 
    pub fn end_byte(&self) -> usize 
    pub fn byte_range(&self) -> std::ops::Range<usize> 
    pub fn range(&self) -> Range 
    pub fn start_position(&self) -> Point 
    pub fn end_position(&self) -> Point 
    pub fn child(&self, i: usize) -> Option<Self> 
    pub fn child_count(&self) -> usize 
    pub fn named_child<'a>(&'a self, i: usize) -> Option<Self> 
    pub fn named_child_count(&self) -> usize 
    pub fn child_by_field_name(&self, field_name: impl AsRef<[u8]>) -> Option<Self> 
    pub fn child_by_field_id(&self, field_id: u16) -> Option<Self> 
    pub fn children<'a>(
        &self,
        cursor: &'a mut TreeCursor<'tree>,
    ) -> impl ExactSizeIterator<Item = Node<'tree>> + 'a 
    pub fn named_children<'a>(
        &self,
        cursor: &'a mut TreeCursor<'tree>,
    ) -> impl ExactSizeIterator<Item = Node<'tree>> + 'a 
    pub fn children_by_field_name<'a>(
        &self,
        field_name: &str,
        cursor: &'a mut TreeCursor<'tree>,
    ) -> impl Iterator<Item = Node<'tree>> + 'a 
    pub fn children_by_field_id<'a>(
        &self,
        field_id: u16,
        cursor: &'a mut TreeCursor<'tree>,
    ) -> impl Iterator<Item = Node<'tree>> + 'a 
    pub fn parent(&self) -> Option<Self> 
    pub fn next_sibling(&self) -> Option<Self> 
    pub fn prev_sibling(&self) -> Option<Self> 
    pub fn next_named_sibling(&self) -> Option<Self> 
    pub fn prev_named_sibling(&self) -> Option<Self> 
    pub fn descendant_for_byte_range(&self, start: usize, end: usize) -> Option<Self> 
    pub fn named_descendant_for_byte_range(&self, start: usize, end: usize) -> Option<Self> 
    pub fn descendant_for_point_range(&self, start: Point, end: Point) -> Option<Self> 
    pub fn named_descendant_for_point_range(&self, start: Point, end: Point) -> Option<Self> 

    pub fn to_sexp(&self) -> String 

    pub fn utf8_text<'a>(&self, source: &'a [u8]) -> Result<&'a str, str::Utf8Error> 

    pub fn utf16_text<'a>(&self, source: &'a [u16]) -> &'a [u16] 
    pub fn walk(&self) -> TreeCursor<'tree> 
    pub fn edit(&mut self, edit: &InputEdit) 
    pub fn node(&self) -> Node<'a> 
    pub fn field_id(&self) -> Option<u16> 
    pub fn field_name(&self) -> Option<&'static str> 
    pub fn goto_first_child(&mut self) -> bool 
    pub fn goto_parent(&mut self) -> bool 
    pub fn goto_next_sibling(&mut self) -> bool 
    pub fn goto_first_child_for_byte(&mut self, index: usize) -> Option<usize> 
    pub fn reset(&mut self, node: Node<'a>) 
impl Query {
    pub fn new(language: Language, source: &str) -> Result<Self, QueryError> 
    pub fn start_byte_for_pattern(&self, pattern_index: usize) -> usize 
    pub fn pattern_count(&self) -> usize 
    pub fn capture_names(&self) -> &[String] 
    pub fn property_predicates(&self, index: usize) -> &[(QueryProperty, bool)] 
    pub fn property_settings(&self, index: usize) -> &[QueryProperty] 
    pub fn general_predicates(&self, index: usize) -> &[QueryPredicate] 
    pub fn disable_capture(&mut self, name: &str) 
    pub fn disable_pattern(&mut self, index: usize) 
    pub fn step_is_definite(&self, byte_offset: usize) -> bool 
    pub fn new() -> Self 
    pub fn did_exceed_match_limit(&self) -> bool 
    pub fn matches<'tree: 'a, T: AsRef<[u8]>>(
        &'a mut self,
        query: &'a Query,
        node: Node<'tree>,
        mut text_callback: impl FnMut(Node<'tree>) -> T + 'a,
    ) -> impl Iterator<Item = QueryMatch<'tree>> + 'a 
    pub fn captures<'tree, T: AsRef<[u8]>>(
        &'a mut self,
        query: &'a Query,
        node: Node<'tree>,
        text_callback: impl FnMut(Node<'tree>) -> T + 'a,
    ) -> QueryCaptures<'a, 'tree, T> 
    pub fn set_byte_range(&mut self, start: usize, end: usize) -> &mut Self 
    pub fn set_point_range(&mut self, start: Point, end: Point) -> &mut Self 
    pub fn remove(self) 
impl QueryProperty {
    pub fn new(key: &str, value: Option<&str>, capture_id: Option<usize>) -> Self 
impl Point {
    pub fn new(row: usize, column: usize) -> Self 
    pub fn new(bytes: &'a [u8]) -> Self 
