describe "0.20.0 tree_tidy_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
    @tree_2 = @build.obj(TreeSitterFFI::Tree, 2)
    @input_edit_1 = @build.obj(TreeSitterFFI::InputEdit, 1)
  end

  it "copy() => Tree" do
    ret = @tree_1.copy()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it "root_node() => Node.by_value" do
    ret = @tree_1.root_node()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "language() => Language" do
    ret = @tree_1.language()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  it "edit(input_edit_1) => :void" do
    ret = @tree_1.edit(@input_edit_1)
    # ret void
  end

  it "get_changed_ranges(tree_2, val_uint32_t_1) => [Range.by_ref, :uint32_t]" do
    ret, *got = @tree_1.bufs_get_changed_ranges(@tree_2, val_uint32_t_1)
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

  it "print_dot_graph(val_waitwhat_file_1) => [:void, :waitwhatFILE]" do
    ret, *got = @tree_1.bufs_print_dot_graph(val_waitwhat_file_1)
    # ret void
    got[0].should_not == nil
    got[0].is_a?(TreeSitterFFI:::waitwhatFILE).should == true
  end

end
