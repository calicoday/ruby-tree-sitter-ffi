module TreeSitterFFI
  class QueryCursorSigs
    def api_h_version() '0.20.6' end
    def types_that_happen_ref
      %q%
        @query_cursor_1 = @build.obj(TreeSitterFFI::QueryCursor, 1)
        @query_1 = @build.obj(TreeSitterFFI::Query, 1)
        @node_1 = @build.obj(TreeSitterFFI::Node, 1)
        @uint32_1 = @build.obj(:uint32, 1)
        @uint32_2 = @build.obj(:uint32, 2)
        @point_1 = @build.obj(TreeSitterFFI::Point, 1)
        @point_2 = @build.obj(TreeSitterFFI::Point, 2)
        @query_match_1 = @build.obj(TreeSitterFFI::QueryMatch, 1)
      %
    end
  
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

    def sig_plan
      {
        ### QueryCursor,
        ts_query_cursor_exec: '@query_cursor, @query, @root_node',
        ts_query_cursor_did_exceed_match_limit: '@query_cursor',
        ts_query_cursor_match_limit: '@query_cursor',
        ts_query_cursor_set_match_limit: '@query_cursor, 12',
        ts_query_cursor_set_byte_range: '@query_cursor, 1, 5',
        ts_query_cursor_set_point_range: [nil], #patch
#         ts_query_cursor_set_point_range: '@query_cursor, TreeSitterFFI::Point.new',
        ts_query_cursor_next_match: [nil,
          ["# don't know what are acceptable arg values!!!"],
          {not_impl: true}
          ],
        ts_query_cursor_remove_match: '@query_cursor, 5',
        ts_query_cursor_next_capture: [nil,
          ["# don't know what are acceptable arg values!!!"],
          {not_impl: true}
          ]
      }
    end
  
    def sig_plan_blank
      {
        ts_query_cursor_exec: nil,
        ts_query_cursor_did_exceed_match_limit: nil,
        ts_query_cursor_match_limit: nil,
        ts_query_cursor_set_match_limit: nil,
        ts_query_cursor_set_byte_range: nil,
        ts_query_cursor_set_point_range: nil,
        ts_query_cursor_next_match: nil,
        ts_query_cursor_remove_match: nil,
        ts_query_cursor_next_capture: nil,
      }
    end
  end
end
