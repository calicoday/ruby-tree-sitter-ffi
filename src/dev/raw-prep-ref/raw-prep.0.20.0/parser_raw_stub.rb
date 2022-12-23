describe "0.20.0 parser_raw_stub.rb" do
  before do
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
  end

  it ":ts_parser_set_language, [Parser, Language], :bool" do
    ret = TreeSitterFFI.ts_parser_set_language(@parser_1, @language_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_parser_language, [Parser], Language" do
    ret = TreeSitterFFI.ts_parser_language(@parser_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  it ":ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32_t], :bool" do
    ret = TreeSitterFFI.ts_parser_set_included_ranges(@parser_1, @range_1, @uint32_t_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_parser_included_ranges, [Parser, :uint32_t_p], Range.by_ref" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_parser_included_ranges(@parser_1, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_parser_parse, [Parser, Tree, Input.by_value], Tree" do
    ret = TreeSitterFFI.ts_parser_parse(@parser_1, @tree_1, @input_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_parse_string, [Parser, Tree, :string, :uint32_t], Tree" do
    ret = TreeSitterFFI.ts_parser_parse_string(@parser_1, @tree_1, @string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_parse_string_encoding, [Parser, Tree, :string, :uint32_t, EnumInputEncoding], Tree" do
    ret = TreeSitterFFI.ts_parser_parse_string_encoding(@parser_1, @tree_1, @string_1, @uint32_t_1, @enum_input_encoding_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_reset, [Parser], :void" do
    ret = TreeSitterFFI.ts_parser_reset(@parser_1)
    # ret void
  end

  it ":ts_parser_set_timeout_micros, [Parser, :uint64_t], :void" do
    ret = TreeSitterFFI.ts_parser_set_timeout_micros(@parser_1, @uint64_t_1)
    # ret void
  end

  it ":ts_parser_timeout_micros, [Parser], :uint64_t" do
    ret = TreeSitterFFI.ts_parser_timeout_micros(@parser_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_parser_set_cancellation_flag, [Parser, :size_t_p], :void" do
    ret, *got = BossFFI::bufs([:size_t_p]) do |size_t_p_1|
      TreeSitterFFI.ts_parser_set_cancellation_flag(@parser_1, size_t_p_1)
    end
    # ret void
  end

  it ":ts_parser_cancellation_flag, [Parser], :size_t_p" do
    ret = TreeSitterFFI.ts_parser_cancellation_flag(@parser_1)
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_parser_set_logger, [Parser, Logger.by_value], :void" do
    ret = TreeSitterFFI.ts_parser_set_logger(@parser_1, @logger_1)
    # ret void
  end

  it ":ts_parser_logger, [Parser], Logger.by_value" do
    ret = TreeSitterFFI.ts_parser_logger(@parser_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Logger).should == true
  end

  it ":ts_parser_print_dot_graphs, [Parser, :int], :void" do
    ret = TreeSitterFFI.ts_parser_print_dot_graphs(@parser_1, @int_1)
    # ret void
  end

end
