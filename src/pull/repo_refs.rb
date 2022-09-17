require 'fileutils'
require 'pathname'
require './src/pull/show_runner.rb'

module RepoRefs
  module_function

  def do_the_thing(show, rundir, rec)
    show.call_sys("date")
    ensure_outpath(rundir)
    show.call(FileUtils, :cd, rundir)
    
    rec.each do |repo_root, refs|
      subdirs = refs[:subdirs]
      vers_list = refs[:vers]
      vers_list.each do |vers, dest|
        show.section "Pull repo vers #{vers}..."
        RepoRefs.pull_vers(repo_root, subdirs, vers, dest) do |subdir, dest, tidy|
#         puts "*** call pull_vers #{[repo_root, subdirs, vers, dest].map(&inspect)}"
          show.call(RepoRefs, :tidy, subdir, dest, tidy)
        end
      end
    end    
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

  # will tidy each subdir unless block_given (eg you want to log the tidy call)
  def pull_vers(repo_root, subdirs, vers, dest, &b)
    subdirs.each do |subdir, tidy|
      pull_subdir(repo_root, vers, subdir, dest)
      block_given? ?
        yield(subdir, dest, tidy) :
        tidy(subdir, dest, tidy)
    end
  end
  
  def pull_subdir(repo_root, vers, subdir, dest)
#     puts "*** pull_subdir #{[repo_root, vers, subdir, dest].map(&inspect)}"
    pull(repo_root, vers, subdir, dest)
  end
  
  def tidy(subdir, dest, tidy=nil)
    return unless tidy
    dest = Pathname.new(dest)
    if tidy[:keep] 
      keep(dest + subdir, tidy[:keep])
    elsif tidy[:scrap]
      scrap(dest + subdir, tidy[:scrap])
    end
  end

  def keep(dir, keepers)
    rejects = Dir.children(dir).reject{|e| keepers.include?(e)}
    scrap(dir, rejects)
  end
  def scrap(dir, rejects) 
    dir = Pathname.new(dir)
    rejects.each{|e| FileUtils.rm_rf(dir + e)} ### rm -rf !!!
  end

  def scrap_by_rule(dir, scraprule) # so meta chars
    # not impl
  end
  

  # for tree-sitter, number tags now start with 'v' (other repos may differ)
  # simple pass 'v0.0.0'??? let pull, ls, accept block for other vers/tag patterns???
  def tag(vers) vers && vers != :nightly ? "v#{vers}" : nil end
#   def tag(vers) vers ? "v#{vers}" : vers end
  def shunt(tag) tag ? "tags/#{tag}/" : "trunk/" end
  
  def repo_root(org, name)
    Pathname(org) + name
  end
  
  def url(repo_root, subdir, tag) 
    # use Pathname to handle nec/unnec '/' seps
    Pathname.new(repo_root) + shunt(tag) + subdir 
  end
  
  def pull_as(repo_root, vers, subdir, dest, keep_tree=false)
    subdir = '' unless subdir
    dest = '' unless dest
    dest = Pathname.new(dest)
    dest = dest + subdir if keep_tree
    system("svn checkout #{url(repo_root, subdir, tag(vers))} #{dest}") 
  end

  def pull(repo_root, vers, subdir, dest=nil) # vers!!!
    pull_as(repo_root, vers, subdir, dest, true)
  end
  
  def ls(repo_root, vers, subdir='') 
    system("svn ls #{url(repo_root, subdir, tag(vers))}")
  end

  # svn dest arg works thusly:
  # - no dest => creates subdir_leaf dir in cwd and copies files only
  # - dest=oth/sub/ => creates oth/sub/ dir in cwd (subdir_leaf name is not used)
  # - dest=. => creates no dir but copies files only directly into cwd
  # .: dest arg is exact (no subleaf_dir arithmetic)
  # For RepoRefs purposes, by default we want pull to keep the dir structure relative 
  # to repo root, so append the subdir to the dest arg (we can get the orig svn
  # behaviour by using pull_as !keep_tree, if nec). Skim is mainly for snooping, eg
  # some config file or other, likely into a scratch dir anyway, do keep the orig
  # svn behaviour and emend dest before calling, if nec.
  # mirror pull/pull_as api???

  # checkout top level files only, eg for vers check (can't checkout just single file)
  def skim(repo_root, vers, subdir, dest=nil) 
    dest = '' unless dest
    system("svn checkout #{url(repo_root, subdir, tag(vers))} #{dest} --depth files") 
  end
   

end

