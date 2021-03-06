# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_node_spec.rb" do
	before do
	end
    
	it ":ts_node_type, [Node.by_value], :string" do
		ret = TreeSitterFFI.ts_node_type(node_0)
		ret.should_not == nil
		ret.is_a?(String).should == true
	end

	it ":ts_node_symbol, [Node.by_value], :uint16" do
		ret = TreeSitterFFI.ts_node_symbol(node_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_node_start_byte, [Node.by_value], :uint32" do
		ret = TreeSitterFFI.ts_node_start_byte(node_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_node_start_point, [Node.by_value], Point.by_value" do
		ret = TreeSitterFFI.ts_node_start_point(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Point).should == true
	end

	it ":ts_node_end_byte, [Node.by_value], :uint32" do
		ret = TreeSitterFFI.ts_node_end_byte(node_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_node_end_point, [Node.by_value], Point.by_value" do
		ret = TreeSitterFFI.ts_node_end_point(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Point).should == true
	end

	it ":ts_node_string, [Node.by_value], :adoptstring" do
		ret = TreeSitterFFI.ts_node_string(node_0)
		ret.should_not == nil
		ret.is_a?(Array).should == true
	end

	it ":ts_node_is_null, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_is_null(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_is_named, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_is_named(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_is_missing, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_is_missing(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_is_extra, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_is_extra(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_has_changes, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_has_changes(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_has_error, [Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_has_error(node_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_node_parent, [Node.by_value], Node.by_value" do
		ret = TreeSitterFFI.ts_node_parent(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_child, [Node.by_value, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_child(node_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_child_count, [Node.by_value], :uint32" do
		ret = TreeSitterFFI.ts_node_child_count(node_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_node_named_child, [Node.by_value, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_named_child(node_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_named_child_count, [Node.by_value], :uint32" do
		ret = TreeSitterFFI.ts_node_named_child_count(node_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_node_child_by_field_name, [Node.by_value, :string, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_child_by_field_name(node_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_child_by_field_id, [Node.by_value, :field_id], Node.by_value" do
		ret = TreeSitterFFI.ts_node_child_by_field_id(node_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_next_sibling, [Node.by_value], Node.by_value" do
		ret = TreeSitterFFI.ts_node_next_sibling(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_prev_sibling, [Node.by_value], Node.by_value" do
		ret = TreeSitterFFI.ts_node_prev_sibling(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_next_named_sibling, [Node.by_value], Node.by_value" do
		ret = TreeSitterFFI.ts_node_next_named_sibling(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_prev_named_sibling, [Node.by_value], Node.by_value" do
		ret = TreeSitterFFI.ts_node_prev_named_sibling(node_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_first_child_for_byte, [Node.by_value, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_first_child_for_byte(node_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_first_named_child_for_byte, [Node.by_value, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_first_named_child_for_byte(node_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_descendant_for_byte_range, [Node.by_value, :uint32, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_descendant_for_byte_range(node_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_descendant_for_point_range, [Node.by_value, Point, Point], Node.by_value" do
		ret = TreeSitterFFI.ts_node_descendant_for_point_range(node_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_named_descendant_for_byte_range, [Node.by_value, :uint32, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_named_descendant_for_byte_range(node_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_named_descendant_for_point_range, [Node.by_value, Point, Point], Node.by_value" do
		ret = TreeSitterFFI.ts_node_named_descendant_for_point_range(node_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_edit, [Node.by_ref, InputEdit.by_ref], :void" do
		ret = TreeSitterFFI.ts_node_edit(node_0, arg_1)
		# ret void
	end

	it ":ts_node_eq, [Node.by_value, Node.by_value], :bool" do
		ret = TreeSitterFFI.ts_node_eq(node_0, arg_1)
		[true, false].include?(ret).should == true
	end


end
