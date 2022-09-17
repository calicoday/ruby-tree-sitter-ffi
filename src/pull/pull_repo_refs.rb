# script, calls at end

# run with `ruby src/pull/pull_repo_refs.rb &> log/pull_repo_refs_log.txt`

require './src/pull/repo_refs.rb'
require './src/pull/show_runner.rb'
require 'fileutils'

repo_refs_rec = {
  "https://github.com/tree-sitter/tree-sitter/" =>
    {dest: "tree-sitter-#{vers}/",
      vers: ['0.20.7', '0.20.6', '0.20.0'],
      subdirs: {'lib/include/tree_sitter/' => {scrap: ['.svn']}, 
        'cli/src/tests/' => {keep: %w%node_test.rs tree_test.rs query_test.rs%}
        },
      }
  }
  
RepoRefs.do_the_thing(ShowRunner.new, './dev-ref/pull', repo_refs_rec)

puts 
puts "done."
  
exit 0

  
# def do_the_thing(rundir, refs_rec, &b=nil)
#   repo_refs_rec.each do |repo_root, refs|
#     dest = refs[:dest]
#     vers = refs[:vers]
#     vers = [vers] unless vers.is_a?(Array)
#     subdirs = refs[:subdirs]
#     vers.each do |e|
#       show.section "Pull repo vers #{vers}..."
#       RepoRefs.pull_vers(repo_root, subdirs, e, dest) do |subdir, dest, tidy|
#         show.call(RepoRefs, :tidy, subdir, dest, tidy)
#       end
#     end
#   end
# end
# RepoRefs.do_the_thing(rundir, repo_refs_rec)

class PullRepoRefs

  def do_the_thing(show, rundir, rec)
    show.call_sys("date")
    ensure_outpath(rundir)
    show.call(FileUtils, :cd, rundir)
    
    rec.each do |repo_root, refs|
      dest = refs[:dest]
      vers = refs[:vers]
      vers = [vers] unless vers.is_a?(Array)
      subdirs = refs[:subdirs]
      vers.each do |e|
        show.section "Pull repo vers #{vers}..."
        RepoRefs.pull_vers(repo_root, subdirs, e, dest) do |subdir, dest, tidy|
          show.call(RepoRefs, :tidy, subdir, dest, tidy)
        end
      end
    end    
  end

  def was_do_the_thing
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

    pull_vers(repo_root, vers
    vers_list = ['0.20.7', '0.20.6', '0.20.0']
    vers_list.each do |vers|
      show.section "Pull repo vers #{vers}..."
      subdirs.each do |subdir, tidy|
        dest = "tree-sitter-#{vers}/"
        show.call(RepoRefs, :pull, repo_root, vers, subdir, dest)
        next unless tidy
        if tidy[:keep] 
          show.call(RepoRefs, :keep, dest + subdir, tidy[:keep])
        elsif tidy[:scrap]
          show.call(RepoRefs, :scrap, dest + subdir, tidy[:scrap])
#         if tidy[:keep] 
#           show.call(self, :keep, dest + subdir, tidy[:keep])
#         elsif tidy[:scrap]
#           show.call(self, :scrap, dest + subdir, tidy[:scrap])
        end
      end
    end
    
    puts 
    puts "done."
  end
  
  
  ### add these back upstream!!!
#     vers_list = ['0.20.7', '0.20.6', '0.20.0']
#   def pull_vers_list(repo_root, vers_list)
#     # :nightly!!!
#     vers_list = [vers_list] unless vers_list.is_a?(Array)
#     vers_list.each do |vers|
#       pull_vers(vers)
#     end
#   end
  

end

PullRepoRefs.new.do_the_thing