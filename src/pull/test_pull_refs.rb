# test script, calls at end.


# copy useful tree-sitter repo files for a given version.

# run from proj dir:
# $ ruby dev_pull_repo_refs.rb tag

# require 'fileutils'
# require 'pathname'
require './src/pull/repo_refs.rb'

outdir = './dev-ref/test/pull/'

class TestRepoRefs
  def self.test_sample(k)
    egs = {
      ls: {
        org: "https://github.com/tree-sitter/",
        name: "tree-sitter/",
        subdir: 'lib/include/tree_sitter/',
        vers: '0.18.3'},
      pull: {
        org: "https://github.com/tree-sitter/",
        name: "tree-sitter/",
        subdir: 'lib/include/tree_sitter/',
        vers: '0.18.3'},
      skim: {
        org: "https://github.com/tree-sitter/",
        name: "tree-sitter/",
        # lib/include/tree-sitter files, no dirs. Try cli/ so we can see the diff
        subdir: 'cli/',
        vers: '0.18.3'},
    }
    [egs[k][:org], egs[k][:name], egs[k][:vers], egs[k][:subdir]]
  end


  def self.show_call_variants(rundir, testdir, log=nil)
#     RepoRefs.ensure_outpath(rundir)
    RepoRefs.ensure_outpath(testdir)

    # exact copy of show_svn_variants, replacing system svn calls with RepoRefs
    # expect: same dirs, files and results lines correspond.
    
    log = :stdout unless log
    show = ShowRunner.new(log)
    show.call_sys("date")

    show.call(FileUtils, :cd, testdir)
#     show.call(FileUtils, :cd, rundir)
    
#     vers = '0.18.3' # testvers
    # vers = nil # nightly

    org, name, vers, subdir = test_sample(:ls)
    repo_root = RepoRefs.repo_root(org, name)
    
    show.section "list repo subdir lib/include/tree_sitter/ ..."
#     show.call_sys("svn ls #{from}")
    show.call(RepoRefs, :ls, repo_root, vers, subdir)


    org, name, vers, subdir = test_sample(:pull)
    repo_root = RepoRefs.repo_root(org, name)

    show.section "checkout with no dest arg..."
    show.call(FileUtils, :mkdir, 'svn_co_default')
    show.call(FileUtils, :cd, 'svn_co_default')

    # to compare with svn, we need to pull_as !keep_tree (so the subdir doesn't get
    # added to the dest). pull_as req dest, can be nil
    show.call(RepoRefs, :pull_as, repo_root, vers, subdir, nil, false)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=. ...")
    show.call(FileUtils, :mkdir, 'svn_co_dot')
    show.call(FileUtils, :cd, 'svn_co_dot')

    show.call(RepoRefs, :pull_as, repo_root, vers, subdir, '.', false)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_oth_sub')

    show.call(RepoRefs, :pull_as, repo_root, vers, subdir, 'oth/sub/', false)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')


    org, name, vers, subdir = test_sample(:skim)
    repo_root = RepoRefs.repo_root(org, name)

    show.section "list repo subdir cli/ ..."
    show.call(RepoRefs, :ls, repo_root, vers, subdir)
  
  
    show.section("skim repo subdir top level files only with no dest arg ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_default')
    show.call(FileUtils, :cd, 'svn_co_skim_default')

    show.call(RepoRefs, :skim, repo_root, vers, subdir)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

  
    show.section("skim repo subdir top level files only with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_skim_oth_sub')

    show.call(RepoRefs, :skim, repo_root, vers, subdir, 'oth/sub/')
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

    # cd back to the original rundir in case we run other tests
#     show.call(FileUtils, :cd, '..')
    show.call(FileUtils, :cd, rundir)

#     show.write # not impl
  end

  def self.show_svn_variants(rundir, testdir, log=nil)
#     RepoRefs.ensure_outpath(rundir)
    RepoRefs.ensure_outpath(testdir)

    # switch to FileUtils now to get verbose
    # verbose write to stderr so full redirect for capture, 
    # $ ruby pull_repo_refs.rb > show_svn_results.txt 2>&1
    # $ ruby pull_repo_refs.rb &> show_svn_results.txt ### bash, chk zsh!!! yup!!!
    # (can't put it directly into rundir bc classes with empty? check)
    ### can we capture to file from within???!!! Or wrap??? FIXME!!!
    # fix put_and_call so we send everything to file + stdout???!!!
    
    log = :stdout unless log
    show = ShowRunner.new(log)
    show.call_sys("date")

#     show.call(FileUtils, :cd, rundir)    
    show.call(FileUtils, :cd, testdir)    

#     vers = '0.18.3' # testvers
    # vers = nil # nightly

    org, name, vers, subdir = test_sample(:ls)
    repo_root = RepoRefs.repo_root(org, name)
    from = RepoRefs.url(repo_root, subdir, RepoRefs.tag(vers)) 
    
    show.section "list repo subdir lib/include/tree_sitter/ ..."
    show.call_sys("svn ls #{from}")


    org, name, vers, subdir = test_sample(:pull)
    repo_root = RepoRefs.repo_root(org, name)
    from = RepoRefs.url(repo_root, subdir, RepoRefs.tag(vers)) 

    show.section "checkout with no dest arg..."
    show.call(FileUtils, :mkdir, 'svn_co_default')
    show.call(FileUtils, :cd, 'svn_co_default')

    ###show_and_cmd("svn checkout #{from}")
    show.call_sys("svn checkout #{from}")
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=. ...")
    show.call(FileUtils, :mkdir, 'svn_co_dot')
    show.call(FileUtils, :cd, 'svn_co_dot')

    show.call_sys("svn checkout #{from} .")
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_oth_sub')

    show.call_sys("svn checkout #{from} oth/sub/")
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')


    org, name, vers, subdir = test_sample(:skim)
    repo_root = RepoRefs.repo_root(org, name)
    from = RepoRefs.url(repo_root, subdir, RepoRefs.tag(vers)) 

    show.section "list repo subdir cli/ ..."
    show.call_sys("svn ls #{from}")
  
  
    show.section("skim repo subdir top level files only with no dest arg ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_default')
    show.call(FileUtils, :cd, 'svn_co_skim_default')

    show.call_sys("svn checkout #{from} --depth files")
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

  
    show.section("skim repo subdir top level files only with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_skim_oth_sub')

    show.call_sys("svn checkout #{from} oth/sub/ --depth files")
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

    # cd back to the original rundir in case we run other tests
#     show.call(FileUtils, :cd, '..')
    show.call(FileUtils, :cd, rundir)

#     show.write # not impl
  end
  
end

# raise "remove night guard!!!"

rundir = `pwd`.strip # cd doesn't like trailing \n

puts "TestRepoRefs.show_svn_variants('show_svn')..."
TestRepoRefs.show_svn_variants(rundir, outdir + 'show_svn')

puts
puts

puts "TestRepoRefs.show_call_variants('show_call')..."
TestRepoRefs.show_call_variants(rundir, outdir + 'show_call')

puts
puts "done."
exit 0

# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end


