#!/usr/bin/env ruby ### is this actually portable???

require 'fileutils'

require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require './src/filer.rb'
require './src/sigs/gen_sigs_prep.rb'
require './src/rusty/gen_rusty.rb'
require './src/sigs/gen_sigs.rb'

### also script, 'if File.identical?(__FILE__, $0)' at end


module DevRunner

  def self.shunt(vers, dev=true)
    devmark = (dev ? 'dev-' : '') # so we can find pulled!!!
#     devmark = 'dev-' # always dev!!! mv dir after, if you like!!!
    shunt = "#{devmark}tree-sitter-#{vers}/" # pathname!!!
  end
  def self.gendir(vers, dev=true) 
    Pathname.new('gen/') + (vers ? shunt(vers, dev) : '') 
  end
  def self.srcdir(vers, dev=true) 
    Pathname.new('src/') + (vers ? shunt(vers, dev) : '') 
  end
  
  def self.was_all(vers)
    pull(vers)
    sigs_prep(vers)
    gen_rusty(vers)
    gen_sigs(vers)
  end
  
  # prob unnec bc need to edit between!!!
  def self.all(vers)
    all_prep(vers)
    all_gen(vers)
  end
  
  def self.all_prep(vers)
    puts "*** DevRunner all_prep pull(#{vers})..."
    pull(vers)
    puts
    puts "*** DevRunner all_prep sigs_prep(#{vers})..."
    sigs_prep(vers)
    puts
    #rusty_prep(vers)
  end
  def self.all_gen(vers)
    puts "*** DevRunner all_gen rusty(#{vers})..."
    gen_rusty(vers)
    puts
    puts "*** DevRunner all_gen sigs(#{vers})..."
    gen_sigs(vers)
    puts
  end
#   def self.all_run(vers)
#     # ??? cmdline w opts??? or just rakefile???
#   end
  
  
  def self.pull(vers)
    show = ShowRunner.new
    cwd = FileUtils.pwd ### do better!!!
    rundir = gendir(vers) + 'pull/'
    repo_root = "https://github.com/tree-sitter/tree-sitter/" # org + name
    subdirs = {'lib/include/tree_sitter/' => {scrap: ['.svn']}, 
      'cli/src/tests/' => {keep: %w%node_test.rs tree_test.rs query_test.rs%}
      }
    dest = "tree-sitter-#{vers}" # nec??? or just 'tree-sitter'??? FIXME!!!
    RepoRefs.do_one_thing(show, rundir, repo_root, subdirs, vers, dest)
    FileUtils.cd(cwd) # bk to start!!!
  end
  
#   def self.sigs_prep_to_edit(vers, dev=true)
#     puts "DevRunner.sigs_prep_to_edit..."
#     # copy and rename _blanks to src/
#     shunt = shunt(vers, dev)
#     blankdir = gendir(shunt) + 'sigs-prep/'
#     # ensure prepdir
#     prepdir = srcdir(shunt) + 'sigs-prep/'
#     blanks = Dir.children(blankdir).select{|e| e =~ '_blank.rb'}
#     blanks.each do |e|
#       FileUtils.cp(e, e.gsub(/_blank\.rb/, ''))
#     end
#     puts "done."
#   end
  
  # in:
  # - lib/tree_sitter_ffi/
  # out:
  # - src/shunt/sigs-prep/
  def self.sigs_prep(vers)
    ### vers for lib!!! FIXME!!!
    filer = Filer.new({input: 'lib/tree_sitter_ffi'}, 
      {out: gendir(vers) + 'sigs-prep/'})
    GenSigsPrep.gen_sigs_prep(filer)    
    puts "done."
  end
  
  # not a thing yet!!!
#   def self.rusty_prep(vers, dev=true)
#     shunt = shunt(vers, dev)
#     
#     filer = Filer.new({src: srcdir('') + 'sigs-prep/', # for tmplts, no shunt!!!
#       input: './lib/tree_sitter_ffi'}, 
#       {out: gendir(shunt) + 'sigs-prep/'})
#     
#   end

  
  # in:
  #   - input: gen/devshunt/pull/*_test.rs
  #   - tmplt: src/rusty/rusty_*.rb.erb
  # out:
  #   - out: gen/shunt/rusty/*_rusty[_patch_blank]?.rb
  #   tmp -> gen/shunt/rusty/rusty_*_[test|_patch_blank].rb
  def self.gen_rusty(vers)
    $log = File.open('log/' + 'gen_rusty_log.txt', 'w') ###TMP!!! use filer!!! FIXME!!!
    # input from pull/ needs dbl shunt
    filer = Filer.new(
      {input: gendir(vers) + 'pull/' + shunt(vers, false) + 'cli/src/tests/', # dbl shunt!!!
        tmplt: srcdir(nil) + 'rusty/', # no devmark
        reqs: srcdir(vers, false) + 'rusty-prep/', # for composing requires
        },
      {out: gendir(vers) + 'rusty/'})
      # log: ???
      
    
    #
    RustyGen.gen_rusty(filer, ["node", "tree", "query"])
    $log.close
    puts "done."
  end
  
  def self.gen_sigs(vers)
    filer = Filer.new({input: 'lib/tree_sitter_ffi'}, 
      {out: gendir(vers) + 'sigs/'})
    GenSigs.gen_sigs(filer)    
    puts "done."
  end
  
end

def do_the_thing(cmd, vers, tee=true)
  req = "require './src/dev_runner.rb'"
  call = "DevRunner.#{cmd}('#{vers}')"
  ruby_prog = "ruby -e\"#{req}; #{call}\" 2>&1"
  
  prog = case cmd
  when 'run_rusty_stubs'
    "ruby gen/dev-tree-sitter-#{vers}/rusty/run_rusty_stubs.rb 2>&1" 
  when 'run_rusty'
    "ruby gen/dev-tree-sitter-#{vers}/rusty/run_rusty.rb 2>&1" 
  when 'run_sigs'
    "rspec gen/dev-tree-sitter-#{vers}/sigs 2>&1" # redirect? 
  when 'run_sigs_blanks'
    # not really useful but this is how we'll do it for patch (in src/ not gen/dev-)
    "rspec gen/dev-tree-sitter-#{vers}/sigs gen/dev-tree-sitter-#{vers}/sigs/*_blank.rb 2>&1" # redirect? 
  else
    ruby_prog
  end

  logfile = "#{cmd}_#{vers}_log.txt"
  FileUtils.mkdir_p('log/')
  tee_log = (tee ? " | tee log/#{logfile}" : '')
  puts "DevRunner calling #{prog + tee_log}..."
  system(prog + tee_log)
  puts "done."
end

# run from cmdline, add getopts???
if File.identical?(__FILE__, $0)
  unless ARGV.length > 0
    puts "Usage: ruby dev_runner.rb cmd [vers]"
    exit 1
  end
  cmd, vers, _ = ARGV
  vers = '0.20.0' unless vers # or whatever is most likely currently
  do_the_thing(cmd, vers)
end
  
  
  
# gen/
#   dev-tree-sitter-0.20.7/
#     pull/
#     rusty/
#     rusty-prep/ _blanks
#     sigs/
#     sigs-prep/ _blanks
#     log/
#       
#   dev-tree-sitter-nightly/
#   tree-sitter-0.20.6/
#   
# src/
#   dev-tree-sitter-0.20.7/
#     pull/
#     rusty/
#     rusty-prep/ copied _blanks -- to EDIT, ensure
#     sigs/
#     sigs-prep/ copied _blanks -- to EDIT, ensure
#   
#   
# some ops can only be done on dev- runbases
# - pull - any
