#!/usr/bin/env ruby ### is this actually portable???

require 'fileutils'

require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require './src/filer.rb'
require './src/sigs/gen_sigs_prep.rb'
require './src/rusty/gen_rusty.rb'
require './src/sigs/gen_sigs.rb'

### also script, 'if File.identical?(__FILE__, $0)' at end

require 'awesome_print'

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
  
  def self.diff_rep(vers, vers_prev)
    filer = Filer.new({input: gendir(vers) + 'pull/' + shunt(vers, false),
      input_prev: gendir(vers_prev) + 'pull/' + shunt(vers_prev, false)}, 
      {out: gendir(vers) + 'diff/'})

    subdirs = {'lib/include/tree_sitter/' => ['api.h'], 
      'cli/src/tests/' => ['node_test.rs', 'tree_test.rs', 'query_test.rs']
      }
    files = subdirs.map{|dir, filelist| filelist.map{|e| Pathname.new(dir) + e}}.flatten
    
    results = files.map do |file|
      path = filer.path(:input) + file
      path_prev = filer.path(:input_prev) + file
      # -O to ensure vers_prev file is listed first every time
      `git diff --no-index -O #{path_prev} #{path_prev} #{path}`
#       %x[git diff --no-index -O #{path_prev} #{path_prev} #{path}]
    end
    
    diff_rep_name = "diff-rep-#{vers_prev}-#{vers}"

    # raw txt results (only files with changes)
    guts = results.join
    diff_rep_txt = "#{diff_rep_name}.txt"
    filer.write(:out, diff_rep_txt, guts)


    # md presentation results, plan blank with full notes and reduced
    plan = files.zip(results).map do |file, diff|
      regions = diff.split(/^(@@[^\n@]*@@)/).unshift('').map{|e| 
        e.gsub(/\s*@@\s*/, '')}.each_slice(2).to_a
      [file, regions]
    end
    
    guts = plan.map do |file, regions|
      sections = regions.map do |loc, changes| 
        break nil unless changes
        sec_title = (loc.empty? ? '' : "\n#{loc}\n")
        "#{sec_title}\n```diff\n#{changes}\n```\n"
      end
      "### #{file}\n\n#{sections ? sections.join : 'No changes.'}"
    end 

    diff_rep_md = "#{diff_rep_name}.md"
    filer.write(:out, diff_rep_md, 
      "## Difference report #{vers_prev} to #{vers}\n\n\n" + guts.join("\n\n"))
    
    tbl_head = %w%tr th loc /th th note /th /tr%.map{|e| "<#{e}>"}.join
    tbl_row = %w%tr td loc /td td note /td /tr%.map{|e| "<#{e}>\n"}.join

    changed_files = []
    notes = plan.map do |file, regions|
      regions.shift # first entry is intro legend, not change region
      next "### #{file}\n\nNo changes.\n" if regions.empty?
      changed_files << file
      head = tbl_head.gsub('<loc>', 'Location').gsub('<note>', '[Status] Notes')
      rows = regions.map{|loc, _| tbl_row.gsub('<loc>', "#{loc}").gsub('<note>', '')}              
      ["### #{file}\n", "<table>", head, rows.join("\n"), "</table>\n\n\n"].join("\n")
    end 
    
    head = tbl_head.gsub('<loc>', 'Location(s)').gsub('<note>', '[Status] Notes')
    row = tbl_row.gsub('<loc>', '').gsub('<note>', '')
    reduced = changed_files.map do |file|
      ["### #{file}\n", "<table>", head, row, "</table>\n\n"].join("\n")
    end      
    
    notes_title = "## Upgrade plan #{vers_prev} to #{vers}\n\n\n"
    reduced_title = "## Upgrade plan #{vers_prev} to #{vers} (Reduced)\n\n\n"
    filer.write(:out, "plan-#{vers_prev}-#{vers}_blank.md", 
      reduced_title + reduced.join("\n\n") + 
      notes_title + notes.join("\n\n"))
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
#     puts "done."
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
#     puts "done."
  end
  
  def self.gen_sigs(vers)
    filer = Filer.new({input: 'lib/tree_sitter_ffi'}, 
      {out: gendir(vers) + 'sigs/'})
    GenSigs.gen_sigs(filer)    
#     puts "done."
  end
  
end

# $ ruby src/dev_runner.rb cmd [vers]
def do_the_thing(cmd, vers, more)
  # non-tee, silent option??? colored option???
  logfile = "#{cmd}_#{vers}_log.txt"
  # if we want lib not gem, append '_lib' to the cmd name -- mind random ruby named _lib!!
  cmd, lib = cmd.split(/(_lib)$/)
  incl_path = (lib ? "-I lib/" : '')
  
  prog = case cmd
  when 'diff_rep'
    vers_prev, _ = more
    # list files, one eg...
    logfile = nil # no log, just output to file and "done."
    req = "require './src/dev_runner.rb'"
    call = "DevRunner.#{cmd}('#{vers}', '#{vers_prev}')"
    ruby_prog = "ruby #{incl_path} -e\"#{req}; #{call}\" 2>&1"
  when 'run_rusty_stubs'
    "ruby #{incl_path} gen/dev-tree-sitter-#{vers}/rusty/run_rusty_stubs.rb 2>&1" 
  when 'run_rusty'
    "ruby #{incl_path} gen/dev-tree-sitter-#{vers}/rusty/run_rusty.rb 2>&1" 
  when 'run_sigs'
    "#{lib ? 'local=true' : ''} rspec #{incl_path} gen/dev-tree-sitter-#{vers}/sigs 2>&1" # redirect? 
  when 'run_sigs_blanks'
    # not really useful but this is how we'll do it for patch (in src/ not gen/dev-)
    "#{lib ? 'local=true' : ''} rspec #{incl_path} gen/dev-tree-sitter-#{vers}/sigs gen/dev-tree-sitter-#{vers}/sigs/*_blank.rb 2>&1" # redirect? 
  else
    req = "require './src/dev_runner.rb'"
    call = "DevRunner.#{cmd}('#{vers}')"
    ruby_prog = "ruby #{incl_path} -e\"#{req}; #{call}\" 2>&1"
  end

  tee_log = (logfile ? " | tee log/#{logfile}" : '')
  FileUtils.mkdir_p('log/') if logfile
  puts "DevRunner calling #{prog + tee_log}..."
  system(prog + tee_log)
  puts "done."
end

# run from cmdline, add getopts??? yeah, def getopts for -lib flag, etc!!! FIXME!!!
if File.identical?(__FILE__, $0)
  unless ARGV.length > 0
    puts "Usage: ruby dev_runner.rb cmd [vers]"
    exit 1
  end
  cmd, vers, *more = ARGV
  vers = '0.20.0' unless vers # or whatever is most likely currently
  do_the_thing(cmd, vers, more)
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
