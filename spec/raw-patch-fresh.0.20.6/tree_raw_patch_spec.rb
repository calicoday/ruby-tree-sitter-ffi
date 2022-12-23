describe "0.20.6 tree_raw_patch_spec.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
    @tree_2 = @build.obj(TreeSitterFFI::Tree, 2)
  end

  it ":ts_tree_get_changed_ranges, [Tree, Tree, :uint32_t_p], Range.by_ref" do
    :ts_tree_get_changed_ranges.should == :FIXME
    # compare @tree to itself
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_tree_get_changed_ranges(@tree_1, @tree_2, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  # come back to FILE pointer
  it ":ts_tree_print_dot_graph, [Tree, :waitwhatFILE_p], :void" do
    :ts_tree_print_dot_graph.should == :FIXME
    ret, *got = BossFFI::bufs([:waitwhatFILE_p]) do |waitwhat_file_p_1|
      TreeSitterFFI.ts_tree_print_dot_graph(@tree_1, waitwhat_file_p_1)
    end
    # ret void
  end

end
