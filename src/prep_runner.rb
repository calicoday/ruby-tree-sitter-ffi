require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require 'fileutils'
require './src/filer.rb'
require './src/sigs/gen_sigs_prep.rb'
require './src/rusty/gen_rusty.rb'
require './src/sigs/gen_sigs.rb'

# gen
# $ ruby -e"require './src/prep_runner.rb'; PrepRunner.pull('0.20.6')"
# $ ruby -e"require './src/prep_runner.rb'; PrepRunner.sigs_prep('0.20.6')"
# $ ruby -e"require './src/prep_runner.rb'; PrepRunner.rusty('0.20.6')"
# $ ruby -e"require './src/prep_runner.rb'; PrepRunner.sigs('0.20.6')"
# $ ruby -e"require './src/prep_runner.rb'; PrepRunner.all('0.20.6')"

# run
# $ ruby gen/dev-tree-sitter-0.20.0/rusty/run_rusty_stubs.rb 2>&1 | tee log/run_rusty_stubs_0.20.0_log.txt
# $ rspec gen/dev-tree-sitter-0.20.0/sigs 2>&1 | tee log/run_sigs_0.20.0_log.txt


module PrepRunner

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
#   def self.gendir(vers, dev=true) Pathname.new('gen/') + shunt(vers, dev) end
#   def self.srcdir(vers, dev=true) Pathname.new('src/') + shunt(vers, dev) end
#   def self.srcdir(vers, dev=false) Pathname.new('src/') + shunt(vers, dev) end
  
  def self.all(vers)
    pull(vers)
    sigs_prep(vers)
    rusty(vers)
    sigs(vers)
  end
  
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
#     puts "PrepRunner.sigs_prep_to_edit..."
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
  def self.rusty(vers)
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
  
#     devdir = './gen/sigs-prep'
#     # devdir = './src/sigs'
#     gendir = './gen'
#     outdir = gendir + '/sigs'
#     srcdir = './lib/tree_sitter_ffi'
  def self.sigs(vers)
    filer = Filer.new({input: 'lib/tree_sitter_ffi'}, 
      {out: gendir(vers) + 'sigs/'})
    GenSigs.gen_sigs(filer)    
    puts "done."
  end
  
  
# class Root
#     attr_reader :objs
#     def initialize
#         @objs = []
#         Dir.glob('root/*.rb').each do |file|
#             require file
#             @objs << eval(File.basename(file, ".rb").capitalize + ".new")
#         end
#     end
# end

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
