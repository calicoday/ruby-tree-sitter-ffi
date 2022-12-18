module TreeSitterFFI
  class QuerySigs
    def api_h_version() '0.20.7' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @query_1 = @build.obj(TreeSitterFFI::Query, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @uint32_t_2 = @build.obj(:uint32_t, 2)
        @string_1 = @build.obj(:string, 1)
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
        ts_query_pattern_count: '@query',
        ts_query_capture_count: '@query',
        ts_query_string_count: '@query',
        ts_query_start_byte_for_pattern: ['@query, 5',
          ["# api.h doesn't say what the uint32 second arg is for!!!"]
          ],
    		ts_query_predicates_for_pattern: [nil], #patch
    		# new in 0.20.7:
        ts_query_is_pattern_rooted: [nil], #patch
        ts_query_is_pattern_guaranteed_at_step: [nil], #patch
        ts_query_step_is_definite: ['@query, 5',
          ["# api.h doesn't say what :ts_query_step_is_definite does!!!"]
          ],
        ts_query_capture_name_for_id: [nil,
          ["# don't know what are acceptable arg values!!!"],
          {not_impl: true}
          ],
        ts_query_capture_quantifier_for_id: [nil], #patch
        ts_query_string_value_for_id: [nil,
          ["# don't know what are acceptable arg values!!!"],
          {not_impl: true}
          ],
        ts_query_disable_capture: ['@query, "blurg", 1',
          ["# api.h doesn't say what the args are for!!!"]
          ],
        ts_query_disable_pattern: ['@query, 1',
          ["# api.h doesn't say what the args are for!!!"]
          ]
      }
    end
  
    def sig_plan_blank
      {
        ts_query_pattern_count: nil,
        ts_query_capture_count: nil,
        ts_query_string_count: nil,
        ts_query_start_byte_for_pattern: nil,
        ts_query_predicates_for_pattern: nil,
        ts_query_is_pattern_rooted: nil,
        ts_query_is_pattern_guaranteed_at_step: nil,
        ts_query_capture_name_for_id: nil,
        ts_query_capture_quantifier_for_id: nil,
        ts_query_string_value_for_id: nil,
        ts_query_disable_capture: nil,
        ts_query_disable_pattern: nil,
      }
    end
  end
end
