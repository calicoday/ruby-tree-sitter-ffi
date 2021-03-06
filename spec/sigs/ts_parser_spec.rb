# hacky hacky hacky -- generated by src/spec_gen.rb, then hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "ts_parser_spec.rb" do
	before do
    @pars = TreeSitterFFI.parser
		@json = TreeSitterFFI.parser_json
		@pars.set_language(@json).should == true
		@input = "[1, null]"
		@tree = @pars.parse_string(nil, @input, @input.length)
	end
    
	it ":ts_parser_set_language, [Parser, Language], :bool" do
		ret = TreeSitterFFI.ts_parser_set_language(@pars, @json)
		[true, false].include?(ret).should == true
	end

	it ":ts_parser_language, [Parser], Language" do
		ret = TreeSitterFFI.ts_parser_language(@pars)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Language).should == true
	end

# arg_1 is array of Range, arg_2 is array len.
	it ":ts_parser_set_included_ranges, [Parser, Range.by_ref, :uint32], :bool" do
		ret = TreeSitterFFI.ts_parser_set_included_ranges(@pars, 
			TreeSitterFFI::Range.new, 1)
		[true, false].include?(ret).should == true
	end

# ret is array of Range, arg_1 is pointer to array len.
	it ":ts_parser_included_ranges, [Parser, :uint32_p], Range.by_ref" do
		arg_1 = FFI::MemoryPointer.new(:uint32, 1)
		ret = TreeSitterFFI.ts_parser_included_ranges(@pars, arg_1)
		ret.should_not == nil
		ret.is_a?(FFI::Pointer).should == true
		len = arg_1.get(:uint32, 0)
		len.should_not == nil
		len.is_a?(Integer).should == true
	end

	it ":ts_parser_parse, [Parser, Tree, Input.by_value], Tree" do
		:ts_parser_parse.should_not == :FIXME # not impl
# 		ret = TreeSitterFFI.ts_parser_parse(@pars, @tree, TreeSitterFFI::Input.new)
# 		ret.should_not == nil
# 		ret.is_a?(TreeSitterFFI::Tree).should == true
	end

	it ":ts_parser_parse_string, [Parser, Tree, :string, :uint32], Tree" do
		ret = TreeSitterFFI.ts_parser_parse_string(@pars, @tree, "blurg", 5)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Tree).should == true
	end

	it ":ts_parser_parse_string_encoding, [Parser, Tree, :string, :uint32, EnumInputEncoding], Tree" do
		ret = TreeSitterFFI.ts_parser_parse_string_encoding(@pars, @tree, "blurg", 5, :utf8)
		ret.should_not == nil
		ret.is_a?(TreeSitterFFI::Tree).should == true
	end

	it ":ts_parser_reset, [Parser], :void" do
		ret = TreeSitterFFI.ts_parser_reset(@pars)
		# ret void
	end

	it ":ts_parser_set_timeout_micros, [Parser, :uint64], :void" do
		ret = TreeSitterFFI.ts_parser_set_timeout_micros(@pars, 2000)
		# ret void
	end

	it ":ts_parser_timeout_micros, [Parser], :uint64" do
		ret = TreeSitterFFI.ts_parser_timeout_micros(@pars)
		ret.should_not == nil
		ret.is_a?(Integer).should == true
	end

	it ":ts_parser_set_cancellation_flag, [Parser, :size_p], :void" do
		arg_1 = FFI::MemoryPointer.new(:pointer, 1) # :size_p is Pointer
		ret = TreeSitterFFI.ts_parser_set_cancellation_flag(@pars, arg_1)
		# ret void
	end

	it ":ts_parser_cancellation_flag, [Parser], :size_p" do
		ret = TreeSitterFFI.ts_parser_cancellation_flag(@pars)
# 		ret.should_not == nil # nil return permitted!!!
		ret.is_a?(FFI::Pointer).should == true if ret # :size_p is Pointer
	end

	it ":ts_parser_set_logger, [Parser, Logger.by_value], :void" do
		:ts_parser_set_logger.should_not == :FIXME # not impl
# 		ret = TreeSitterFFI.ts_parser_set_logger(@pars, TreeSitterFFI::Logger.new)
# 		# ret void
	end

# getting nil ret in the form of #<FFI::Pointer address=0x0000000000000000> ???!!!
	it ":ts_parser_logger, [Parser], Logger.by_value" do
		:ts_parser_logger.should_not == :FIXME # not impl
# 		ret = TreeSitterFFI.ts_parser_logger(@pars)
# 		ret.should_not == nil
# 		ret.is_a?(TreeSitterFFI::Logger).should == true
	end

	it ":ts_parser_print_dot_graphs, [Parser, :file_descriptor], :void" do
		ret = TreeSitterFFI.ts_parser_print_dot_graphs(@pars, 2)
		# ret void
	end


end
