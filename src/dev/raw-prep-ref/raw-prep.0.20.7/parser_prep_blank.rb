module TreeSitterFFI
  class ParserSigs
    def api_h_version() '0.20.7' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @parser_1 = @build.obj(TreeSitterFFI::Parser, 1)
        @language_1 = @build.obj(TreeSitterFFI::Language, 1)
        @range_1 = @build.obj(TreeSitterFFI::Range, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
        @input_1 = @build.obj(TreeSitterFFI::Input, 1)
        @string_1 = @build.obj(:string, 1)
        @enum_input_encoding_1 = @build.obj(TreeSitterFFI::EnumInputEncoding, 1)
        @uint64_t_1 = @build.obj(:uint64_t, 1)
        @logger_1 = @build.obj(TreeSitterFFI::Logger, 1)
        @int_1 = @build.obj(:int, 1)
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
        ts_parser_set_language: nil,
        ts_parser_language: nil,
        ts_parser_set_included_ranges: nil,
        ts_parser_included_ranges: nil,
        ts_parser_parse: nil,
        ts_parser_parse_string: nil,
        ts_parser_parse_string_encoding: nil,
        ts_parser_reset: nil,
        ts_parser_set_timeout_micros: nil,
        ts_parser_timeout_micros: nil,
        ts_parser_set_cancellation_flag: nil,
        ts_parser_cancellation_flag: nil,
        ts_parser_set_logger: nil,
        ts_parser_logger: nil,
        ts_parser_print_dot_graphs: nil,
      }
    end
  end
end
