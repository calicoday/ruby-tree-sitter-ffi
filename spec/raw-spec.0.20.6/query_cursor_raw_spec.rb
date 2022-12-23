describe "0.20.6 query_cursor_raw_spec.rb" do
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

  it ":ts_query_cursor_exec, [QueryCursor, Query, Node.by_value], :void" do
    ret = TreeSitterFFI.ts_query_cursor_exec(@query_cursor, @query, @root_node)
    # ret void
  end

  it ":ts_query_cursor_did_exceed_match_limit, [QueryCursor], :bool" do
    ret = TreeSitterFFI.ts_query_cursor_did_exceed_match_limit(@query_cursor)
    [true, false].include?(ret).should == true
  end

  it ":ts_query_cursor_match_limit, [QueryCursor], :uint32_t" do
    ret = TreeSitterFFI.ts_query_cursor_match_limit(@query_cursor)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_cursor_set_match_limit, [QueryCursor, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_set_match_limit(@query_cursor, 12)
    # ret void
  end

  it ":ts_query_cursor_set_byte_range, [QueryCursor, :uint32_t, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_set_byte_range(@query_cursor, 1, 5)
    # ret void
  end

  # :ts_query_cursor_set_point_range, [QueryCursor, Point.by_value, Point.by_value], :void # to patch

  # :ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool # to patch

  it ":ts_query_cursor_remove_match, [QueryCursor, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_remove_match(@query_cursor, 5)
    # ret void
  end

  # :ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_t_p], :bool # to patch

end
