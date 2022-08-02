# the bits we need from cli/src/tests/helpers, added as needed


# global constants

# dirs.rs
# lazy_static! {
#     static ref ROOT_DIR: PathBuf = PathBuf::from(env!("CARGO_MANIFEST_DIR")).parent().unwrap().to_owned();
#     static ref FIXTURES_DIR: PathBuf = ROOT_DIR.join("test").join("fixtures");
#     static ref HEADER_DIR: PathBuf = ROOT_DIR.join("lib").join("include");
#     static ref GRAMMARS_DIR: PathBuf = ROOT_DIR.join("test").join("fixtures").join("grammars");
#     static ref SCRATCH_DIR: PathBuf = {
#         let result = ROOT_DIR.join("target").join("scratch");
#         fs::create_dir_all(&result).unwrap();
#         result
#     };
# }

# fixtures.rs
# const OPERATORS: &[char] = &[
#     '+', '-', '<', '>', '(', ')', '*', '/', '&', '|', '!', ',', '.',
# ];

Rusty_OPERATORS = ['+', '-', '<', '>', '(', ')', '*', '/', '&', '|', '!', ',', '.'].freeze

# depends on stuff in run_rusty_helpers.rb, must be included and called from there!!!

module BindRustyHelpers
  # edits.rs
  # pub struct ReadRecorder<'a> 
  # impl<'a> ReadRecorder<'a> {
  #     pub fn new(content: &'a Vec<u8>) -> Self 
  #     pub fn read(&mut self, offset: usize) -> &'a [u8] 
  #     pub fn strings_read(&self) -> Vec<&'a str> 
  # pub fn invert_edit(input: &Vec<u8>, edit: &Edit) -> Edit 
  ## pub fn get_random_edit(rand: &mut Rand, input: &Vec<u8>) -> Edit 
  
  # => BindRusty::Edit
  # don't need rand param, call rand(10) directly
  def get_random_edit(input)
    choice = rand(10)
    if choice < 2
      # Insert text at end
      Edit.new(input.length, 0, rand_words(3)
    elsif choice < 5
      # Delete text from the end
      deleted_length = rand(10)
      deleted_length = input.length if deleted_length > input.length
      Edit.new(input.length - deleted_length, deleted_length, "")
    elsif choice < 8
      # Insert at a random position
      position = rand(input.length)
      word_count = 1 + rand(3)
      inserted_text = rand_words(word_count)
      Edit.new(position, 0, inserted_text)
    else
      # Replace at random position
      position = rand(input.length)
      deleted_length = rand(input.length - position)
      word_count = 1 + rand(3)
      inserted_text = rand_words(word_count)
      Edit.new(position, deleted_length, inserted_text)
    end
  end
  
  # fixtures.rs
  # pub fn test_loader<'a>() -> &'a Loader 
  # pub fn fixtures_dir<'a>() -> &'static Path 
  ### pub fn get_language(name: &str) -> Language 
  # pub fn get_language_queries_path(language_name: &str) -> PathBuf 
  # pub fn get_highlight_config(
  #     language_name: &str,
  #     injection_query_filename: Option<&str>,
  #     highlight_names: &[String],
  # ) -> HighlightConfiguration 
  # pub fn get_test_language(name: &str, parser_code: &str, path: Option<&Path>) -> Language 
  # pub fn get_test_grammar(name: &str) -> (String, Option<PathBuf>) 

	def get_language(lang)
		case lang
		when "json" then TreeSitterFFI.parser_json
		when "javascript" then TreeSitterFFI.parser_javascript
		when "python" then TreeSitterFFI.parser_python
		when "ruby" then TreeSitterFFI.parser_ruby
		when "c" then TreeSitterFFI.parser_c
		when "html" then TreeSitterFFI.parser_html
		when "java" then TreeSitterFFI.parser_java
		when "rust" then TreeSitterFFI.parser_rust
		else
			raise "don't know how to get_language(#{lang.inspect})."
		end
	end
	
	# mod.rs => rusty header
	
  # random.rs
  # pub struct Rand(StdRng);
  # impl Rand {
  #     pub fn new(seed: usize) -> Self 
  #     => just call rand() instead
  #     pub fn unsigned(&mut self, max: usize) -> usize 
  #     => just call rand(max) instead 
  ##     pub fn words(&mut self, max_count: usize) -> Vec<u8> 

  # not at all sure I haven't garbled the algo here!!! bc rand!!! FIXME!!!
  def alphanum() $alphanum ||= [*'a'..'z', *'A'..'Z', *'0'..'9'].freeze end
  def rand_words(max)
    alphanum = [*'a'..'z', *'A'..'Z', *'0'..'9']
    list = rand(max).times.map do |i|
      rand(3) == 0 ?
        Rusty_OPERATORS.sample :
        alphanum.sample(rand(8)).join
    end
    list.join(rand(5) == 0 ? "\n" : ' ')
  end
  
  # scope_sequence.rs
  # pub struct ScopeSequence(Vec<ScopeStack>);
  # impl ScopeSequence {
  #     pub fn new(tree: &Tree) -> Self 
  #     pub fn check_changes(


end
