describe "0.20.0 query_cursor_tidy_stub.rb" do
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

  it "exec(query_1, node_1) => :void" do
    ret = @query_cursor_1.exec(@query_1, @node_1)
    # ret void
  end

  it "did_exceed_match_limit() => :bool" do
    ret = @query_cursor_1.did_exceed_match_limit()
    [true, false].include?(ret).should == true
  end

  it "match_limit() => :uint32_t" do
    ret = @query_cursor_1.match_limit()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "set_match_limit(uint32_t_1) => :void" do
    ret = @query_cursor_1.set_match_limit(@uint32_t_1)
    # ret void
  end

  it "set_byte_range(uint32_t_1, uint32_t_2) => :void" do
    ret = @query_cursor_1.set_byte_range(@uint32_t_1, @uint32_t_2)
    # ret void
  end

  it "set_point_range(point_1, point_2) => :void" do
    ret = @query_cursor_1.set_point_range(@point_1, @point_2)
    # ret void
  end

  it "next_match(query_match_1) => :bool" do
    ret = @query_cursor_1.next_match(@query_match_1)
    [true, false].include?(ret).should == true
  end

  it "remove_match(uint32_t_1) => :void" do
    ret = @query_cursor_1.remove_match(@uint32_t_1)
    # ret void
  end

  it "next_capture(query_match_1, val_uint32_t_1) => [:bool, :uint32_t]" do
    ret, *got = @query_cursor_1.bufs_next_capture(@query_match_1, val_uint32_t_1)
    [true, false].include?(ret).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

end
