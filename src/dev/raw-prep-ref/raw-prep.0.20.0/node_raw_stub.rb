describe "0.20.0 node_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @node_1 = @build.obj(TreeSitterFFI::Node, 1)
    @node_2 = @build.obj(TreeSitterFFI::Node, 2)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @uint32_t_2 = @build.obj(:uint32_t, 2)
    @string_1 = @build.obj(:string, 1)
    @field_id_1 = @build.obj(:field_id, 1)
    @point_1 = @build.obj(TreeSitterFFI::Point, 1)
    @point_2 = @build.obj(TreeSitterFFI::Point, 2)
    @input_edit_1 = @build.obj(TreeSitterFFI::InputEdit, 1)
  end

  it ":ts_node_type, [Node.by_value], :string" do
    ret = TreeSitterFFI.ts_node_type(@node_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_node_symbol, [Node.by_value], :symbol" do
    ret = TreeSitterFFI.ts_node_symbol(@node_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_start_byte, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_start_byte(@node_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_start_point, [Node.by_value], Point.by_value" do
    ret = TreeSitterFFI.ts_node_start_point(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it ":ts_node_end_byte, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_end_byte(@node_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_end_point, [Node.by_value], Point.by_value" do
    ret = TreeSitterFFI.ts_node_end_point(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it ":ts_node_string, [Node.by_value], :string" do
    ret = TreeSitterFFI.ts_node_string(@node_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_node_is_null, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_null(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_named, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_named(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_missing, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_missing(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_is_extra, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_is_extra(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_has_changes, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_has_changes(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_has_error, [Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_has_error(@node_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_node_parent, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_parent(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_child, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child(@node_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_field_name_for_child, [Node.by_value, :uint32_t], :string" do
    ret = TreeSitterFFI.ts_node_field_name_for_child(@node_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_node_child_count, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_child_count(@node_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_named_child, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_named_child(@node_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_child_count, [Node.by_value], :uint32_t" do
    ret = TreeSitterFFI.ts_node_named_child_count(@node_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_node_child_by_field_name, [Node.by_value, :string, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child_by_field_name(@node_1, @string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value" do
    ret = TreeSitterFFI.ts_node_child_by_field_id(@node_1, @field_id_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_next_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_next_sibling(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_prev_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_prev_sibling(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_next_named_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_next_named_sibling(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_prev_named_sibling, [Node.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_prev_named_sibling(@node_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_first_child_for_byte, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_first_child_for_byte(@node_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_first_named_child_for_byte, [Node.by_value, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_first_named_child_for_byte(@node_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_descendant_for_byte_range(@node_1, @uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_descendant_for_point_range(@node_1, @point_1, @point_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_descendant_for_byte_range, [Node.by_value, :uint32_t, :uint32_t], Node.by_value" do
    ret = TreeSitterFFI.ts_node_named_descendant_for_byte_range(@node_1, @uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_named_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
    ret = TreeSitterFFI.ts_node_named_descendant_for_point_range(@node_1, @point_1, @point_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it ":ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void" do
    ret = TreeSitterFFI.ts_node_edit(@node_1, @input_edit_1)
    # ret void
  end

  it ":ts_node_eq, [Node.by_value, Node.by_value], :bool" do
    ret = TreeSitterFFI.ts_node_eq(@node_1, @node_2)
    [true, false].include?(ret).should == true
  end

end
