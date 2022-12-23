describe "0.20.7 language_tidy_stub.rb" do
  before do
    @build = TreeSitterFFI::SpecObjBuild.new
    @language_1 = @build.obj(TreeSitterFFI::Language, 1)
    @symbol_1 = @build.obj(:symbol, 1)
    @string_1 = @build.obj(:string, 1)
    @uint32_t_1 = @build.obj(:uint32_t, 1)
    @bool_1 = @build.obj(:bool, 1)
    @field_id_1 = @build.obj(:field_id, 1)
  end

  it "symbol_count() => :uint32_t" do
    ret = @language_1.symbol_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "symbol_name(symbol_1) => :string" do
    ret = @language_1.symbol_name(@symbol_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "symbol_for_name(string_1, uint32_t_1, bool_1) => :symbol" do
    ret = @language_1.symbol_for_name(@string_1, @uint32_t_1, @bool_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "field_count() => :uint32_t" do
    ret = @language_1.field_count()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "field_name_for_id(field_id_1) => :string" do
    ret = @language_1.field_name_for_id(@field_id_1)
    ret.should_not == nil
    ret.is_a?(String).should == true
  end

  it "field_id_for_name(string_1, uint32_t_1) => :field_id" do
    ret = @language_1.field_id_for_name(@string_1, @uint32_t_1)
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

  it "symbol_type(symbol_1) => EnumSymbolType" do
    ret = @language_1.symbol_type(@symbol_1)
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::EnumSymbolType).should == true
  end

  it "version() => :uint32_t" do
    ret = @language_1.version()
    ret.should_not == nil
    ret.is_a?(Integer).should == true
  end

end
