describe "0.20.6 query_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_1 = @build.obj(TreeSitterFFI::Query, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @uint32_t_2 = @build.obj(:uint32_t, 2)
    @string_1 = @build.obj(:string, 1)
  end

  it ":ts_query_pattern_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_pattern_count(@query_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_capture_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_capture_count(@query_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_string_count, [Query], :uint32_t" do
    ret = TreeSitterFFI.ts_query_string_count(@query_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_start_byte_for_pattern, [Query, :uint32_t], :uint32_t" do
    ret = TreeSitterFFI.ts_query_start_byte_for_pattern(@query_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_query_predicates_for_pattern, [Query, :uint32_t, :uint32_t_p], QueryPredicateStep.by_ref" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_predicates_for_pattern(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_query_is_pattern_guaranteed_at_step, [Query, :uint32_t], :bool" do
    ret = TreeSitterFFI.ts_query_is_pattern_guaranteed_at_step(@query_1, @uint32_t_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_query_capture_name_for_id, [Query, :uint32_t, :uint32_t_p], :string" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_capture_name_for_id(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_query_capture_quantifier_for_id, [Query, :uint32_t, :uint32_t], EnumQuantifier" do
    ret = TreeSitterFFI.ts_query_capture_quantifier_for_id(@query_1, @uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::EnumQuantifier).should == true
  end

  it ":ts_query_string_value_for_id, [Query, :uint32_t, :uint32_t_p], :string" do
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_string_value_for_id(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_query_disable_capture, [Query, :string, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_disable_capture(@query_1, @string_1, @uint32_t_1)
    # ret void
  end

  it ":ts_query_disable_pattern, [Query, :uint32_t], :void" do
    ret = TreeSitterFFI.ts_query_disable_pattern(@query_1, @uint32_t_1)
    # ret void
  end

end
