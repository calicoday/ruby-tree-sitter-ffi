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
# 		@array_node = @root_node.named_child(0)
		@tree_cursor = TreeSitterFFI.ts_tree_cursor_new(@root_node) #crashes!!! FIXME!!!
	end
    
	it ":ts_tree_get_changed_ranges, [Tree, Tree, :uint32_p], :array_of_range" do
		arg_2 = FFI::MemoryPointer.new(:uint32, 1)
		# compare @tree to itself
		ret = TreeSitterFFI.ts_tree_get_changed_ranges(@tree, @tree, arg_2)
# 		ret.should_not == nil # nil is permitted (if no diff, len == 0)
		ret.is_a?(FFI::Pointer).should == true
		len = arg_2.get(:uint32, 0)
		len.should_not == nil
		len.is_a?(Integer).should == true
	end

	# come back to FILE pointer
	it ":ts_tree_print_dot_graph, [Tree, :file_pointer], :void" do
		:ts_tree_print_dot_graph.should_not == :FIXME
# 		ret = TreeSitterFFI.ts_tree_print_dot_graph(@tree, arg_1)
# 		# ret void
	end

end
