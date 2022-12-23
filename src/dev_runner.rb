# run from proj: ruby -I lib/ src/dev_runner.rb

require 'json'
require 'fileutils'

require './src/util/optimist.rb'
require './src/util/sunny.rb'
require './src/util/filer.rb'
require './src/rusty/gen_rusty.rb'



class DevRunner < Sunny

  def initialize
    cmd_list = {
      "demo" => "run demo/example.rb",

      "gen_rusty" => "generate gen/ rusty tests",
      "cp_rusty" => "copy rusty_*_test.rb and *_patch_blank.rb to spec/rusty",

      "rspec_raw" => "run rspec on gen/raw-spec.vers/ *_raw_spec.rb",
      "rspec_raw_patch" => "run rspec on spec/raw-patch.vers/ *_raw_patch_spec.rb",
      "test_rusty" => "run spec/rusty tests",
      "test_rusty_patch" => "run spec/rusty patch tests",
      "run_rusty_stubs" => "run gen/rusty test stubs",
      "run_rusty_tiny" => "run gen/rusty tiny test",
      }
    # vet cmd_list for matching method, if we're going to blindly redirect!!!
    cmd_opts = Proc.new {|cmd|
      }
    g_opts, cmd, c_opts = ready(cmd_list.keys, cmd_opts) do 
      version 'dev_runner.rb v0.1.0'
      banner('Runner of tree-sitter-ffi scripts')
      banner 'Usage:'
      banner "  dev_runner.rb [options] [<command> [suboptions]]\n \n"
      banner 'Options:'
      # -v, -h get added auto but they land after the subcommands, so put them here
      opt(:version)
      opt(:help)

      # tag is req, repo is req for only gen_rusty
      opt(:tag, 'Tree-sitter version tag (/\d+\.\d+\.\d+/ no \'v\' or other)',
        :type => String, :required => true)
      opt(:repo, 'Tree-sitter repo (for rust tests source)', :type => String)

      opt(:gem, 'Use source from gems')
      opt(:lib, 'Use source from local lib/ not gems', :default => true)

      banner "\nCommands:"
#       cmd_list.each { |cmd, desc| banner format("  %-20s %s", cmd, desc) }
      # Optimist doesn't wrap desc, use max 80
      offset = 2 + 20 + 1
      col2_w = 80 - (offset)
      cmd_list.each do |cmd, desc| 
        # strip frags so \n takes the place of any trailing \w
        frags = desc.scan(/.{1,#{col2_w}}\W/).map(&:strip)
        banner format("  %-20s %s", cmd, frags.join("\n#{' '*offset}"))        
      end
    end
    
    do_the_thing(g_opts, cmd, c_opts)
  end
    
  def do_the_thing(g_opts, cmd, c_opts)
    # add the --gem flag for gem testing, else always lib/
    g_opts.lib = false if g_opts.gem
    add_to_loadpath('lib/') if g_opts.lib

    incl_path = (g_opts.lib ? "-I lib/" : '')
    local = (g_opts.lib ? 'local=true' : '') # for rspec
    
    vers = g_opts.tag
    logfile = "#{cmd}.#{vers}_log.txt"
    tee_log = " | tee log/#{logfile}" ### log_dir option???
#     logfile = "run_#{cmd}_log-#{vers}.txt"
#     tee_log = (logfile ? " | tee log/#{logfile}" : '')
    
    # compose a cmdline and call do_the_thing
    cmdline = case cmd
    when 'demo' then demo(g_opts)
    when 'gen_rusty' then gen_rusty(g_opts, logfile)
    when 'cp_rusty' then cp_rusty(g_opts)
    when 'rspec_raw' then rspec_raw(g_opts)
    when 'rspec_raw_patch' then rspec_raw_patch(g_opts)
    when 'test_rusty' then test_rusty(g_opts)
    when 'test_rusty_patch' then test_rusty_patch(g_opts)
    # these will have dbl 'done.':
    when 'run_rusty_stubs' then run_rusty_stubs(g_opts)
    when 'run_rusty_tiny' then run_rusty_tiny(g_opts)
    end
    
    # if cmdline.nil?, command has been run directly, no log
    puts `#{cmdline}#{tee_log}` if cmdline
    
    # run_rusty scripts already have 'done.' in them
    puts "done." unless ['run_rusty_stubs', 'run_rusty_tiny'].include?(cmd)
  end

# ruby src/dev_runner.rb -t '0.20.7' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' gen_rusty
# ruby src/dev_runner.rb -t '0.20.0' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.0/tree-sitter' gen_rusty
  def gen_rusty(g_opts, logfile)
    vers = g_opts.tag
  
    logdir = Pathname('log/')
    $log = File.open(logdir + logfile, 'w')
#     $log = File.open('log/' + 'gen_rusty_log.txt', 'w') ###TMP!!! use filer!!! FIXME!!!
    
    unless g_opts.repo
      puts "Error: option --repo must be specified.\nTry --help for help."
      exit 1
    end
    repo_dir = Pathname.new(g_opts.repo)

    filer = Filer.new(
      {input: repo_dir + 'cli/src/tests/',
        tmplt: Pathname.new('src/') + 'rusty/',
        reqs: Pathname.new('src/') + "rusty-prep.#{vers}/", # for composing requires
        },
      {out: Pathname.new('gen/') + "rusty.#{vers}/"})      
    
    RustyGen.gen_rusty(filer, ["node", "tree", "query"])
    $log.close
    nil # completed command, no further call nec
  end
  
  ### curr req --repo opt!!! ### FIXME!!!
  # or Error: option --repo must be specified.
  # ruby src/dev_runner.rb -t '0.20.7' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' cp_rusty
  def cp_rusty(g_opts)
    # cp gen/rusty.0.1.2/rusty_*_test.rb to spec/rusty.0.1.2/ 
    # and gen/rusty.0.1.2/rusty_*_patch_blank.rb to (shd be _stub not _blank!!!)
    # spec/rusty-patch-fresh.0.1.2/#{was.gsub(/_blank/, '')}
    # hand cp -patch-fresh to -patch and edit.
    vers = g_opts.tag
  
    gendir = Pathname.new('gen/') + "rusty.#{vers}/"
    specdir = Pathname.new('spec/') + "rusty.#{vers}/"
    patchdir = Pathname.new('spec/') + "rusty-patch-fresh.#{vers}/"


    if Dir.exist?(specdir) && !Dir.children(specdir).empty?
      "#{specdir} has stuff in it. Exiting."
      exit 1
    end
    FileUtils.mkdir_p(specdir)
    if Dir.exist?(patchdir) && !Dir.children(patchdir).empty?
      "#{patchdir} has stuff in it. Exiting."
      exit 1
    end
    FileUtils.mkdir_p(patchdir)
    
    # run_rusty.rb first, rewrite gen/ paths as spec/
    run_rusty = File.read(gendir + "run_rusty.rb").split("\n").map do |line|
      line.gsub(/#{gendir}(.*)_patch\.rb/, "spec/rusty-patch.#{vers}/\\1_patch.rb").
        gsub(/#{gendir}(.*)\.rb/, "#{specdir}\\1.rb")
    end.join("\n")
    File.write(specdir + "run_rusty.rb", run_rusty)
    
    tests = Dir.glob("*_test.rb", base: gendir)
    puts "tests: #{tests.inspect}"
    tests.each do |test|
      File.write(specdir + test, File.read(gendir + test))
    end
    
#     patches = Dir.glob("*_prep_stub.rb", base: gendir)
    patches = Dir.glob("*_patch_blank.rb", base: gendir)
    puts "patches: #{patches.inspect}"
    patches.each do |patch_stub|
#       patch = patch_stub.gsub(/_stub/, '')
      patch = patch_stub.gsub(/_blank/, '')
      File.write(patchdir + patch, File.read(gendir + patch_stub))
    end
    
    nil # completed command, no further call nec
  end

# ruby src/dev_runner.rb -t '0.20.7' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' demo
# ruby src/dev_runner.rb -t '0.20.0' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.0/tree-sitter' demo

  def demo(g_opts)
    vers = g_opts.tag
    ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
    prog = "demo/example.rb"
    incl_path = "-I lib/ -I #{File.expand_path('./gen')}"
    "ruby #{incl_path} #{prog}"
  end

#   def test_all(g_opts)
#     rspec_raw(g_opts)
#     rspec_raw_patch(g_opts)
#     test_rusty(g_opts)
#     test_rusty_patch(g_opts)
#   end
  
  def rspec_raw(g_opts)
    vers = g_opts.tag
    ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
    specs = Pathname.new('spec/') + "raw-spec.#{vers}/*_spec.rb"
    puts "specs: #{specs}+++"
    incl_path = "-I lib/ -I #{File.expand_path('./gen')}"
    "local=true rspec #{incl_path} #{specs}"
  end
  
  def rspec_raw_patch(g_opts)
    vers = g_opts.tag
    ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
    specs = Pathname.new('spec/') + "raw-patch.#{vers}/*_spec.rb"
    puts "specs: #{specs}+++"
    incl_path = "-I lib/ -I #{File.expand_path('./gen')}"
    "local=true rspec #{incl_path} #{specs}"
  end
  
  def test_rusty(g_opts)
    vers = g_opts.tag
    ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
#     tests = Pathname.new('spec/') + "rusty.#{vers}/*_test.rb"
    prog = "spec/rusty.#{vers}/run_rusty.rb"
    incl_path = "-I lib/ -I #{File.expand_path('./gen')}"
    "ruby #{incl_path} #{prog}"
  end
  
  # if we ever get far enough to HAVE patch code to test repeatedly... Sigh.
  def test_rusty_patch(g_opts)
    vers = g_opts.tag
    ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
#     tests = Pathname.new('spec/') + "rusty-patch.#{vers}/*_test.rb"
    prog = "spec/rusty-patch.#{vers}/run_rusty.rb" ###??? don't have this yet!!!
    incl_path = "-I lib/ -I #{File.expand_path('./gen')}"
    "ruby #{incl_path} #{prog}"
  end

# TREE_SITTER_RUNTIME_VERSION='0.20.7' ruby -I lib/ gen/rusty.0.20.7/run_rusty_stubs.rb
# TREE_SITTER_RUNTIME_VERSION='0.20.0' ruby -I lib/ gen/rusty.0.20.0/run_rusty_stubs.rb
  
# ruby src/dev_runner.rb -t '0.20.7' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' run_rusty_stubs
# ruby src/dev_runner.rb -t '0.20.0' run_rusty_stubs
# ruby src/dev_runner.rb -t '0.20.0' -r '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.0/tree-sitter' run_rusty_stubs
  def run_rusty_stubs(g_opts)
    vers = g_opts.tag
#     ENV['TREE_SITTER_RUNTIME_VERSION'] = vers
#     tests = Pathname.new('spec/') + "rusty-patch.#{vers}/*_test.rb"
    prog = "gen/rusty.#{vers}/run_rusty_stubs.rb"
    incl_path = "-I lib/"
    "ruby #{incl_path} #{prog}"
  end
  
  def run_rusty_tiny(g_opts)
    vers = g_opts.tag
    prog = "gen/rusty.#{vers}/run_rusty_tiny.rb"
    incl_path = "-I lib/"
    "ruby #{incl_path} #{prog}"
  end
  
  # run all cmd -- mv all outdirs and supply prep and spec/patchs first!!!
  def all_dev_runner(g_opts)
    vers = g_opts.tag
    
  end
  
end

DevRunner.go(__FILE__)

