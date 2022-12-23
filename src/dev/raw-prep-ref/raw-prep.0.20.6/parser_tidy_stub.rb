describe "0.20.6 parser_tidy_stub.rb" do
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

  it "set_language(language_1) => :bool" do
    ret = @parser_1.set_language(@language_1)
    [true, false].include?(ret).should == true
  end

  it "language() => Language" do
    ret = @parser_1.language()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Language).should == true
  end

  it "set_included_ranges(range_1, uint32_t_1) => :bool" do
    ret = @parser_1.set_included_ranges(@range_1, @uint32_t_1)
    [true, false].include?(ret).should == true
  end

  it "included_ranges(val_uint32_t_1) => [Range.by_ref, :uint32_t]" do
    ret, *got = @parser_1.bufs_included_ranges(val_uint32_t_1)
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

  it "parse(tree_1, input_1) => Tree" do
    ret = @parser_1.parse(@tree_1, @input_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it "parse_string(tree_1, string_1, uint32_t_1) => Tree" do
    ret = @parser_1.parse_string(@tree_1, @string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it "parse_string_encoding(tree_1, string_1, uint32_t_1, enum_input_encoding_1) => Tree" do
    ret = @parser_1.parse_string_encoding(@tree_1, @string_1, @uint32_t_1, @enum_input_encoding_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it "reset() => :void" do
    ret = @parser_1.reset()
    # ret void
  end

  it "set_timeout_micros(uint64_t_1) => :void" do
    ret = @parser_1.set_timeout_micros(@uint64_t_1)
    # ret void
  end

  it "timeout_micros() => :uint64_t" do
    ret = @parser_1.timeout_micros()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "set_cancellation_flag(val_size_t_1) => [:void, :size_t]" do
    ret, *got = @parser_1.bufs_set_cancellation_flag(val_size_t_1)
    # ret void
    got[0].should_not == nil
    got[0].is_a?(:size_t).should == true
  end

  it "cancellation_flag() => :size_t_p" do
    ret = @parser_1.cancellation_flag()
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it "set_logger(logger_1) => :void" do
    ret = @parser_1.set_logger(@logger_1)
    # ret void
  end

  it "logger() => Logger.by_value" do
    ret = @parser_1.logger()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Logger).should == true
  end

  it "print_dot_graphs(int_1) => :void" do
    ret = @parser_1.print_dot_graphs(@int_1)
    # ret void
  end

end
