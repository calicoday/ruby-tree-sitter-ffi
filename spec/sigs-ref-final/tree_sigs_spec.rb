# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_tree_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    json = TreeSitterFFI.parser_json
    @pars.set_language(json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @root_node = @tree.root_node
#     @array_node = @root_node.named_child(0)
    @tree_cursor = TreeSitterFFI.ts_tree_cursor_new(@root_node) #crashes!!! FIXME!!!
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

  it ":ts_tree_get_changed_ranges, [Tree, Tree, :uint32_p], :array_of_range" do
    arg_2 = FFI::MemoryPointer.new(:uint32, 1)
    # compare @tree to itself
    ret = TreeSitterFFI.ts_tree_get_changed_ranges(@tree, @tree, arg_2)
#     ret.should_not == nil # nil is permitted (if no diff, len == 0)
    ret.is_a?(FFI::Pointer).should == true
    len = arg_2.get(:uint32, 0)
    len.should_not == nil
    len.is_a?(Integer).should == true
  end

  # come back to FILE pointer
  it ":ts_tree_print_dot_graph, [Tree, :file_pointer], :void" do
    :ts_tree_print_dot_graph.should == :FIXME
#     ret = TreeSitterFFI.ts_tree_print_dot_graph(@tree, arg_1)
#     # ret void
  end

### TreeCursors 

  it ":ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void" do
    # reset to the same root_node
    arg_1 = @root_node
    ret = TreeSitterFFI.ts_tree_cursor_reset(@tree_cursor, arg_1)
    # ret void
  end

  it ":ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value" do
    ret = TreeSitterFFI.ts_tree_cursor_current_node(@tree_cursor)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string" do
    ret = TreeSitterFFI.ts_tree_cursor_current_field_name(@tree_cursor)
#     ret.should_not == nil # nil is permitted 
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

  it ":ts_tree_cursor_goto_first_child_for_byte, [TreeCursor.by_ref, :uint32], :int64" do
    ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_byte(@tree_cursor, 5)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_tree_cursor_goto_first_child_for_point, [TreeCursor.by_ref, Point.by_value], :int64" do
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
