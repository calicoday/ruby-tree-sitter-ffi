describe "0.20.7 query_cursor_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_cursor_1 = @build.obj(TreeSitterFFI::QueryCursor, 1)
    @query_1 = @build.obj(TreeSitterFFI::Query, 1)
    @node_1 = @build.obj(TreeSitterFFI::Node, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @uint32_t_2 = @build.obj(:uint32_t, 2)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
    @point_2 = @build.obj(TreeSitterFFI::Point, 2)
    @query_match_1 = @build.obj(TreeSitterFFI::QueryMatch, 1)
  end

  it ":ts_query_cursor_exec, [QueryCursor, Query, Node.by_value], :void" do
    ret = TreeSitterFFI.ts_query_cursor_exec(@query_cursor_1, @query_1, @node_1)
    # ret void
  end

  it ":ts_query_cursor_did_exceed_match_limit, [QueryCursor], :bool" do
    ret = TreeSitterFFI.ts_query_cursor_did_exceed_match_limit(@query_cursor_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_query_cursor_match_limit, [QueryCursor], :uint32_t" do
    ret = TreeSitterFFI.ts_query_cursor_match_limit(@query_cursor_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_cursor_set_match_limit, [QueryCursor, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_set_match_limit(@query_cursor_1, @uint32_t_1)
    # ret void
  end

  it ":ts_query_cursor_set_byte_range, [QueryCursor, :uint32_t, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_set_byte_range(@query_cursor_1, @uint32_t_1, @uint32_t_2)
    # ret void
  end

  it ":ts_query_cursor_set_point_range, [QueryCursor, Point.by_value, Point.by_value], :void" do
    ret = TreeSitterFFI.ts_query_cursor_set_point_range(@query_cursor_1, @point_1, @point_2)
    # ret void
  end

  it ":ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool" do
    ret = TreeSitterFFI.ts_query_cursor_next_match(@query_cursor_1, @query_match_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_query_cursor_remove_match, [QueryCursor, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_cursor_remove_match(@query_cursor_1, @uint32_t_1)
    # ret void
  end

  it ":ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_t_p], :bool" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_cursor_next_capture(@query_cursor_1, @query_match_1, uint32_t_p_1)
    end
    [true, false].include?(ret).should == true
  end

end
