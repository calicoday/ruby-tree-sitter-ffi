# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_language_spec.rb" do
	before do
	end
    
	it ":ts_language_symbol_count, [Language], :uint32" do
		ret = TreeSitterFFI.ts_language_symbol_count(language_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_language_symbol_name, [Language, :symbol], :uint32" do
		ret = TreeSitterFFI.ts_language_symbol_name(language_0, arg_1)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_language_symbol_for_name, [Language, :string, :uint32, :bool], :symbol" do
		ret = TreeSitterFFI.ts_language_symbol_for_name(language_0, arg_1, arg_2, arg_3)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_language_field_count, [Language], :uint32" do
		ret = TreeSitterFFI.ts_language_field_count(language_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_language_field_name_for_id, [Language, :field_id], :string" do
		ret = TreeSitterFFI.ts_language_field_name_for_id(language_0, arg_1)
		ret.should_not == nil
		ret.is_a?(String).should == true
	end

	it ":ts_language_field_id_for_name, [Language, :string, :uint32], :field_id" do
		ret = TreeSitterFFI.ts_language_field_id_for_name(language_0, arg_1, arg_2)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_language_symbol_type, [Language, :symbol], SymbolType" do
		ret = TreeSitterFFI.ts_language_symbol_type(language_0, arg_1)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::SymbolType).should == true
	end

	it ":ts_language_version, [Language], :uint32" do
		ret = TreeSitterFFI.ts_language_version(language_0)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end


end
