describe "0.20.0 tree_raw_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    json = TreeSitterFFI.parser_json
    @pars.set_language(json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @root_node = @tree.root_node
    # 		@array_node = @root_node.named_child(0)
  end

  it ":ts_tree_copy, [Tree], Tree" do
    ret = TreeSitterFFI.ts_tree_copy(@tree)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_tree_root_node, [Tree], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_root_node(@tree)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_language, [Tree], Language" do
    ret = TreeSitterFFI.ts_tree_language(@tree)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  # need to try this with more useful InputEdit values
  it ":ts_tree_edit, [Tree, InputEdit.by_ref], :void" do
    ret = TreeSitterFFI.ts_tree_edit(@tree, TreeSitterFFI::InputEdit.new)
    # ret void
  end

  # :ts_tree_get_changed_ranges, [Tree, Tree, :uint32_t_p], Range.by_ref # to patch

  # :ts_tree_print_dot_graph, [Tree, :waitwhatFILE_p], :void # to patch

end
