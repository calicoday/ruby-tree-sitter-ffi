# script, calls at end

# run with `ruby src/pull/pull_repo_refs.rb &> log/pull_repo_refs_log.txt`

require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require 'fileutils'

class PullRepoRefs

  def do_the_thing
    show = ShowRunner.new
    
    show.call_sys("date")
    
    rundir = './dev-ref/pull'

    ensure_outpath(rundir)
    show.call(FileUtils, :cd, rundir)

    subdirs = {
      'lib/include/tree_sitter/' => 
        {scrap: ['.svn']},
      'cli/src/tests/' => 
        {keep: %w%node_test.rs tree_test.rs query_test.rs%}, 
      }

    org = "https://github.com/tree-sitter/" 
    name = "tree-sitter/"

    vers_list = ['0.20.7', '0.20.6', '0.20.0']
    vers_list.each do |vers|
      show.section "Pull repo vers #{vers}..."
      subdirs.each do |subdir, tidy|
        dest = "tree-sitter-#{vers}/"
        show.call(RepoRefs, :pull, org, name, vers, subdir, dest)
        next unless tidy
        if tidy[:keep] 
          show.call(self, :keep, dest + subdir, tidy[:keep])
        elsif tidy[:scrap]
          show.call(self, :scrap, dest + subdir, tidy[:scrap])
        end
      end
    end
    
    puts 
    puts "done."
  end
  
  def keep(dir, keepers)
    rejects = Dir.children(dir).reject{|e| keepers.include?(e)}
    scrap(dir, rejects)
  end
  def scrap(dir, rejects) 
    rejects.each{|e| FileUtils.rm_rf(dir + e)} ### rm -rf !!!
  end

  def scrap_by_rule(dir, scraprule) # so meta chars
    # not impl
  end
  
  def ensure_outpath(outpath)
    if Dir.exist?(outpath)
      unless Dir.empty?(outpath)
        puts "#{outpath} dir has stuff in it. exitting."
        exit 1
      end
    else
      FileUtils.mkdir_p(outpath)
    end
  end
    
end

PullRepoRefs.new.do_the_thing