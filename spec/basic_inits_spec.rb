describe "Parser, JSON lang inits" do
  before do
    @pars = TreeSitterFFI.parser
		@json = TreeSitterFFI.parser_json
  end
  
  describe "Json lang parser" do
  	# should be lang??? just :blang ie :pointer for now
  	it "should be a FFI::Pointer" do
    	@json.should_not == nil
    	@json.is_a?(FFI::Pointer).should == true
  	end
  end

  describe "Parser" do
  	it "should be a TreeSitterFFI::Parser" do
    	@pars.should_not == nil
    	@pars.is_a?(TreeSitterFFI::Parser).should == true
  	end
  	
    it "should accept a language parser" do
    	@pars.set_language(@json).should == true
    end
  end
end

describe "Tree, Node inits" do
  before do
    @pars = TreeSitterFFI.parser
		json = TreeSitterFFI.parser_json
		@pars.set_language(json).should == true
		@input = "[1, null]"
		@tree = @pars.parse_string(nil, @input, @input.length)
  end
  
  describe "#parse_string" do
    it "should return a TreeSitterFFI::Tree" do
    	@tree.should_not == nil
    	@tree.is_a?(TreeSitterFFI::Tree).should == true
    end
	end
	
	describe "tree#root_node" do
    it "should return a TreeSitterFFI::Node" do
    	@tree.root_node.should_not == nil
    	@tree.root_node.is_a?(TreeSitterFFI::Node).should == true
    end
	end
	
	describe "a node, eg root_node on '[1, null]'" do
		before do
			@node = @tree.root_node
		end
		
    it "should have a 'document' type (String)" do
    	type = @node.type
    	type.should_not == nil
    	type.is_a?(String).should == true
    	type.should == 'document'
    end
    
    it "should have a symbol (Integer)" do
    	# acceptable values???
    	symbol = @node.symbol
    	symbol.should_not == nil
    	symbol.is_a?(Integer).should == true
    end
    
    it "should have a child_count (Integer) of 1" do
    	count = @node.child_count
    	count.should_not == nil
    	count.is_a?(Integer).should == true
    	count.should == 1
    end
    
    it "should have first child" do
    	child = @node.child(0)
    	child.should_not == nil
    	child.is_a?(TreeSitterFFI::Node).should == true
    end
    
    it "should have named_child_count (Integer) of 1" do
    	count = @node.named_child_count
    	count.should_not == nil
    	count.is_a?(Integer).should == true
    	count.should == 1
    end
    
		# named_child(idx), idx of named_child subset
    it "should have first named child of 'array_node'" do
    	child = @node.named_child(0)
    	child.should_not == nil
    	child.is_a?(TreeSitterFFI::Node).should == true
    	child.type.should == 'array'
    end
    
    it "should provide a string representation of '(document (array (number) (null)))'" do
    	str = @node.string
    	str.should_not == nil
    	str.is_a?(String).should == true
    	str.should == '(document (array (number) (null)))'
    end
    
	end

end
