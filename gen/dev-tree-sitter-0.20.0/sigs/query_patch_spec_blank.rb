# hacky hacky hacky -- generated by src/gen/spec_gen.rb, then COPIED and hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "query_patch_spec_blank.rb" do
  before do
    @pars = TreeSitterFFI.parser
    @json = TreeSitterFFI.parser_json
    @pars.set_language(@json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @sexp = '(document (array (number) (null)))'
#     arg_0 = FFI::MemoryPointer.new(:uint32, 1)
#     ret = @pars.included_ranges(arg_0)
#     len = arg_0.get(:uint32, 0)
    @err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
    @err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
#     @err_type_p = FFI::MemoryPointer.new(TreeSitterFFI::EnumQueryError, 1) # enum!!!
    @query = TreeSitterFFI.ts_query_new(@json, @sexp, @sexp.length, 
      @err_offset_p, @err_type_p)
#     puts "err_offset: #{@err_offset_p.get(:uint32, 0)}"
#     puts "err_type: #{@err_type_p.get(:uint32, 0)}"
    @query_cursor = TreeSitterFFI.ts_query_cursor_new()
    @root_node = @tree.root_node
  end
  
  it ":ts_query_predicates_for_pattern, [Query, :uint32, :uint32_p], QueryPredicateStep.by_ref" do
    :ts_query_predicates_for_pattern.should == :FIXME
    ret = TreeSitterFFI.ts_query_predicates_for_pattern()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::QueryPredicateStep).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string" do
    :ts_query_capture_name_for_id.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_query_capture_name_for_id()
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_string_value_for_id, [Query, :uint32, :uint32_p], :string" do
    :ts_query_string_value_for_id.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_query_string_value_for_id()
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool" do
    :ts_query_cursor_next_match.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_query_cursor_next_match()
    [true, false].include?(ret).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_p], :bool" do
    :ts_query_cursor_next_capture.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_query_cursor_next_capture()
    [true, false].include?(ret).should == true
  end

end