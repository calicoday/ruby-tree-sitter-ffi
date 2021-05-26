# the asserts in the parse json example.c

describe "JSON example.c" do
  before do
    @pars = TreeSitterFFI.parser
		json = TreeSitterFFI.parser_json
		@pars.set_language(json)
		@input = "[1, null]"
		@tree = @pars.parse_string(nil, @input, @input.length)
		@root_node = @tree.root_node
		@array_node = @root_node.named_child(0)
		@number_node = @array_node.named_child(0)
  end

	it "root_node should have type of 'document'" do
		@root_node.type.should == 'document'
	end

	it "array_node should have type of 'array'" do
		@array_node.type.should == 'array'
	end

	it "number_node should have type of 'number'" do
		@number_node.type.should == 'number'
	end

	it "root_node should have child_count of 1" do
		@root_node.child_count.should == 1
	end

	it "array_node should have child_count of 5" do
		@array_node.child_count.should == 5
	end

	it "array_node should have named_child_count of 2" do
		@array_node.named_child_count.should == 2
	end

	it "number_node should have child_count of 0" do
		@number_node.child_count.should == 0
	end

end
