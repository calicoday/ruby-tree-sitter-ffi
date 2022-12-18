# Stunningly blunt test that dev_runner rusty cmds create the right dirs/files
# Add negative tests for dir guards, etc!!!

### TMP!!! also script, call at end

require 'fileutils'
require 'pathname'

def test_dev_runner(vers, repo)
  puts "src/util/test_dev_runner.rb"
  puts "+=+=+ " + `date`
  puts "Here we go..."
  puts

  src_dir = Pathname.new('src/')
  gen_dir = Pathname.new('gen/')
  spec_dir = Pathname.new('spec/')
  
  must_have = [src_dir + "rusty-prep.#{vers}"]
  must_not_have = [gen_dir + "rusty.#{vers}",
    spec_dir + "rusty.#{vers}", 
    spec_dir + "rusty-patch.#{vers}",
    spec_dir + "rusty-patch-fresh.#{vers}"]

  # must NOT have already...
  [gen_dir + "rusty.#{vers}",
    spec_dir + "rusty.#{vers}", 
    spec_dir + "rusty-patch.#{vers}",
    spec_dir + "rusty-patch-fresh.#{vers}"].each do |dir|    
    if Dir.exist?(dir) && !Dir.children(dir).empty?
      puts "#{dir} has stuff in it. Exiting."
      exit 1
    end
  end
  
  # if we run gen_rusty without prep, we won't get any _patch_blanks and
  # can't test the cp_rusty rename to _patch. One for any boss will do.
  dir = src_dir + "rusty-prep.#{vers}"
  have_prep = (Dir.exist?(dir) &&
    Dir.children(dir).find{|e| e =~ /(node|tree|query)_rusty_prep.rb/})
  unless have_prep 
    puts "Missing #{dir} or prep files. Exiting."
    exit 1
  end
  
  # for clarity, confirm here repo with rusty src for gen_rusty
  unless Dir.exist?(repo)
    puts "Bad repo path '#{repo}'. Exiting."
    exit 1
  end
  
  # and don't let's womp any logs
  ["log/test_rusty.#{vers}_log.txt"].each do |log|
    if File.exist?(log)
      puts "#{log} exists. Exiting."
      exit 1
    end
  end
  
#   puts "stop here."
#   exit 0
  
  runner = "ruby src/dev_runner.rb -t #{vers} "
  
  puts "src/util/test_dev_runner.rb"
  puts "+=+=+ " + `date`
  puts "Here we go..."
  puts

  cmd = runner + "-r #{repo} gen_rusty"
  puts cmd
  puts `#{cmd}`
  puts
  
  cmd = runner + "cp_rusty"
  puts cmd
  puts `#{cmd}`
  puts
  
  # special rename
  puts "mv #{spec_dir}/rusty-patch.#{vers} to #{spec_dir}/rusty-patch.#{vers}"
  FileUtils.mv(spec_dir + "rusty-patch-fresh.#{vers}", spec_dir + "rusty-patch.#{vers}")
  puts
  
  cmd = runner + "test_rusty"
  puts cmd
  puts `#{cmd}`
  puts
  
  # now check we got the correct dirs/files (assumes vers all have the same boss list)
  expected = "gen/rusty.#{vers}
    ├── agen_search_anchor.txt
    ├── run_rusty.rb
    ├── run_rusty_stubs.rb
    ├── rusty_node_patch_blank.rb
    ├── rusty_node_test.rb
    ├── rusty_query_patch_blank.rb
    ├── rusty_query_test.rb
    └── rusty_tree_test.rb
    spec/rusty.#{vers}
    ├── run_rusty.rb
    ├── rusty_node_test.rb
    ├── rusty_query_test.rb
    └── rusty_tree_test.rb
    spec/rusty-patch.#{vers}
    ├── rusty_node_patch.rb
    └── rusty_query_patch.rb

    0 directories, 14 files".split("\n").map(&:strip).join("\n") + "\n"
    
  result = `tree gen/rusty.0.20.7 spec/rusty.0.20.7 spec/rusty-patch.0.20.7`
  puts "Expected result:"
  puts expected
  puts
  
  puts "result == expected: #{result == expected}"
  puts "done."
  

end


test_dev_runner('0.20.7', '/Users/cal/dev/tang22/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter')