describe "0.20.0 query_raw_patch_spec.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @query_1 = @build.obj(TreeSitterFFI::Query, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
  end

  it ":ts_query_predicates_for_pattern, [Query, :uint32_t, :uint32_t_p], QueryPredicateStep.by_ref" do
    :ts_query_predicates_for_pattern.should == :FIXME
    ret, *got = BossFFI::bufs([:uint32_t_p]) do |uint32_t_p_1|
      TreeSitterFFI.ts_query_predicates_for_pattern(@query_1, @uint32_t_1, uint32_t_p_1)
    end
    ret.should_not == nil
    (ret.is_a?(FFI::Pointer) || ret.is_a?(FFI::Struct)).should == true
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
