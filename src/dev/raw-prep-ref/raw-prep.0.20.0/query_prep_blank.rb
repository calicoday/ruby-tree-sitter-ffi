module TreeSitterFFI
  class QuerySigs
    def api_h_version() '0.20.0' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @query_1 = @build.obj(TreeSitterFFI::Query, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @string_1 = @build.obj(:string, 1)
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
        ts_query_pattern_count: nil,
        ts_query_capture_count: nil,
        ts_query_string_count: nil,
        ts_query_start_byte_for_pattern: nil,
        ts_query_predicates_for_pattern: nil,
        ts_query_step_is_definite: nil,
        ts_query_capture_name_for_id: nil,
        ts_query_string_value_for_id: nil,
        ts_query_disable_capture: nil,
        ts_query_disable_pattern: nil,
      }
    end
  end
end
