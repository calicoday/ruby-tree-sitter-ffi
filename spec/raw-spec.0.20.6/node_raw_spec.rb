describe "0.20.6 node_raw_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    json = TreeSitterFFI.parser_json
    @pars.set_language(json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
    @root_node = @tree.root_node
    @array_node = @root_node.named_child(0)
    @number_node = @array_node.named_child(0)
  end

  it ":ts_node_type, [Node.by_value], :string" do
    ret = TreeSitterFFI.ts_node_type(@number_node)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_node_symbol, [Node.by_value], :symbol" do
    ret = TreeSitterFFI.ts_node_symbol(@number_node)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_start_byte, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_start_byte(@number_node)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_start_point, [Node.by_value], Point.by_value" do
    ret = TreeSitterFFI.ts_node_start_point(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it ":ts_node_end_byte, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_end_byte(@number_node)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_end_point, [Node.by_value], Point.by_value" do
    ret = TreeSitterFFI.ts_node_end_point(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it ":ts_node_string, [Node.by_value], :string" do
    # :strptr is [String, FFI::Pointer]
    ret = TreeSitterFFI.ts_node_string(@number_node)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_node_is_null, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_null(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_named, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_named(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_missing, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_missing(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_extra, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_extra(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_has_changes, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_has_changes(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_has_error, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_has_error(@number_node)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_parent, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_parent(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  # not sure yet whether we can use just any node args, so try @array_node here for now
  it ":ts_node_child, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child(@array_node, 3)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  # not sure yet whether we can use just any node args, so try @array_node here for now
  it ":ts_node_field_name_for_child, [Node.by_value, :uint32_t], :string" do
    ret = TreeSitterFFI.ts_node_field_name_for_child(@array_node, 3)
    # ret.should_not == nil # nil return permitted
    ret.is_a?(String).should == true if ret
  end

  it ":ts_node_child_count, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_child_count(@array_node)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_named_child, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_named_child(@array_node, 0)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_child_count, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_named_child_count(@array_node)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  # come back to these two Field map ones:
  it ":ts_node_child_by_field_name, [Node.by_value, :string, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child_by_field_name(@number_node, "blurg", 2)
    # ret.should_not == nil # nil return permitted
    ret.is_a?(TreeSitterFFI::Node).should == true if ret
  end

  it ":ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child_by_field_id(@number_node, 2)
    # ret.should_not == nil # nil return permitted
    ret.is_a?(TreeSitterFFI::Node).should == true if ret
  end

  it ":ts_node_next_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_next_sibling(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_prev_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_prev_sibling(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_next_named_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_next_named_sibling(@number_node)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_prev_named_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_prev_named_sibling(@number_node)
    # ret.should_not == nil # nil return permitted
    ret.is_a?(TreeSitterFFI::Node).should == true if ret
  end

  # again array_node, nec???
  it ":ts_node_first_child_for_byte, [Node.by_value, :uint32_t], Node.by_value" do
    # array_node offset 5 should be at 'u', ie "[1, n^ull]"
    ret = TreeSitterFFI.ts_node_first_child_for_byte(@array_node, 5)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_first_named_child_for_byte, [Node.by_value, :uint32_t], Node.by_value" do
    # array_node offset 1 should be at '1', ie "[^1, null]"
    ret = TreeSitterFFI.ts_node_first_named_child_for_byte(@array_node, 1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value" do
    # array_node offset 2 should be at ',', ie "[1^, null]"
    ret = TreeSitterFFI.ts_node_descendant_for_byte_range(@array_node, 2, 3)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_descendant_for_point_range(@array_node, TreeSitterFFI::Point.new, TreeSitterFFI::Point.new)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value" do
    # array_node offset 5 should be at 'u', ie "[1, n^ull]"
    ret = TreeSitterFFI.ts_node_named_descendant_for_byte_range(@number_node, 5, 7)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_named_descendant_for_point_range(@number_node, TreeSitterFFI::Point.new, TreeSitterFFI::Point.new)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void" do
    ret = TreeSitterFFI.ts_node_edit(@number_node, TreeSitterFFI::InputEdit.new)
    # ret void
  end

  it ":ts_node_eq, [Node.by_value, Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_eq(@number_node, TreeSitterFFI::Node.new)
    [true, false].include?(ret).should == true
  end

end
