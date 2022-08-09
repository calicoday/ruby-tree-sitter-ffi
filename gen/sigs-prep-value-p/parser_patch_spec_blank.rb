# hacky hacky hacky -- generated by src/gen/spec_gen.rb, then COPIED and hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "parser_patch_spec_blank.rb" do
  before do
    @pars = TreeSitterFFI.parser
    @json = TreeSitterFFI.parser_json
    @pars.set_language(@json).should == true
    @input = "[1, null]"
    @tree = @pars.parse_string(nil, @input, @input.length)
  end
    
  it ":ts_parser_parse, [Parser, Tree, Input.by_value], Tree" do
    :ts_parser_parse.should == :FIXME
    ret = TreeSitterFFI.ts_parser_parse()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Tree).should == true
  end

  it ":ts_parser_set_cancellation_flag, [Parser, :size_p], :void" do
    :ts_parser_set_cancellation_flag.should == :FIXME
    # :size_p is Pointer
    ret = TreeSitterFFI.ts_parser_set_cancellation_flag()
    # ret void
  end

  it ":ts_parser_set_logger, [Parser, Logger.by_value], :void" do
    :ts_parser_set_logger.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_parser_set_logger()
    # ret void
  end

  # getting nil ret in the form of #<FFI::Pointer address=0x0000000000000000> ???!!!
  it ":ts_parser_logger, [Parser], Logger.by_value" do
    :ts_parser_logger.should == :FIXME # :not_impl
    ret = TreeSitterFFI.ts_parser_logger()
    ret.should_not == nil
    ret.is_a?(TreeSitterFFI::Logger).should == true
  end

end
