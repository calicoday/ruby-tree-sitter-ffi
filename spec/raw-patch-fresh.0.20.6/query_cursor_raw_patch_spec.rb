describe "0.20.6 query_cursor_raw_patch_spec.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_cursor_1 = @build.obj(TreeSitterFFI::QueryCursor, 1)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
    @point_2 = @build.obj(TreeSitterFFI::Point, 2)
    @query_match_1 = @build.obj(TreeSitterFFI::QueryMatch, 1)
  end

  it ":ts_query_cursor_set_point_range, [QueryCursor, Point.by_value, Point.by_value], :void" do
    :ts_query_cursor_set_point_range.should == :FIXME
    ret = TreeSitterFFI.ts_query_cursor_set_point_range(@query_cursor_1, @point_1, @point_2)
    # ret void
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool" do
    :ts_query_cursor_next_match.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_query_cursor_next_match(@query_cursor_1, @query_match_1)
    [true, false].include?(ret).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_t_p], :bool" do
    :ts_query_cursor_next_capture.should == :FIXME # :not_impl
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_cursor_next_capture(@query_cursor_1, @query_match_1, uint32_t_p_1)
    end
    [true, false].include?(ret).should == true
  end

end
