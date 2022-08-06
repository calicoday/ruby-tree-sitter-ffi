# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_node_spec.rb" do
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
    
	it ":ts_node_string, [Node.by_value], :adoptstring" do
		ret = TreeSitterFFI.ts_node_string(@number_node)
		ret.should_not == nil
		ret.is_a?(Array).should == true # :strptr is [String, FFI::Pointer]
	end

	it ":ts_node_field_name_for_child, [Node.by_value, :uint32], :string" do
		ret = TreeSitterFFI.ts_node_field_name_for_child(@array_node, 3)
# 		ret.should_not == nil # nil return permitted!!!
		ret.is_a?(String).should == true if ret
	end

	# come back to these two Field map ones:
	it ":ts_node_child_by_field_name, [Node.by_value, :string, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_child_by_field_name(@number_node, "blurg", 2)
# 		ret.should_not == nil # nil return permitted!!! ie, no_node
		ret.is_a?(TreeSitterFFI::Node).should == true
	end

	it ":ts_node_child_by_field_id, [Node.by_value, :uint32], Node.by_value" do
		ret = TreeSitterFFI.ts_node_child_by_field_id(@number_node, 2)
# 		ret.should_not == nil # nil return permitted!!! ie, no_node
		ret.is_a?(TreeSitterFFI::Node).should == true
	end


end