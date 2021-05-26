# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "query_spec.rb" do
	before do
	end
    
	it "pattern_count() # => Integer" do
		ret = query_0.pattern_count()
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it "capture_count() # => Integer" do
		ret = query_0.capture_count()
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it "string_count() # => Integer" do
		ret = query_0.string_count()
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it "start_byte_for_pattern(Integer) # => Integer" do
		ret = query_0.start_byte_for_pattern(arg_1)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it "predicates_for_pattern(Integer, Integer) # => QueryPredicateStep" do
		ret = query_0.predicates_for_pattern(arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::QueryPredicateStep).should == true
	end

	it "step_is_definite(Integer) # => :bool" do
		ret = query_0.step_is_definite(arg_1)
		[true, false].include?(ret).should == true
	end

	it "capture_name_for_id(Integer, Integer) # => String" do
		ret = query_0.capture_name_for_id(arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(String).should == true
	end

	it "string_value_for_id(Integer, Integer) # => String" do
		ret = query_0.string_value_for_id(arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(String).should == true
	end

	it "disable_capture(String, Integer) # => :void" do
		ret = query_0.disable_capture(arg_1, arg_2)
		# ret void
	end

	it "disable_pattern(Integer) # => :void" do
		ret = query_0.disable_pattern(arg_1)
		# ret void
	end

	it "exec(Query, Node) # => :void" do
		ret = query_cursor_0.exec(arg_1, arg_2)
		# ret void
	end

	it "did_exceed_match_limit() # => :bool" do
		ret = query_cursor_0.did_exceed_match_limit()
		[true, false].include?(ret).should == true
	end

	it "match_limit() # => Integer" do
		ret = query_cursor_0.match_limit()
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it "set_match_limit(Integer) # => :bool" do
		ret = query_cursor_0.set_match_limit(arg_1)
		[true, false].include?(ret).should == true
	end

	it "set_byte_range(Integer, Integer) # => :void" do
		ret = query_cursor_0.set_byte_range(arg_1, arg_2)
		# ret void
	end

	it "set_point_range(Point) # => :void" do
		ret = query_cursor_0.set_point_range(arg_1)
		# ret void
	end

	it "next_match(QueryMatch) # => :bool" do
		ret = query_cursor_0.next_match(arg_1)
		[true, false].include?(ret).should == true
	end

	it "remove_match(Integer) # => :void" do
		ret = query_cursor_0.remove_match(arg_1)
		# ret void
	end

	it "next_capture(QueryMatch, Integer) # => :bool" do
		ret = query_cursor_0.next_capture(arg_1, arg_2)
		[true, false].include?(ret).should == true
	end


end
