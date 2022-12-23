module TreeSitterFFI
  class QueryCursorSigs
    def api_h_version() '0.20.6' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @query_cursor_1 = @build.obj(TreeSitterFFI::QueryCursor, 1)
        @query_1 = @build.obj(TreeSitterFFI::Query, 1)
        @node_1 = @build.obj(TreeSitterFFI::Node, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @uint32_t_2 = @build.obj(:uint32_t, 2)
        @point_1 = @build.obj(TreeSitterFFI::Point, 1)
        @point_2 = @build.obj(TreeSitterFFI::Point, 2)
        @query_match_1 = @build.obj(TreeSitterFFI::QueryMatch, 1)
      %
    end
  
    def before
      %q%
      %
    end
  
    def sig_plan
      {
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
