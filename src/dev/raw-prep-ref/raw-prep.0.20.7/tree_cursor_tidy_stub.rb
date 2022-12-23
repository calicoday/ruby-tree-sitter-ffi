describe "0.20.7 tree_cursor_tidy_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @tree_cursor_1 = @build.obj(TreeSitterFFI::TreeCursor, 1)
    @node_1 = @build.obj(TreeSitterFFI::Node, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
  end

  it "reset(node_1) => :void" do
    ret = @tree_cursor_1.reset(@node_1)
    # ret void
  end

  it "current_node() => Node.by_value" do
    ret = @tree_cursor_1.current_node()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "current_field_name() => :string" do
    ret = @tree_cursor_1.current_field_name()
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "current_field_id() => :field_id" do
    ret = @tree_cursor_1.current_field_id()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "goto_parent() => :bool" do
    ret = @tree_cursor_1.goto_parent()
    [true, false].include?(ret).should == true
  end

  it "goto_next_sibling() => :bool" do
    ret = @tree_cursor_1.goto_next_sibling()
    [true, false].include?(ret).should == true
  end

  it "goto_first_child() => :bool" do
    ret = @tree_cursor_1.goto_first_child()
    [true, false].include?(ret).should == true
  end

  it "goto_first_child_for_byte(uint32_t_1) => :int64_t" do
    ret = @tree_cursor_1.goto_first_child_for_byte(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "goto_first_child_for_point(point_1) => :int64_t" do
    ret = @tree_cursor_1.goto_first_child_for_point(@point_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "copy() => TreeCursor.by_value" do
    ret = @tree_cursor_1.copy()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::TreeCursor).should == true
  end

end
