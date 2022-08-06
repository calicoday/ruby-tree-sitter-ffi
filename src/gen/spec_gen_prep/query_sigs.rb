# generated by src/gen/gen_sigs_blank.rb, to be COPIED and filled in.

class QuerySigs
  def before
    %q%
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
    %
  end
  
  def sig(fn_name)
    case fn_name
    when :ts_query_pattern_count then '@query'
		when :ts_query_capture_count then '@query'
		when :ts_query_string_count then '@query'
		when :ts_query_start_byte_for_pattern then ['@query, 5',
		  ["# api.h doesn't say what the uint32 second arg is for!!!"]
		  ]
# 		when :ts_query_predicates_for_pattern then 
		when :ts_query_step_is_definite then ['@query, 5',
		  ["# api.h doesn't say what :ts_query_step_is_definite does!!!"]
		  ]
		when :ts_query_capture_name_for_id then [nil,
		  ["# don't know what are acceptable arg values!!!"],
		  {not_impl: true}
		  ]
		when :ts_query_string_value_for_id then [nil,
		  ["# don't know what are acceptable arg values!!!"],
      {not_impl: true}
		  ]
		when :ts_query_disable_capture then ['@query, "blurg", 1',
		  ["# api.h doesn't say what the args are for!!!"]
		  ]
		when :ts_query_disable_pattern then ['@query, 1',
		  ["# api.h doesn't say what the args are for!!!"]
		  ]
		  
		### QueryCursor 
		
		when :ts_query_cursor_exec then '@query_cursor, @query, @root_node'
		when :ts_query_cursor_did_exceed_match_limit then '@query_cursor'
		when :ts_query_cursor_match_limit then '@query_cursor'
		when :ts_query_cursor_set_match_limit then '@query_cursor, 12'
		when :ts_query_cursor_set_byte_range then '@query_cursor, 1, 5'
		when :ts_query_cursor_set_point_range then '@query_cursor, TreeSitterFFI::Point.new'
		when :ts_query_cursor_next_match then [nil,
		  ["# don't know what are acceptable arg values!!!"],
		  {not_impl: true}
		  ]
		when :ts_query_cursor_remove_match then '@query_cursor, 5'
		when :ts_query_cursor_next_capture then [nil,
		  ["# don't know what are acceptable arg values!!!"],
		  {not_impl: true}
		  ]
    else
      nil
    end
  end
end
