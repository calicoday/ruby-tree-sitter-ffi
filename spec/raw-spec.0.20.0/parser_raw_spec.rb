describe "0.20.0 parser_raw_spec.rb" do
  before do
    @pars = TreeSitterFFI.parser
    @json = TreeSitterFFI.parser_json
    @pars.set_language(@json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
  end

  it ":ts_parser_set_language, [Parser, Language], :bool" do
    ret = TreeSitterFFI.ts_parser_set_language(@pars, @json)
    [true, false].include?(ret).should == true
  end

  it ":ts_parser_language, [Parser], Language" do
    ret = TreeSitterFFI.ts_parser_language(@pars)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  # arg_1 is array of Range, arg_2 is array len.
  it ":ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32_t], :bool" do
    ret = TreeSitterFFI.ts_parser_set_included_ranges(@pars, TreeSitterFFI::Range.new, 1)
    [true, false].include?(ret).should == true
  end

  # :ts_parser_included_ranges, [Parser, :uint32_t_p], Range.by_ref # to patch

  # :ts_parser_parse, [Parser, Tree, Input.by_value], Tree # to patch

  it ":ts_parser_parse_string, [Parser, Tree, :string, :uint32_t], Tree" do
    ret = TreeSitterFFI.ts_parser_parse_string(@pars, @tree, "blurg", 5)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_parse_string_encoding, [Parser, Tree, :string, :uint32_t, EnumInputEncoding], Tree" do
    ret = TreeSitterFFI.ts_parser_parse_string_encoding(@pars, @tree, "blurg", 5, :utf8)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_reset, [Parser], :void" do
    ret = TreeSitterFFI.ts_parser_reset(@pars)
    # ret void
  end

  it ":ts_parser_set_timeout_micros, [Parser, :uint64_t], :void" do
    ret = TreeSitterFFI.ts_parser_set_timeout_micros(@pars, 2000)
    # ret void
  end

  it ":ts_parser_timeout_micros, [Parser], :uint64_t" do
    ret = TreeSitterFFI.ts_parser_timeout_micros(@pars)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  # :ts_parser_set_cancellation_flag, [Parser, :size_t_p], :void # to patch

  it ":ts_parser_cancellation_flag, [Parser], :size_t_p" do
    # :size_p is Pointer
    ret = TreeSitterFFI.ts_parser_cancellation_flag(@pars)
    # ret.should_not == nil # nil return permitted
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true if ret
  end

  # :ts_parser_set_logger, [Parser, Logger.by_value], :void # to patch

  # :ts_parser_logger, [Parser], Logger.by_value # to patch

  it ":ts_parser_print_dot_graphs, [Parser, :int], :void" do
    ret = TreeSitterFFI.ts_parser_print_dot_graphs(@pars, 2)
    # ret void
  end

end
