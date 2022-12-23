describe "0.20.7 query_raw_patch_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_1 = @build.obj(TreeSitterFFI::Query, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @uint32_t_2 = @build.obj(:uint32_t, 2)
  end

  it ":ts_query_predicates_for_pattern, [Query, :uint32_t, :uint32_t_p], QueryPredicateStep.by_ref" do
    :ts_query_predicates_for_pattern.should == :FIXME
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_predicates_for_pattern(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
  end

  it ":ts_query_is_pattern_rooted, [Query, :uint32_t], :bool" do
    :ts_query_is_pattern_rooted.should == :FIXME
    ret = TreeSitterFFI.ts_query_is_pattern_rooted(@query_1, @uint32_t_1)
    [true, false].include?(ret).should == true
  end

  it ":ts_query_is_pattern_guaranteed_at_step, [Query, :uint32_t], :bool" do
    :ts_query_is_pattern_guaranteed_at_step.should == :FIXME
    ret = TreeSitterFFI.ts_query_is_pattern_guaranteed_at_step(@query_1, @uint32_t_1)
    [true, false].include?(ret).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_capture_name_for_id, [Query, :uint32_t, :uint32_t_p], :string" do
    :ts_query_capture_name_for_id.should == :FIXME # :not_impl
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_capture_name_for_id(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_query_capture_quantifier_for_id, [Query, :uint32_t, :uint32_t], EnumQuantifier" do
    :ts_query_capture_quantifier_for_id.should == :FIXME
    ret = TreeSitterFFI.ts_query_capture_quantifier_for_id(@query_1, @uint32_t_1, @uint32_t_2)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::EnumQuantifier).should == true
  end

  # don't know what are acceptable arg values!!!
  it ":ts_query_string_value_for_id, [Query, :uint32_t, :uint32_t_p], :string" do
    :ts_query_string_value_for_id.should == :FIXME # :not_impl
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_string_value_for_id(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

end
