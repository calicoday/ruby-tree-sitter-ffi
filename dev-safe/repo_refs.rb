require 'fileutils'
require 'pathname'

module RepoRefs
  module_function
  
#   def prep_outdir(outdir)
#     if Dir.exist?(outdir)
#       unless Dir.empty?(outdir)
#         puts "#{outdir} dir has stuff in it. exitting."
#         exit 1
#       end
#     else
#       Dir.mkdir(outdir)
#     end
#     FileUtils.cd(rundir) ### do this auto???!!!
#   end

  # for tree-sitter, number tags now start with 'v' (other repos may differ)
  # let pull, ls, accept block for other vers/tag patterns???
  def tag(vers) vers ? "v#{vers}" : vers end
  def shunt(tag) tag ? "tags/#{tag}/" : "trunk/" end
  
  def url(org, name, subdir, tag) 
#     shunt = tag ? "tags/#{tag}/" : "trunk/"
    # use Pathname to handle nec/unnec '/' seps
    Pathname.new(org) + name + shunt(tag) + subdir 
  end
  
  def pull_as(org, name, vers, subdir, dest, keep_tree=false)
    subdir = '' unless subdir
    dest = '' unless dest
    dest = dest + subdir if keep_tree
    system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest}") 
  end

  # pull_into
  def pull(org, name, vers, subdir, dest=nil) # vers!!!
#     pull_as(org, name, vers, subdir, dest, true)
    pull_as(org, name, vers, subdir, dest, true)
#     subdir = '' unless subdir
#     dest = '' unless dest
#     dest = dest + subdir
# #     pull_as(org, name, vers, subdir, dest)
#     system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest}") 
  end
  
  def ls(org, name, vers, subdir='') 
    system("svn ls #{url(org, name, subdir, tag(vers))}")
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
  def skim(org, name, vers, subdir, dest=nil) 
    dest = '' unless dest
    system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest} --depth files") 
  end
#   def skim(org, name, vers, subdir, dest=nil) 
#     skim_as(org, name, vers, subdir, dest, true) # do we want the same as pull???
#   end
#   def skim_as(org, name, vers, subdir, dest, keep_tree=false) 
#     subdir = '' unless subdir
#     dest = '' unless dest
#     dest = dest + subdir if keep_tree
#     system("svn checkout #{url(org, name, subdir, tag(vers))} '' --depth files") 
# #     system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest} --depth files") 
#   end
   
end

