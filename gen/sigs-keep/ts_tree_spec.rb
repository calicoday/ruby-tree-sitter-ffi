# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_tree_spec.rb" do
	before do
	end
    
	it ":ts_tree_copy, [Tree], Tree" do
		ret = TreeSitterFFI.ts_tree_copy(tree_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Tree).should == true
	end

	it ":ts_tree_root_node, [Tree], Node.by_value" do
		ret = TreeSitterFFI.ts_tree_root_node(tree_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_tree_language, [Tree], Language" do
		ret = TreeSitterFFI.ts_tree_language(tree_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Language).should == true
	end

	it ":ts_tree_edit, [Tree, InputEdit.by_ref], :void" do
		ret = TreeSitterFFI.ts_tree_edit(tree_0, arg_1)
		# ret void
	end

	it ":ts_tree_get_changed_ranges, [Tree, Tree, :uint32_p], :array_of_range" do
		ret = TreeSitterFFI.ts_tree_get_changed_ranges(tree_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Pointer).should == true
	end

	it ":ts_tree_print_dot_graph, [Tree, :file_pointer], :void" do
		ret = TreeSitterFFI.ts_tree_print_dot_graph(tree_0, arg_1)
		# ret void
	end

	it ":ts_tree_cursor_reset, [TreeCursor.by_ref, Node.by_value], :void" do
		ret = TreeSitterFFI.ts_tree_cursor_reset(tree_cursor_0, arg_1)
		# ret void
	end

	it ":ts_tree_cursor_current_node, [TreeCursor.by_ref], Node.by_value" do
		ret = TreeSitterFFI.ts_tree_cursor_current_node(tree_cursor_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :strptr" do
		ret = TreeSitterFFI.ts_tree_cursor_current_field_name(tree_cursor_0)
		ret.should_not == nil
		ret.is_a?(Array).should == true
	end

	it ":ts_tree_cursor_current_field_id, [TreeCursor.by_ref], :field_id" do
		ret = TreeSitterFFI.ts_tree_cursor_current_field_id(tree_cursor_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_tree_cursor_goto_parent, [TreeCursor.by_ref], :bool" do
		ret = TreeSitterFFI.ts_tree_cursor_goto_parent(tree_cursor_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_tree_cursor_goto_next_sibling, [TreeCursor.by_ref], :bool" do
		ret = TreeSitterFFI.ts_tree_cursor_goto_next_sibling(tree_cursor_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_tree_cursor_goto_first_child, [TreeCursor.by_ref], :bool" do
		ret = TreeSitterFFI.ts_tree_cursor_goto_first_child(tree_cursor_0)
		[true, false].include?(ret).should == true
	end

	it ":ts_tree_cursor_goto_first_child_for_byte, [TreeCursor.by_ref, :uint32], :int64" do
		ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_byte(tree_cursor_0, arg_1)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_tree_cursor_copy, [TreeCursor.by_ref], TreeCursor.by_value" do
		ret = TreeSitterFFI.ts_tree_cursor_copy(tree_cursor_0)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::TreeCursor).should == true
	end


end
