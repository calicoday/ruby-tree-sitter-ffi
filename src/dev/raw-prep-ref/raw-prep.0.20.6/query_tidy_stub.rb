describe "0.20.6 query_tidy_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_1 = @build.obj(TreeSitterFFI::Query, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @uint32_t_2 = @build.obj(:uint32_t, 2)
    @string_1 = @build.obj(:string, 1)
  end

  it "pattern_count() => :uint32_t" do
    ret = @query_1.pattern_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "capture_count() => :uint32_t" do
    ret = @query_1.capture_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "string_count() => :uint32_t" do
    ret = @query_1.string_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "start_byte_for_pattern(uint32_t_1) => :uint32_t" do
    ret = @query_1.start_byte_for_pattern(@uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "predicates_for_pattern(uint32_t_1, val_uint32_t_1) => [QueryPredicateStep.by_ref, :uint32_t]" do
    ret, *got = @query_1.bufs_predicates_for_pattern(@uint32_t_1, val_uint32_t_1)
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

  it "is_pattern_guaranteed_at_step(uint32_t_1) => :bool" do
    ret = @query_1.is_pattern_guaranteed_at_step(@uint32_t_1)
    [true, false].include?(ret).should == true
  end

  it "capture_name_for_id(uint32_t_1, val_uint32_t_1) => [:string, :uint32_t]" do
    ret, *got = @query_1.bufs_capture_name_for_id(@uint32_t_1, val_uint32_t_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

  it "capture_quantifier_for_id(uint32_t_1, uint32_t_2) => EnumQuantifier" do
    ret = @query_1.capture_quantifier_for_id(@uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::EnumQuantifier).should == true
  end

  it "string_value_for_id(uint32_t_1, val_uint32_t_1) => [:string, :uint32_t]" do
    ret, *got = @query_1.bufs_string_value_for_id(@uint32_t_1, val_uint32_t_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
    got[0].should_not == nil
    got[0].is_a?(Integer).should == true
  end

  it "disable_capture(string_1, uint32_t_1) => :void" do
    ret = @query_1.disable_capture(@string_1, @uint32_t_1)
    # ret void
  end

  it "disable_pattern(uint32_t_1) => :void" do
    ret = @query_1.disable_pattern(@uint32_t_1)
    # ret void
  end

end
