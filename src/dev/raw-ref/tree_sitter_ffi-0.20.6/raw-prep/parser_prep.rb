module TreeSitterFFI
  class ParserSigs
    def api_h_version() '0.20.6' end
    def types_that_happen_ref
      %q%
        @parser_1 = @build.obj(TreeSitterFFI::Parser, 1)
        @language_1 = @build.obj(TreeSitterFFI::Language, 1)
        @range_1 = @build.obj(TreeSitterFFI::Range, 1)
        @uint32_1 = @build.obj(:uint32, 1)
        @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
        @input_1 = @build.obj(TreeSitterFFI::Input, 1)
        @string_1 = @build.obj(:string, 1)
        @enum_input_encoding_1 = @build.obj(TreeSitterFFI::EnumInputEncoding, 1)
        @uint64_1 = @build.obj(:uint64, 1)
        @logger_1 = @build.obj(TreeSitterFFI::Logger, 1)
        @int_1 = @build.obj(:int, 1)
      %
    end
  
    def before
      %q%
        @pars = TreeSitterFFI.parser
        @json = TreeSitterFFI.parser_json
        @pars.set_language(@json).should == true
        @input = "[1, null]"
        @tree = @pars.parse_string(nil, @input, @input.length)
      %
    end

    ### ts_parser_parse: missing from old
    def sig_plan
      {
        ts_parser_set_language: '@pars, @json',
        ts_parser_language: '@pars',
        ts_parser_set_included_ranges: ['@pars, 
          TreeSitterFFI::Range.new, 1',
          ['# arg_1 is array of Range, arg_2 is array len.']
          ],
        ts_parser_included_ranges: [nil,
          ['# ret is array of Range, arg_1 is pointer to array len.']
          ],
    		ts_parser_parse: [nil], #patch
        ts_parser_parse_string: '@pars, @tree, "blurg", 5',
        ts_parser_parse_string_encoding: '@pars, @tree, "blurg", 5, :utf8',
        ts_parser_reset: '@pars',
        ts_parser_set_timeout_micros: '@pars, 2000',
        ts_parser_timeout_micros: '@pars',
        ts_parser_set_cancellation_flag: [nil,
          '# :size_p is Pointer',
          ],
        ts_parser_cancellation_flag: ['@pars',
          '# :size_p is Pointer',
          {nil_ok: true}
          ],
        ts_parser_set_logger: [nil,
          {not_impl: true}
          ],
        ts_parser_logger: [nil,
          ['# getting nil ret in the form of #<FFI::Pointer address=0x0000000000000000> ???!!!'],
          {not_impl: true}
          ],
        ts_parser_print_dot_graphs: '@pars, 2'
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
