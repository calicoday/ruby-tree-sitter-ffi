describe "0.20.6 node_tidy_stub.rb" do
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

  it "type() => :string" do
    ret = @node_1.type()
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "symbol() => :symbol" do
    ret = @node_1.symbol()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "start_byte() => :uint32_t" do
    ret = @node_1.start_byte()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "start_point() => Point.by_value" do
    ret = @node_1.start_point()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it "end_byte() => :uint32_t" do
    ret = @node_1.end_byte()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "end_point() => Point.by_value" do
    ret = @node_1.end_point()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Point).should == true
  end

  it "string() => :string" do
    ret = @node_1.string()
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "is_null() => :bool" do
    ret = @node_1.is_null()
    [true, false].include?(ret).should == true
  end

  it "is_named() => :bool" do
    ret = @node_1.is_named()
    [true, false].include?(ret).should == true
  end

  it "is_missing() => :bool" do
    ret = @node_1.is_missing()
    [true, false].include?(ret).should == true
  end

  it "is_extra() => :bool" do
    ret = @node_1.is_extra()
    [true, false].include?(ret).should == true
  end

  it "has_changes() => :bool" do
    ret = @node_1.has_changes()
    [true, false].include?(ret).should == true
  end

  it "has_error() => :bool" do
    ret = @node_1.has_error()
    [true, false].include?(ret).should == true
  end

  it "parent() => Node.by_value" do
    ret = @node_1.parent()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "child(uint32_t_1) => Node.by_value" do
    ret = @node_1.child(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "field_name_for_child(uint32_t_1) => :string" do
    ret = @node_1.field_name_for_child(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "child_count() => :uint32_t" do
    ret = @node_1.child_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "named_child(uint32_t_1) => Node.by_value" do
    ret = @node_1.named_child(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "named_child_count() => :uint32_t" do
    ret = @node_1.named_child_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "child_by_field_name(string_1, uint32_t_1) => Node.by_value" do
    ret = @node_1.child_by_field_name(@string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "child_by_field_id(field_id_1) => Node.by_value" do
    ret = @node_1.child_by_field_id(@field_id_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "next_sibling() => Node.by_value" do
    ret = @node_1.next_sibling()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "prev_sibling() => Node.by_value" do
    ret = @node_1.prev_sibling()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "next_named_sibling() => Node.by_value" do
    ret = @node_1.next_named_sibling()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "prev_named_sibling() => Node.by_value" do
    ret = @node_1.prev_named_sibling()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "first_child_for_byte(uint32_t_1) => Node.by_value" do
    ret = @node_1.first_child_for_byte(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "first_named_child_for_byte(uint32_t_1) => Node.by_value" do
    ret = @node_1.first_named_child_for_byte(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "descendant_for_byte_range(uint32_t_1, uint32_t_2) => Node.by_value" do
    ret = @node_1.descendant_for_byte_range(@uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "descendant_for_point_range(point_1, point_2) => Node.by_value" do
    ret = @node_1.descendant_for_point_range(@point_1, @point_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "named_descendant_for_byte_range(uint32_t_1, uint32_t_2) => Node.by_value" do
    ret = @node_1.named_descendant_for_byte_range(@uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "named_descendant_for_point_range(point_1, point_2) => Node.by_value" do
    ret = @node_1.named_descendant_for_point_range(@point_1, @point_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Node).should == true
  end

  it "edit(input_edit_1) => :void" do
    ret = @node_1.edit(@input_edit_1)
    # ret void
  end

  it "eq(node_2) => :bool" do
    ret = @node_1.eq(@node_2)
    [true, false].include?(ret).should == true
  end

end
