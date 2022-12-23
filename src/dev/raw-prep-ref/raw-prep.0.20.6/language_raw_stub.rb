describe "0.20.6 language_raw_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @language_1 = @build.obj(TreeSitterFFI::Language, 1)
    @symbol_1 = @build.obj(:symbol, 1)
    @string_1 = @build.obj(:string, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @bool_1 = @build.obj(:bool, 1)
    @field_id_1 = @build.obj(:field_id, 1)
  end

  it ":ts_language_symbol_count, [Language], :uint32_t" do
    ret = TreeSitterFFI.ts_language_symbol_count(@language_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_language_symbol_name, [Language, :symbol], :string" do
    ret = TreeSitterFFI.ts_language_symbol_name(@language_1, @symbol_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_language_symbol_for_name, [Language, :string, :uint32_t, :bool], :symbol" do
    ret = TreeSitterFFI.ts_language_symbol_for_name(@language_1, @string_1, @uint32_t_1, @bool_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_language_field_count, [Language], :uint32_t" do
    ret = TreeSitterFFI.ts_language_field_count(@language_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_language_field_name_for_id, [Language, :field_id], :string" do
    ret = TreeSitterFFI.ts_language_field_name_for_id(@language_1, @field_id_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it ":ts_language_field_id_for_name, [Language, :string, :uint32_t], :field_id" do
    ret = TreeSitterFFI.ts_language_field_id_for_name(@language_1, @string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it ":ts_language_symbol_type, [Language, :symbol], EnumSymbolType" do
    ret = TreeSitterFFI.ts_language_symbol_type(@language_1, @symbol_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::EnumSymbolType).should == true
  end

  it ":ts_language_version, [Language], :uint32_t" do
    ret = TreeSitterFFI.ts_language_version(@language_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

end
