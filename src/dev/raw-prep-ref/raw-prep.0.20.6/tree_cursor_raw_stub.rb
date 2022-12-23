describe "0.20.6 tree_cursor_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @tree_cursor_1 = @build.obj(TreeSitterFFI::TreeCursor, 1)
    @node_1 = @build.obj(TreeSitterFFI::Node, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
  end

  it ":ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void" do
    ret = TreeSitterFFI.ts_tree_cursor_reset(@tree_cursor_1, @node_1)
    # ret void
  end

  it ":ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_cursor_current_node(@tree_cursor_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string" do
    ret = TreeSitterFFI.ts_tree_cursor_current_field_name(@tree_cursor_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id" do
    ret = TreeSitterFFI.ts_tree_cursor_current_field_id(@tree_cursor_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_parent(@tree_cursor_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_next_sibling(@tree_cursor_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child(@tree_cursor_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_first_child_for_byte, [TreeCursor.by_ref, :uint32_t], :int64_t" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_byte(@tree_cursor_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_goto_first_child_for_point, [TreeCursor.by_ref, Point.by_value], :int64_t" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_point(@tree_cursor_1, @point_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value" do
    ret = TreeSitterFFI.ts_tree_cursor_copy(@tree_cursor_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::TreeCursor).should == true
  end

end
