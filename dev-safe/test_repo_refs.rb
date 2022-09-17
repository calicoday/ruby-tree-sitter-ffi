# copy useful tree-sitter repo files for a given version.

# run from proj dir:
# $ ruby dev_pull_repo_refs.rb tag

# require 'fileutils'
# require 'pathname'
require './repo_refs.rb'

vers = ARGV[1] || '' # no arg gets nightly???

tags_list_ref = ['0.20.7', '0.20.6', '0.20.0'] 
tag = '0.20.6' # get from ARGV



outdir = './dev-ref-pull/'
# if Dir.exists?(outdir)
# 	unless Dir.empty?(outdir)
# 		puts "#{outdir} dir has stuff in it. exitting."
# 		exit 1
# 	end
# else
# 	Dir.mkdir(outdir)
# end

class TestRepoRefs
  def self.ensure_outdir(outdir)
    if Dir.exist?(outdir)
      unless Dir.empty?(outdir)
        puts "#{outdir} dir has stuff in it. exitting."
        exit 1
      end
    else
      Dir.mkdir(outdir)
    end
  end
  
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


  def self.show_call_variants(rundir, log=nil)
    ensure_outdir(rundir)

    # exact copy of show_svn_variants, replacing system svn calls with RepoRefs
    # expect: same dirs, files and results lines correspond.
    
    log = :stdout unless log
    show = ShowRunner.new(log)

    show.call(FileUtils, :cd, rundir)
    
#     vers = '0.18.3' # testvers
    # vers = nil # nightly

    org, name, vers, subdir = test_sample(:ls)
#     from = url(org, name, subdir, tag(vers)) 
    
    show.section "list repo subdir lib/include/tree_sitter/ ..."
#     show.call_sys("svn ls #{from}")
    show.call(RepoRefs, :ls, org, name, vers, subdir)


    org, name, vers, subdir = test_sample(:pull)
#     from = url(org, name, subdir, tag(vers)) 

    show.section "checkout with no dest arg..."
    show.call(FileUtils, :mkdir, 'svn_co_default')
    show.call(FileUtils, :cd, 'svn_co_default')

    ###show_and_cmd("svn checkout #{from}")
#     show.call_sys("svn checkout #{from}")
    # to compare with svn, we need to pull_as !keep_tree (so the subdir doesn't get
    # added to the dest). pull_as req dest, can be nil
    show.call(RepoRefs, :pull_as, org, name, vers, subdir, nil, false)
#     show.call(RepoRefs, :pull, org, name, vers, subdir)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=. ...")
    show.call(FileUtils, :mkdir, 'svn_co_dot')
    show.call(FileUtils, :cd, 'svn_co_dot')

#     show.call_sys("svn checkout #{from} .")
    show.call(RepoRefs, :pull_as, org, name, vers, subdir, '.', false)
#     show.call(RepoRefs, :pull, org, name, vers, subdir, '.')
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')
  
    show.section("checkout with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_oth_sub')

#     show.call_sys("svn checkout #{from} oth/sub/")
    show.call(RepoRefs, :pull_as, org, name, vers, subdir, 'oth/sub/', false)
#     show.call(RepoRefs, :pull, org, name, vers, subdir, 'oth/sub/')
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')


    org, name, vers, subdir = test_sample(:skim)
#     from = url(org, name, subdir, tag(vers)) 

    show.section "list repo subdir cli/ ..."
#     show.call_sys("svn ls #{from}")
    show.call(RepoRefs, :ls, org, name, vers, subdir)
  
  
    show.section("skim repo subdir top level files only with no dest arg ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_default')
    show.call(FileUtils, :cd, 'svn_co_skim_default')

#     show.call_sys("svn checkout #{from} --depth files")
    show.call(RepoRefs, :skim, org, name, vers, subdir)
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

  
    show.section("skim repo subdir top level files only with dest=oth/sub/ ...")
    show.call(FileUtils, :mkdir, 'svn_co_skim_oth_sub')
    show.call(FileUtils, :cd, 'svn_co_skim_oth_sub')

#     show.call_sys("svn checkout #{from} oth/sub/ --depth files")
    show.call(RepoRefs, :skim, org, name, vers, subdir, 'oth/sub/')
    show.call_sys("tree")
    show.call(FileUtils, :cd, '..')

#     show.write # not impl
  end

  def self.show_svn_variants(rundir, log=nil)
    ensure_outdir(rundir)

    # switch to FileUtils now to get verbose
    # verbose write to stderr so full redirect for capture, 
    # $ ruby pull_repo_refs.rb > show_svn_results.txt 2>&1
    # $ ruby pull_repo_refs.rb &> show_svn_results.txt ### bash, chk zsh!!! prob
    # (can't put it directly into rundir bc classes with empty? check)
    ### can we capture to file from within???!!! Or wrap??? FIXME!!!
    # fix put_and_call so we send everything to file + stdout???!!!
    
    log = :stdout unless log
    show = ShowRunner.new(log)

    show.call(FileUtils, :cd, rundir)
#     FileUtils.cd(rundir)
    

#     vers = '0.18.3' # testvers
    # vers = nil # nightly

    org, name, vers, subdir = test_sample(:ls)
    from = RepoRefs.url(org, name, subdir, RepoRefs.tag(vers)) 
#     from = url(org, name, subdir, tag(vers)) 
    
    show.section "list repo subdir lib/include/tree_sitter/ ..."
    show.call_sys("svn ls #{from}")


    org, name, vers, subdir = test_sample(:pull)
    from = RepoRefs.url(org, name, subdir, RepoRefs.tag(vers)) 

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
    from = RepoRefs.url(org, name, subdir, RepoRefs.tag(vers)) 

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

#     show.write # not impl
  end
  
end

# 
# 
# vers = '0.18.3' # testvers
# # vers = '0.20.0'
# # vers = '0.20.6'
# # vers = '0.20.7'
# # vers = nil # nightly
# 
# org = "https://github.com/tree-sitter/" 
# name = "tree-sitter/"
# subdir = 'lib/include/tree_sitter/'
# 
# call = "svn checkout #{onedir} --depth files #{target}" # top level files only
# call = "RepoRefs.ls('#{org}', '#{name}', '#{vers}', '#{subdir}')"
# call = RepoRefs.pull()

### outer functions ONLY for testing here!!!

# def ls(org, name, vers, subdir)
#   call = "RepoRefs.ls(#{[org, name, vers, subdir].join(', ')})"
#   puts "ls vers #{vers} with `#{call}`..."
#   RepoRefs.ls(org, name, vers, subdir)
# end
# 
# # doesn't keep subdir hierarchy, just names the containing dir dest
# # nil or '' dest will create no container, just add files to cwd
# def pull_as(org, name, vers, subdir, dest, keep_tree=false)
#   call = "RepoRefs.pull_as(#{[org, name, vers, subdir, keep_tree].join(', ')})"
#   puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
#   RepoRefs.pull_as(org, name, vers, subdir, dest, keep_tree)
# end
# def pull(org, name, vers, subdir, dest='')
#   call = "RepoRefs.pull(#{[org, name, vers, subdir].join(', ')})"
#   puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
#   RepoRefs.pull(org, name, vers, subdir, dest)
# end



# raise "remove overnight guard!!!"

# TestRepoRefs.show_svn_variants('show_svn2')
TestRepoRefs.show_call_variants('show_call2')

puts
puts "done."
exit 0

# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end


