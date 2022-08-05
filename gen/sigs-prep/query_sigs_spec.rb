# hacky hacky hacky -- generated by src/gen/spec_gen.rb, then COPIED and hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "query_sigs_spec.rb" do
	before do
    @pars = TreeSitterFFI.parser
		@json = TreeSitterFFI.parser_json
		@pars.set_language(@json).should == true
		@input = "[1, null]"
		@tree = @pars.parse_string(nil, @input, @input.length)
		@sexp = '(document (array (number) (null)))'
# 		arg_0 = FFI::MemoryPointer.new(:uint32, 1)
# 		ret = @pars.included_ranges(arg_0)
# 		len = arg_0.get(:uint32, 0)
		@err_offset_p = FFI::MemoryPointer.new(:uint32, 1)
		@err_type_p = FFI::MemoryPointer.new(:uint32, 1) # enum!!!
# 		@err_type_p = FFI::MemoryPointer.new(TreeSitterFFI::EnumQueryError, 1) # enum!!!
		@query = TreeSitterFFI.ts_query_new(@json, @sexp, @sexp.length, 
			@err_offset_p, @err_type_p)
# 		puts "err_offset: #{@err_offset_p.get(:uint32, 0)}"
# 		puts "err_type: #{@err_type_p.get(:uint32, 0)}"
		@query_cursor = TreeSitterFFI.ts_query_cursor_new()
		@root_node = @tree.root_node
	end
    
	it ":ts_query_pattern_count, [Query], :uint32" do
		ret = TreeSitterFFI.ts_query_pattern_count(@query)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_query_capture_count, [Query], :uint32" do
		ret = TreeSitterFFI.ts_query_capture_count(@query)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_query_string_count, [Query], :uint32" do
		ret = TreeSitterFFI.ts_query_string_count(@query)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	# api.h doesn't say what the uint32 second arg is for!!!
	it ":ts_query_start_byte_for_pattern, [Query, :uint32], :uint32" do
		ret = TreeSitterFFI.ts_query_start_byte_for_pattern(@query, 5)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_query_predicates_for_pattern, [Query, :uint32, :uint32_p], QueryPredicateStep.by_ref" do end # TBD

	# api.h doesn't say what :ts_query_step_is_definite does!!!
	it ":ts_query_step_is_definite, [Query, :uint32], :bool" do
		ret = TreeSitterFFI.ts_query_step_is_definite(@query, 5)
		[true, false].include?(ret).should == true
	end

	it ":ts_query_capture_name_for_id, [Query, :uint32, :uint32_p], :string" do end # TBD

	it ":ts_query_string_value_for_id, [Query, :uint32, :uint32_p], :string" do end # TBD

	# api.h doesn't say what the args are for!!!
	it ":ts_query_disable_capture, [Query, :string, :uint32], :void" do
		ret = TreeSitterFFI.ts_query_disable_capture(@query, "blurg", 1)
		# ret void
	end

	# api.h doesn't say what the args are for!!!
	it ":ts_query_disable_pattern, [Query, :uint32], :void" do
		ret = TreeSitterFFI.ts_query_disable_pattern(@query, 1)
		# ret void
	end

	it ":ts_query_cursor_exec, [QueryCursor, Query, Node.by_value], :void" do
		ret = TreeSitterFFI.ts_query_cursor_exec(@query_cursor, @query, @root_node)
		# ret void
	end

	it ":ts_query_cursor_did_exceed_match_limit, [QueryCursor], :bool" do
		ret = TreeSitterFFI.ts_query_cursor_did_exceed_match_limit(@query_cursor)
		[true, false].include?(ret).should == true
	end

	it ":ts_query_cursor_match_limit, [QueryCursor], :uint32" do
		ret = TreeSitterFFI.ts_query_cursor_match_limit(@query_cursor)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_query_cursor_set_match_limit, [QueryCursor, :uint32], :bool" do
		ret = TreeSitterFFI.ts_query_cursor_set_match_limit(@query_cursor, 12)
		[true, false].include?(ret).should == true
	end

	it ":ts_query_cursor_set_byte_range, [QueryCursor, :uint32, :uint32], :void" do
		ret = TreeSitterFFI.ts_query_cursor_set_byte_range(@query_cursor, 1, 5)
		# ret void
	end

	it ":ts_query_cursor_set_point_range, [QueryCursor, Point], :void" do
		ret = TreeSitterFFI.ts_query_cursor_set_point_range(@query_cursor, TreeSitterFFI::Point.new)
		# ret void
	end

	it ":ts_query_cursor_next_match, [QueryCursor, QueryMatch.by_ref], :bool" do end # TBD

	it ":ts_query_cursor_remove_match, [QueryCursor, :uint32], :void" do
		ret = TreeSitterFFI.ts_query_cursor_remove_match(@query_cursor, 5)
		# ret void
	end

	it ":ts_query_cursor_next_capture, [QueryCursor, QueryMatch.by_ref, :uint32_p], :bool" do end # TBD

end
