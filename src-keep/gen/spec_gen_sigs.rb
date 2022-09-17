#### new scaffolder for spec_gen config files!!!

# This takes the boss.rb and completed boss_sigs.rb and produces 
# boss_spec.rb and patch_boss_spec.rb


require './src/gen/gen_runner.rb'
require './src/gen/spec_gen_prep/node_sigs.rb'
require './src/gen/spec_gen_prep/tree_sigs.rb'
require './src/gen/spec_gen_prep/query_sigs.rb'
require './src/gen/spec_gen_prep/parser_sigs.rb'

require 'ffi'

# spec_gen.rb is a throw-away, bootstrap script to generate blunt tests for each 
# function sig of the main boss classes (and their mod.ts_ equivalents).
# There is definitely a role for such a script but this is exactly the
# sort of thing better done with a proper language parser not regexps.
# To be continued.

# Re source code style, the script is not comment-aware. Do not put comments within 
# a wrap_attach() entry (eg when it's broken over several lines and you want to 
# note some particular arg) and any whole entries or wrap_attach() blocks 
# commented out will get picked up. Outside of wrap_attach(), everything is ignored.

# 	typedef :pointer, :blang
# 	typedef :strptr, :adoptstring
# 	typedef :uint16, :symbol
# 	typedef :uint16, :field_id
# 	typedef :pointer, :size_p

# procedure:
# $ ruby src/gen/gen_sigs_blank.rb
# => writes a src/gen/spec_gen_prep/boss_sigs_blank.rb for each boss
# $ cp boss_sigs_blank.rb boss_sigs.rb 
# - edit boss_sibs.rb to add arglists and notes
# $ ruby src/gen/spec_gen_sigs.rb
# => writes for each boss a gen/sigs/boss_sigs_spec.rb and boss_patch_spec_blank.rb
#$ cp boss_patch_spec_blank.rb boss_patch_spec.rb
# - edit boss_patch_spec.rb with custom its

# fixes todo:
# - version!!!
# - dirs should end in '/', not filenames start with it
# - sigs notes are intended to be comments -- gen the hash (when we add indenting???)
# - need to strip notes and line break. Curr \n in arglist is fine but
#   in notes will result in broken comments!!! see :ts_node_child.
#   Also arglist needs to be detabbed!!!
# - only create boss_patch_spec_blank.rb if there ARE patches
# - :nil_ok shd add 'if ret' to type check. DONE. CONF!!!
# - note: should_not == :FIXME in patch bc :not_impl in prep or just nil arglist!!!

def chg_type(type)
	case type
	when /:u?int\d+/ then 'Integer'
	when ':bool', ':void' then type
	when ':string' then 'String'
	when /[A-Z][\w.]+/ then type.split('.').first
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

### check this poss with 'retry':
# def send_messages_maybe(object, messages, *parameters)
#   object.send(messages.first, *parameters)
# rescue NoMethodError
#   messages = messages[1..-1]
#   if messages.empty?
#     warn "Object does not respond to basic methods!"
#   else
#     retry
#   end
# end
# 
# module Quux
#   def quux(*args)
#     puts "quux method called with #{args.inspect}"
#   end
# end
# 
# messages = %i{foo bar quux}
# send_messages_maybe(Object.new, messages)
# send_messages_maybe(Object.new.extend(Quux), messages, 10, :hello, 'world')

def qual_type(type)
  puts "  type: #{type.inspect}"
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
	puts "  qual: #{type.inspect}"
	type
end

class String
  def line(depth=0) '  ' * depth + self + "\n" end
  # hang_line further splits on \s and joins with \n + indent(depth + 1)
end
class Array
  def join_indented(depth=0) self.join("\n" + '  ' * depth) end
end
# def tab() '  ' end

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
  arglist = arglist.gsub("\t", '  ') # detab -- do better!!! FIXME!!!
  
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
  
  unless arglist.empty? || arglist.split(',').length == arg_types.length
    ### label lists args ts_ style, ie with obj included first, but prep asks
    # only for the other args!!! awkward!!!
    raise "prep wrong number of args for #{label}"
  end
  ### consider defaults for unspecified args (all or some?)!!!

		
	call = yield(arglist)
		
	s += case ret
  when ':void'
    t = "ret = #{call}".line(depth)
		t += "# ret void".line(depth)
	when ':bool'
    t = "ret = #{call}".line(depth)
		t += "[true, false].include?(ret).should == true".line(depth)
	else
    t = ""
    # and then the boilerplate stuff to start with, in sigs or patch
    t += "ret = #{call}".line(depth)
	  qual_ret = (ret.is_a?(Symbol) ? ret : qual_type(ret))
	  if opts[:nil_ok]
      t += "# ret.should_not == nil # nil return permitted".line(depth)
      t += "ret.is_a?(#{qual_ret}).should == true if ret".line(depth)
	  else
      t += "ret.should_not == nil".line(depth)
      t += "ret.is_a?(#{qual_ret}).should == true".line(depth)
		end
	end

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

devdir = './src/gen'
gendir = './gen'
outdir = gendir + '/sigs-prep'
srcdir = './lib/tree_sitter_ffi'

runner = GenRunner.new
runner.legacy_prepare_dirs(srcdir, gendir, outdir, devdir, true) #womping

  

['node', 'tree', 'parser', 'query'].each do |bosstag|
  runner.write_open(:out, :out_ts, "/#{bosstag}_sigs_spec.rb", 'w')
  runner.write_open(:out, :out_patch, "/#{bosstag}_patch_spec_blank.rb", 'w')

  klass = bosstag.capitalize + 'Sigs'
  prep = Object::const_get(klass).new
  
  # head
  before = prep.before
  before = [before] unless before.is_a?(Array)
  before = before.map{|e| e.gsub("\t", '  ')} # detab -- do better!!! FIXME!!!

  runner.write_some(:out_ts, mk_descr_head("#{bosstag}_sigs_spec.rb", before))
  runner.write_some(:out_patch, mk_descr_head("#{bosstag}_patch_spec_blank.rb", before))

  s = runner.read(:src, "/#{bosstag}.rb")
  
  calls = s.scan(/wrap_attach\(([^)]+)\)/)
  
  
  
  calls.each do |wrap|
    wrap.each do |w|
      # eg ":ts_node_, [\n\t\t\t[:ts_node_type, [Node.by_value], :string],\n\t..."
      parts = w.scan(/^\s*(:\w+),\s*(.*)/m).flatten
      prefix, entries = parts
      boss = prefix.gsub(/:ts_(\w+)_/, '\1') ###unused???
      entries = w.scan(/\[\s*:[^\]]*\[[^\]]*\][^\]]*\]/)
      entries = entries.map{|e| e.gsub(/\s+/, ' ')}
      entries.map do |entry|
        # eg ":ts_node_type, [Node.by_value], :string"
        segs = entry.gsub(/\[\s*(:\w+),\s*\[([^\]]*)\],\s*(:?[\w\d.]+)\].*/, 
          '\1@\2@\3').split('@')
        name, arg_types, ret_type = segs
        # name looks like ":ts_name", chop : but leave it string!!!
        name = name[1..-1]
        arg_types = arg_types.split(', ')
        e = [entry[1..-2], prefix, name, arg_types, ret_type]

#         runner.write_some(:out_ts, compose_c(*e, prep))
        spec, patch = compose_c(*e, prep)
        runner.write_some(:out_ts, spec)
        runner.write_some(:out_patch, patch) if patch
        
        e
      end
    end
  end

  # tail
  runner.write_some(:out_ts, "end\n")
  runner.write_some(:out_patch, "end\n")
  
  runner.write_close(:out_ts)
  runner.write_close(:out_patch)
end
	
# # name it *.rb, so any syntax highlighting will be ruby
# puts "Writing diff -r sigs-keep/ sigs/ to sigs_diff.rb..."
# `diff -r -x.* ./gen/sigs-keep ./gen/sigs > ./gen/sigs_diff.rb`

puts "done."