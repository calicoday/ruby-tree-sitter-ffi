# script, calls at end

# run with `ruby src/pull/pull_repo_refs.rb &> log/pull_repo_refs_log.txt`

require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require 'fileutils'

vers_list = ['0.20.7', '0.20.6', '0.20.0'].map{|e| [e, "tree-sitter-#{e}"]}.to_h # <- to_h

repo_refs_rec = {
  "https://github.com/tree-sitter/tree-sitter/" =>
    {vers: vers_list,
      subdirs: {'lib/include/tree_sitter/' => {scrap: ['.svn']}, 
        'cli/src/tests/' => {keep: %w%node_test.rs tree_test.rs query_test.rs%}
        },
      }
  }

outdir = './dev-ref/pull/'

RepoRefs.do_the_thing(ShowRunner.new, outdir, repo_refs_rec)

puts 
puts "done."
  
exit 0
