  #### new scaffolder for spec_gen config files!!!

  # This takes the boss.rb and completed boss_sigs.rb and produces 
  # boss_spec.rb and boss_patch_spec_blank.rb


# require './src/gen_runner.rb'
# require './gen/sigs-prep/node_sigs.rb'
# require './gen/sigs-prep/tree_sigs.rb'
# require './gen/sigs-prep/query_sigs.rb'
# require './gen/sigs-prep/parser_sigs.rb'
# shd be shunted!!! FIXME!!!
# require './src/tree-sitter-0.20.6/sigs-prep/boss_sigs.rb'
require './src/tree-sitter-0.20.6/sigs-prep/node_sigs.rb'
require './src/tree-sitter-0.20.6/sigs-prep/tree_sigs.rb'
require './src/tree-sitter-0.20.6/sigs-prep/query_sigs.rb'
require './src/tree-sitter-0.20.6/sigs-prep/parser_sigs.rb'

require 'ffi'
require 'awesome_print'

class String
  def line(depth=0) '  ' * depth + self + "\n" end
  # hang_line further splits on \s and joins with \n + indent(depth + 1)
end
class Array
  def join_indented(depth=0) self.join("\n" + '  ' * depth) end
end
# def tab() '  ' end


module GenSigs
  module_function
  
  def chg_type(type)
    case type
    when /:u?int\d+/ then 'Integer'
    when ':bool', ':void' then type
    when ':string' then 'String'
    when /[A-Z][\w.]+/ then type.split('.').first # is this bc by_ref, by_value???
    # FFI typedefs
    when ':adoptstring', ':strptr' then 'Array' 
    when ':pointer', ':uint32_p', ':size_p', ':array_of_range', 
      ':file_pointer', ':query_error_p'
      'Pointer'
    when ':symbol', ':field_id', ':file_descriptor' then 'Integer'
    else
      'WaitWhat'
    end
  end

  ref_all_types = [:void, :bool, :string, :char, :uchar, :short, :ushort, :int, :uint, :long, :ulong, :long_long, :ulong_long, :float, :double, :long_double, :pointer, :int8, :uint8, :int16, :uint16, :int32, :uint32, :int64, :uint64, :buffer_in, :buffer_out, :buffer_inout, :varargs, ]

  def chg_type_frag(type_frag)
    case type_frag
    when /:u?int\d+/ then 'Integer'
  #   when :char, :uchar, :short, :ushort, :int, :uint, :long, :ulong, :long_long, 
  #     :ulong_long, :int8, :uint8, :int16, :uint16, :int32, :uint32, :int64, :uint64
    when ':bool', ':void' then type_frag
    when ':string' then 'String'
    when /[A-Z][\w.]+/ then type_frag.split('.').first # is this bc by_ref, by_value???
    # FFI typedefs
    when ':adoptstring', ':strptr' then 'Array' 
    when ':pointer', ':uint32_p', ':size_p', ':array_of_range', 
      ':file_pointer', ':query_error_p'
      'Pointer'
    when ':symbol', ':field_id', ':file_descriptor' then 'Integer'
    else
      'WaitWhat'
    end
  end

  # add wrap_module_names???
  def qual_type(type)
    begin
      c = ::Kernel.const_get(type)
    rescue
      begin
        c = ::FFI.const_get(type)
        type = "FFI::#{type.to_s}"
      rescue
        # if type isn't recognized, assume it belongs to tree_sitter_ffi and qualify
        type = "TreeSitterFFI::#{type.to_s}"
      end
    end
    type
  end

  def mk_descr_head(label, before="")
    expected_result = <<-INDENTED_HEREDOC
# hacky hacky hacky -- generated by src/gen/spec_gen.rb, then COPIED and hand-tweaked

# this spec is only looking to check each ts_ call doesn't raise or crash and 
# returns the right type, given acceptable args

describe "#{label}" do
  before do
    #{before.map(&:strip).reject{|e| e.empty?}.join_indented(2) unless before.empty?}
  end
  
INDENTED_HEREDOC
  end

  ### from spec_gen_sigs_auto.rb

  # [89] pry(main)> val_p[-2..]
  # => "_p"
  # [90] pry(main)> 

  def value_pointer(type) # or type_p???
    puts "value_pointer type: #{type.inspect}"
    ::FFI::MemoryPointer.new(type, 1).put(type, 4)
  #   ::FFI::MemoryPointer.new(type, 1)
  end
  def de_skid(type_p) type_p.to_s.gsub(/_p$/, '').to_sym end

  def compose_dflt_arg(type)
    return nil if type == ':void' #raise???
    return "#{qual_type(type)}.new" unless type[0] == ':'
    skidless = de_skid(type)
    return "::FFI::MemoryPointer.new(#{skidless}, 1)" unless skidless == type
  #   return value_pointer(skidless) unless skidless == type
    case type
    when ':bool' then true
    when ':string' then 'ham' 
    when ':char', ':uchar' then 'b'.ord
    else
      5
    end
  end

  def compose_type_check()
  end

  def buf_wrap(s, depth, arg_types, arglist, &b)
    p_arr = arg_types.map{|e| e.is_a?(Array) ? e : nil}

    memp_arr = p_arr.map{|e| e[0]} # has nils!!!
    call_args = 
    # put head
    block_args = 
    s += "ret, *got = SpecUtil::bufs(#{memp_arr.inspect}) do |#{}|"
    yield(s, *memp_arr.reject(&:nil?))
    p_arr.each_with_index do |e, i|
      # put guts
    end
    # put tail
    # return s
    s
  end


  # [118] pry(main)> def reform_args(gather)
  # [118] pry(main)*   gather.map do |e|
  # [118] pry(main)*     e.is_a?(Array) ? e.flatten.join : e.split(', ')
  # [118] pry(main)*   end.flatten  
  # [118] pry(main)* end  
  # 
  # 		arr = e.split(/([{}()\\\[\]])/)
  # 
  # 		gather = nest_delims(arr, gather, gather_stack)

  # #	got = input.split(/([{}()\\\[\]])/)
  # def nest_delims(arr, inner, inners)
  def nest_delims(arr)
    inner = []
    inners = []
    while frag = arr.shift do
      case frag
      when ")", "}", "]"
        inner << frag
        inners[0] << inner # upper
        inner = inners.shift
      when "(", "{", "["
        inners.unshift(inner)
        inner = [frag]
      else
        inner << frag
      end
    end
    inner
  end

  def gather_args(s)
    arr = s.split(/([{}()\\\[\]])/)
    gather = nest_delims(arr)
    gather.map{|e| e.is_a?(Array) ? e.flatten.join : e.split(', ')}.flatten  
  end

  def mk_buf_type_check(type_frag, var_tag, depth, nil_ok)
    xpct_frag = chg_type_frag(type_frag)
    raise "uh-oh. mk_buf_type_check unknown type_frag: #{type_frag.inspect}" unless
      ['Integer', 'Float', 'String', 'Array'].include?(xpct_frag)
    "#{var_tag}.is_a?(#{xpct_frag}).should == true".line(depth)
  end

  def mk_type_check(type_frag, var_tag, depth, nil_ok)
    t = ""
    xpct_frag = chg_type_frag(type_frag)
    case xpct_frag
    when 'WaitWhat' 
      raise "uh-oh. mk_type_check bad type_frag: #{type_frag.inspect}, " +
        "xpct_frag: #{xpct_frag.inspect}"
    when ':void' then "# #{var_tag} void".line(depth)
    when ':bool' then "[true, false].include?(#{var_tag}).should == true".line(depth)
  #   when :buffer_in, :buffer_out, :buffer_inout, :varargs then # idk
    else
      # check FFI mapped type here??? parse our wrap_attach typedefs??? supply???
      # make wrap_typedefs???
      # nil check is meaningless if we've come back from bufs
  #     if ['Integer', 'Float', 'String', 'Array'].include?(xpct_frag) 
  #       return "#{var_tag}.is_a?(#{xpct_frag}).should == true".line(depth)
  #     end
  #     qual_ret = qual_type(xpct_frag)
      qual_ret = (['Integer', 'Float', 'String', 'Array'].include?(xpct_frag) ?
        xpct_frag : qual_type(xpct_frag))
      if nil_ok
        t += "# #{var_tag}.should_not == nil # nil return permitted".line(depth)
        t += "#{var_tag}.is_a?(#{qual_ret}).should == true if #{var_tag}".line(depth)
      else
        t += "#{var_tag}.should_not == nil".line(depth)
        t += "#{var_tag}.is_a?(#{qual_ret}).should == true".line(depth)
      end
    end
  end

  #     ret, *got = SpecUtil::bufs([:size_t_p]) do |flag_p| 
  # #       TreeSitterFFI.ts_parser_set_cancellation_flag(@pars, flag_p)
  #     end
  # 	  name = "TreeSitterFFI.#{c_name_sym}"
  # 	  call = "#{name}(#{arg_frags.join(', ')})"

  ### curr assume buf arg types are marked _p!!!

  #   arr = arg_frags.map do |e|
  #     # buf reqs need a type sym, may be wrapped with an initial value
  #     e = e[1..-2] if e[0] == '[' && e[-1] == ']'
  #     e[0] == ':' ?
  #       e.split(',').map(&:strip).compact :
  #       e
  #   end

  # === ts_parser_included_ranges: "@pars, [:uint32_p]", notes: [["# ret is array of Range, arg_1 is pointer to array len."]]
  #   {"arg_1"=>[":uint32_p"]}

  # bc frag_4 is :utf8 !!! FIXME!!! prob enum!!!
  # === ts_parser_parse_string_encoding: "@pars, @tree, \"blurg\", 5, :utf8", notes: []
  #   {"arg_4"=>[":utf8"]}

  def mk_buf_check(arg_frag, arg_type, depth)
  end

  def mk_it_guts_wrap(name, arg_frags, ret, depth, nil_ok)
    # arg_frags is array of strings|sym|array. strings are not to be interpolated.
    h = {}
    arg_frags.each_with_index do |e, i|
      # buf reqs need a type sym, may be wrapped with an initial value
  #     h["arg_#{i}"] = (e.is_a?(Symbol) ? [e] : e)
      v = (e.is_a?(Symbol) ? [e] : e)
      k = (v.is_a?(String) ? e : "arg_#{i}")
      h[k] = v
    end
    p_hash = h.select{|k,v| v.is_a?(Array)}
  
    s = ""
    name = "TreeSitterFFI.#{name}"
    call = "#{name}(#{arg_frags.join(', ')})"
  #   call = "#{name}(#{arglist})"

    if p_hash.empty?
      return "ret = #{call}".line(depth) + mk_type_check(ret, 'ret', depth, nil_ok)
    end
    puts "  #{p_hash.inspect}"
  #   return "ret = #{call}".line(depth) + mk_type_check(ret, 'ret', depth, nil_ok)

    # recompose arglist with dflt h.keys
    call = "#{name}(#{h.keys.join(', ')})"
  
    ap p_hash
    puts "  ** #{p_hash.values.map{|e| e[0]}}"
    bufs_types = p_hash.values.map{|e| e[0]} # leave _p for bufs!!!
    bufs_call = "SpecUtil::bufs(#{bufs_types.inspect})"
  #   bufs_call = "SpecUtil::bufs(#{p_hash.keys.inspect})"
  
    # ret, got_h ???
  #   s += "ret, *got = #{call} do |b_args|".line(depth)
    s += "ret, *got = #{bufs_call} do |#{p_hash.keys.join(', ')}|".line(depth)
    s += "#{call}".line(depth + 1)
    s += "end".line(depth)
    p_hash.values.each_with_index do |e, i|
      # de_skid just in case
      type = e.to_s.gsub(/_p$/, '').to_sym
      s += mk_buf_type_check(type, "got[#{i}]", depth, false) # nil_ok???
    end
    s += mk_type_check(ret, 'ret', depth, nil_ok)
    # type checks for b_args
    return s
  
    # p_arr.each do make a memp and b_arg_frag
    p_hash.each do |k, v|
    end
  end


  # def mk_it_guts_pre(name, args_arr, depth, nil_ok)
  def mk_it_guts_pre(name, args_arr, ret, depth, nil_ok)
    s = ""
    name = "TreeSitterFFI.#{name}"
    call = "#{name}(#{args_arr.join(', ')})"
  #   call = "#{name}(#{arglist})"
    s += "ret = #{call}".line(depth)
    s += mk_type_check(ret, 'ret', depth, nil_ok)
  #   s += mk_base_checks(ret, depth, nil_ok)
  end

  def mk_it_all(c_name_sym, label, arg_types, ret, prep, depth=1, &b)
    # make the it, then add it to the spec or patch, as approp, and return both

    # arglist from prep is now a string of comma sepd. split to count, write out as is!!!
    entry = prep.sig(c_name_sym.to_sym)
    entry = [entry] unless entry.is_a?(Array)
    arglist, *notes = entry
  
    # if the last member of entry is a Hash, it is opts
    opts = (notes && notes.last && notes.last.is_a?(Hash) ? notes.pop : {})
  
    notes = [] unless notes
    notes = [notes] unless notes.is_a?(Array)
  
    puts "=== #{c_name_sym}: #{arglist.inspect}, notes: #{notes.inspect}"
  
    # patch gets a symbol reason (not true or false) or nil if no patch
    patch = nil
    # if arglist is nil, the it needs a patch, so just stub it and move on
    patch = :nil_arglist unless arglist
    patch = :not_impl if opts[:not_impl] # still patch but we expected it
    
    arglist = "" unless arglist
  
    s = ""
  
    if notes.first.is_a?(Array)
      outerlist = notes.shift 
      outer = outerlist.map(&:strip).reject{|e| e.empty?}.join_indented(depth)
      s += "#{outer}".line(depth)
    end  

    s += "it \"#{label}\" do".line(depth)
    depth += 1

    if patch
      # bc :not_impl or :nil_arglist
      t = ":#{c_name_sym}.should == :FIXME"
      t += " # :not_impl" if patch == :not_impl
      s += t.line(depth)
    end
    
    unless notes.empty?
      inner = notes.map(&:strip).reject{|e| e.empty?}.join_indented(depth)
      s += "#{inner}".line(depth)
    end

  
    ### new!!! arglist is a single string or array of string|sym|array.
    # strings don't get interpolated, so you have to break them out in the prep
    # if you want bufs!!!
    hacking = true
    args_arr = (arglist.is_a?(Array) ? arglist : gather_args(arglist).map(&:strip))
  #   args_arr = gather_args(arglist).map(&:strip)
    unless hacking || arglist.empty? || arg_types.length == args_arr.length
      raise "prep wrong number of args for #{label}"
    end
    ### consider defaults for unspecified args (all or some?)!!!
  #   puts "  ** args_arr: #{args_arr.inspect}" unless args_arr.empty?
  


    s += mk_it_guts_wrap(c_name_sym, args_arr, ret, depth, opts[:nil_ok])
  #   s += mk_it_guts_pre(c_name_sym, args_arr, ret, depth, opts[:nil_ok])
  
    depth -= 1
    s += "end".line(depth).line
  
    # if patch is not nil, the spec gets a stub and the it goes to the patch
    # return [spec, patch]
    patch ?
      ["# #{label} # to patch".line(depth).line, s] :
      [s, nil] 

  end


  def cut_prefix(prefix, c_name)
    # if prefix matches, return amended method name
    prefix = prefix[1..-1] # chop : but leave it string!!!
    prefix == c_name[0, prefix.length] ? c_name[prefix.length..-1] : nil
  end

  def compose_c(label, prefix, c_name_sym, arg_types, ret_type, prep)
    ret = chg_type(ret_type)
    c_name = c_name_sym

    mk_it_all(c_name_sym, label, arg_types, ret, prep) do |args|
      name = "TreeSitterFFI.#{c_name}"
      call = "#{name}(#{args})"
    end
  end

  def gen_sigs(filer)
    ['node', 'parser', 'query', 'tree'].each do |bosstag|
      filer.write_open(:out, :out_ts, "#{bosstag}_sigs_spec.rb", 'w')
      filer.write_open(:out, :out_patch, "#{bosstag}_patch_spec_blank.rb", 'w')

      klass = bosstag.capitalize + 'Sigs'
      prep = Object::const_get(klass).new
  
      # head
      before = prep.before
      before = [before] unless before.is_a?(Array)
      before = before.map{|e| e.gsub("\t", '  ')} # detab -- do better!!! FIXME!!!

      filer.write_some(:out_ts, mk_descr_head("#{bosstag}_sigs_spec.rb", before))
      filer.write_some(:out_patch, mk_descr_head("#{bosstag}_patch_spec_blank.rb", before))

      s = filer.read(:input, "#{bosstag}.rb")
  
      calls = s.scan(/wrap_attach\(([^)]+)\)/)
  
  
  
      calls.each do |wrap|
        wrap.each do |w|
          # eg ":ts_node_, [\n\t\t\t[:ts_node_type, [Node.by_value], :string],\n\t..."
          parts = w.scan(/^\s*(:\w+),\s*(.*)/m).flatten
          prefix, entries = parts
          boss = prefix.gsub(/:ts_(\w+)_/, '\1') ###unused???
          entries = w.scan(/\[\s*:[^\]]*\[[^\]]*\][^\]]*\]/)
          entries = entries.map{|e| e.gsub(/\s+/, ' ')}
    #       entries.map do |entry|
          entries.each do |entry|
            # eg ":ts_node_type, [Node.by_value], :string"
            segs = entry.gsub(/\[\s*(:\w+),\s*\[([^\]]*)\],\s*(:?[\w\d.]+)\].*/, 
              '\1@\2@\3').split('@')
            name, arg_types, ret_type = segs
            # name looks like ":ts_name", chop : but leave it string!!!
            name = name[1..-1]
            arg_types = arg_types.split(', ')
    #         e = [entry[1..-2], prefix, name, arg_types, ret_type]

            label = entry[1..-2]
            ret = chg_type(ret_type)
            spec, patch = mk_it_all(name, label, arg_types, ret, prep)
            filer.write_some(:out_ts, spec)
            filer.write_some(:out_patch, patch) if patch
          end
        end
      end

      # tail
      filer.write_some(:out_ts, "end\n")
      filer.write_some(:out_patch, "end\n")
  
      filer.write_close(:out_ts)
      filer.write_close(:out_patch)
    end
  end
  
  # # name it *.rb, so any syntax highlighting will be ruby
  # puts "Writing diff -r sigs-keep/ sigs/ to sigs_diff.rb..."
  # `diff -r -x.* ./gen/sigs-keep ./gen/sigs > ./gen/sigs_diff.rb`

#   puts "done."
end