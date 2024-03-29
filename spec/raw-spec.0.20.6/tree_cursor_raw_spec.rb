describe "0.20.6 tree_cursor_raw_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    json = TreeSitterFFI.parser_json
    @pars.set_language(json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @root_node = @tree.root_node
    # 		@array_node = @root_node.named_child(0)
    @tree_cursor = TreeSitterFFI.ts_tree_cursor_new(@root_node) #crashes!!! FIXME!!!
  end

  it ":ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void" do
    # reset to the same root_node
    ret = TreeSitterFFI.ts_tree_cursor_reset(@tree_cursor, @root_node)
    # ret void
  end

  it ":ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_cursor_current_node(@tree_cursor)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string" do
    ret = TreeSitterFFI.ts_tree_cursor_current_field_name(@tree_cursor)
    # ret.should_not == nil # nil return permitted
    ret.is_a?(String).should == true if ret
  end

  it ":ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id" do
    ret = TreeSitterFFI.ts_tree_cursor_current_field_id(@tree_cursor)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_parent(@tree_cursor)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_next_sibling(@tree_cursor)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child(@tree_cursor)
    [true, false].include?(ret).should == true
  end

  it ":ts_tree_cursor_goto_first_child_for_byte, [TreeCursor.by_ref, :uint32_t], :int64_t" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_byte(@tree_cursor, 5)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_goto_first_child_for_point, [TreeCursor.by_ref, Point.by_value], :int64_t" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_point(@tree_cursor, TreeSitterFFI::Point.new)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value" do
    ret = TreeSitterFFI.ts_tree_cursor_copy(@tree_cursor)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::TreeCursor).should == true
  end

end
