describe "0.20.7 tree_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
    @tree_2 = @build.obj(TreeSitterFFI::Tree, 2)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
    @input_edit_1 = @build.obj(TreeSitterFFI::InputEdit, 1)
  end

  it ":ts_tree_copy, [Tree], Tree" do
    ret = TreeSitterFFI.ts_tree_copy(@tree_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_tree_root_node, [Tree], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_root_node(@tree_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_root_node_with_offset, [Tree, :uint32_t, Point.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_root_node_with_offset(@tree_1, @uint32_t_1, @point_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_language, [Tree], Language" do
    ret = TreeSitterFFI.ts_tree_language(@tree_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  it ":ts_tree_edit, [Tree, InputEdit.by_ref], :void" do
    ret = TreeSitterFFI.ts_tree_edit(@tree_1, @input_edit_1)
    # ret void
  end

  it ":ts_tree_get_changed_ranges, [Tree, Tree, :uint32_t_p], Range.by_ref" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_tree_get_changed_ranges(@tree_1, @tree_2, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_tree_print_dot_graph, [Tree, :waitwhatFILE_p], :void" do
    ret, *got = BossFFI::bufs([:waitwhatFILE_p]) do |waitwhat_file_p_1|
      TreeSitterFFI.ts_tree_print_dot_graph(@tree_1, waitwhat_file_p_1)
    end
    # ret void
  end

end
