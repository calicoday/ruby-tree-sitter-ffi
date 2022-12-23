describe "0.20.0 parser_raw_patch_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @parser_1 = @build.obj(TreeSitterFFI::Parser, 1)
    @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
    @input_1 = @build.obj(TreeSitterFFI::Input, 1)
    @logger_1 = @build.obj(TreeSitterFFI::Logger, 1)
  end

  # ret is array of Range, arg_1 is pointer to array len.
  it ":ts_parser_included_ranges, [Parser, :uint32_t_p], Range.by_ref" do
    :ts_parser_included_ranges.should == :FIXME
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_parser_included_ranges(@parser_1, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_parser_parse, [Parser, Tree, Input.by_value], Tree" do
    :ts_parser_parse.should == :FIXME
    ret = TreeSitterFFI.ts_parser_parse(@parser_1, @tree_1, @input_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_set_cancellation_flag, [Parser, :size_t_p], :void" do
    :ts_parser_set_cancellation_flag.should == :FIXME
    # :size_p is Pointer
    ret, *got = BossFFI::bufs([:size_t_p]) do |size_t_p_1|
      TreeSitterFFI.ts_parser_set_cancellation_flag(@parser_1, size_t_p_1)
    end
    # ret void
  end

  it ":ts_parser_set_logger, [Parser, Logger.by_value], :void" do
    :ts_parser_set_logger.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_parser_set_logger(@parser_1, @logger_1)
    # ret void
  end

  # getting nil ret in the form of #<FFI::Pointer address=0x0000000000000000> ???!!!
  it ":ts_parser_logger, [Parser], Logger.by_value" do
    :ts_parser_logger.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_parser_logger(@parser_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Logger).should == true
  end

end
