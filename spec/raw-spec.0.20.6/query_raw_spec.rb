describe "0.20.6 query_raw_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    @json = TreeSitterFFI.parser_json
    @pars.set_language(@json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @sexp = '(document (array (number) (null)))'
    # 		arg_0 = FFI::MemoryPointer.new(:uint32, 1)
    # 		ret = @pars.included_ranges(arg_0)
    # 		len = arg_0.get(:uint32, 0)
    @err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
    @err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
    # 		@err_type_p = FFI::MemoryPointer.new(TreeSitterFFI::EnumQueryError, 1) # enum!!!
    @query = TreeSitterFFI.ts_query_new(@json, @sexp, @sexp.length,
    @err_offset_p, @err_type_p)
    # 		puts "err_offset: #{@err_offset_p.get(:uint32, 0)}"
    # 		puts "err_type: #{@err_type_p.get(:uint32, 0)}"
    @query_cursor = TreeSitterFFI.ts_query_cursor_new()
    @root_node = @tree.root_node
  end

  it ":ts_query_pattern_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_pattern_count(@query)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_capture_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_capture_count(@query)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_string_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_string_count(@query)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  # api.h doesn't say what the uint32 second arg is for!!!
  it ":ts_query_start_byte_for_pattern, [Query, :uint32_t], :uint32_t" do
    ret = TreeSitterFFI.ts_query_start_byte_for_pattern(@query, 5)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  # :ts_query_predicates_for_pattern, [Query, :uint32_t, :uint32_t_p], QueryPredicateStep.by_ref # to patch

  # :ts_query_is_pattern_guaranteed_at_step, [Query, :uint32_t], :bool # to patch

  # :ts_query_capture_name_for_id, [Query, :uint32_t, :uint32_t_p], :string # to patch

  # :ts_query_capture_quantifier_for_id, [Query, :uint32_t, :uint32_t], EnumQuantifier # to patch

  # :ts_query_string_value_for_id, [Query, :uint32_t, :uint32_t_p], :string # to patch

  # api.h doesn't say what the args are for!!!
  it ":ts_query_disable_capture, [Query, :string, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_disable_capture(@query, "blurg", 1)
    # ret void
  end

  # api.h doesn't say what the args are for!!!
  it ":ts_query_disable_pattern, [Query, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_disable_pattern(@query, 1)
    # ret void
  end

end
