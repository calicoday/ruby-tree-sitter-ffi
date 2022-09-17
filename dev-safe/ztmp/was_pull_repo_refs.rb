# copy useful tree-sitter repo files for a given version.

# run from proj dir:
# $ ruby dev_pull_repo_refs.rb tag

require 'fileutils'
require 'pathname'

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

module RepoRefs
  module_function

  # for tree-sitter, number tags now start with 'v' (other repos may differ)
  # let pull, ls, accept block for other vers/tag patterns???
  def tag(vers) vers ? "v#{vers}" : vers end
  
  def url(org, name, subdir, tag) 
    shunt = tag ? "tags/#{tag}/" : "trunk/"
    # use Pathname to handle nec/unnec '/' seps
    Pathname.new(org) + name + shunt + subdir 
  end
  
  def pull_as(org, name, vers, subdir, dest, keep_tree=false)
    subdir = '' unless subdir
    dest = '' unless dest
    dest = dest + subdir if keep_tree
    system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest}") 
  end

  # pull_into
  def pull(org, name, vers, subdir, dest=nil) # vers!!!
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

  # checkout top level files only, eg for vers check (can't checkout just single file)
  def skim(org, name, vers, subdir, dest) 
    dest = '' unless dest
    system("svn checkout #{url(org, name, subdir, tag(vers))} '' --depth files") 
#     system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest} --depth files") 
  end
  
  # svn dest default is cwd+subdir_leaf. If passed dest arg, it will replace subdir_leaf.
  # if dest arg is empty string or '.', files/dirs will be put in the cwd.
  # eg, given repo with 
  #   - oth/
  #     - file_a
  #     - sub/
  #       - file_b
  # $ svn checkout https://github.com/org/repo_name/oth/sub 
  # =>  cwd/
  #     - .svn
  #     - sub
  #       - file_b
  # svn checkout uri+subdir  # <= no dest, will use filename of subdir
  # svn checkout uri+subdir dest # <= will put files/dirs in dir called dest (poss nested)
  # svn checkout uri+subdir '.' # <= will 
end

def show_and_cmd(cmdstr)
  puts "#{cmdstr}"
  system(cmdstr)
  # notes to screen
end
def show_svn_variants(rundir)
  opts = {verbose: true}

  if Dir.exist?(rundir)
  	unless Dir.empty?(rundir)
  		puts "#{rundir} dir has stuff in it. exitting."
  		exit 1
  	end
  else
  	Dir.mkdir(rundir)
  end
  # switch to FileUtils now to get verbose
  FileUtils.cd(rundir, opts)


  vers = '0.18.3' # testvers
  # vers = nil # nightly

  org = "https://github.com/tree-sitter/" 
  name = "tree-sitter/"
  subdir = 'lib/include/tree_sitter/'
  
  tag = vers ? "v#{vers}" : vers
  shunt = tag ? "tags/#{tag}/" : "trunk/"
  
  uri = org + name + shunt + subdir
#   dest = ''
  
  # let results all write to stdout and run > results.txt 
  
  puts
  puts "list repo subdir..."
  puts("svn ls #{uri}"); system("svn ls #{uri}")
  
  puts
  puts "checkout with no dest arg..."
  FileUtils.mkdir('svn_co_default', opts)
  FileUtils.cd('svn_co_default', opts)

  show_and_cmd("svn checkout #{uri}")
  puts "tree"; system("tree")
  FileUtils.cd('..', opts)
  
  puts
  puts "checkout with dest=. ..."
  FileUtils.mkdir('svn_co_dot', opts)
  FileUtils.cd('svn_co_dot', opts)

  show_and_cmd("svn checkout #{uri} .")
  puts "tree"; system("tree")
  FileUtils.cd('..', opts)
  
  puts
  puts "checkout with dest=oth/sub/ ..."
  FileUtils.mkdir('svn_co_oth_sub', opts)
  FileUtils.cd('svn_co_oth_sub', opts)

  show_and_cmd("svn checkout #{uri} oth/sub/")
  puts "tree"; system("tree")
  FileUtils.cd('..', opts)

  puts
  puts "skim repo subdir top level files only with no dest arg ..."
  FileUtils.mkdir('svn_co_skim_oth_sub', opts)
  FileUtils.cd('svn_co_skim_oth_sub', opts)

  show_and_cmd("svn checkout #{uri} oth/sub/ --depth files")
  puts "tree"; system("tree")
  FileUtils.cd('..', opts)
    
end



def was_show_svn_variants(rundir)
  # fill out test_and_doc() with RepoRefs and the variations, later!!!
  # for now, just note svn variants here, so we don't have to look it up again!!!

#   outdir = './dev-ref-pull/'
#   if Dir.exists?(rundir)
#   	unless Dir.empty?(rundir)
#   		puts "#{rundir} dir has stuff in it. exitting."
#   		exit 1
#   	end
#   else
#   	Dir.mkdir(rundir)
#   end
#   system("cd #{rundir}")
  opts = {verbose: true}

  if FileUtils.exists?(rundir, opts)
  	unless FileUtils.empty?(rundir, opts)
  		puts "#{rundir} dir has stuff in it. exitting."
  		exit 1
  	end
  else
  	FileUtils.mkdir(rundir, opts)
  end
  FileUtils.cd(rundir, opts)


  FileUtils.mkdir('show', opts)
  FileUtils.cd('show', opts)
  puts "tree"; system("tree")
  FileUtils.cd('..', {verbose: true})





  vers = '0.18.3' # testvers
  # vers = nil # nightly

  org = "https://github.com/tree-sitter/" 
  name = "tree-sitter/"
  subdir = 'lib/include/tree_sitter/'
  
  uri = org + name + subdir
#   dest = ''
  
  # let results all write to stdout and run > results.txt 
  
  puts
  puts "list repo subdir..."
  show_and_cmd("svn ls #{uri}")
  
  puts
  puts "checkout with no dest arg..."
  show_and_cmd("mkdir svn_co_default")
  show_and_cmd("cd svn_co_default")
    
  show_and_cmd("svn checkout #{uri}")
  show_and_cmd("tree")
  show_and_cmd("cd ..")
  
  puts
  puts "checkout with dest=. ..."
  show_and_cmd("mkdir svn_co_dot")
  show_and_cmd("cd svn_co_dot")
    
  show_and_cmd("svn checkout #{uri} .")
  show_and_cmd("tree")
  show_and_cmd("cd ..")
  
  puts
  puts "checkout with dest=oth/sub/ ..."
  show_and_cmd("mkdir svn_co_oth_sub")
  show_and_cmd("cd svn_co_oth_sub")
    
  show_and_cmd("svn checkout #{uri} oth/sub/")
  show_and_cmd("tree")
  show_and_cmd("cd ..")
  
  puts
  puts "skim repo subdir top level files only with no dest arg ..."
  show_and_cmd("mkdir svn_co_skim_oth_sub")
  show_and_cmd("cd svn_co_skim_oth_sub")
    
  show_and_cmd("svn checkout #{uri} oth/sub/ --depth files")
  show_and_cmd("tree")
  show_and_cmd("cd ..")
  
  
  
  
end

vers = '0.18.3' # testvers
# vers = '0.20.0'
# vers = '0.20.6'
# vers = '0.20.7'
# vers = nil # nightly

org = "https://github.com/tree-sitter/" 
name = "tree-sitter/"
subdir = 'lib/include/tree_sitter/'

# call = "svn checkout #{onedir} --depth files #{target}" # top level files only
# call = "RepoRefs.ls('#{org}', '#{name}', '#{vers}', '#{subdir}')"
# call = RepoRefs.pull()

### outer functions ONLY for testing here!!!

def ls(org, name, vers, subdir)
  call = "RepoRefs.ls(#{[org, name, vers, subdir].join(', ')})"
  puts "ls vers #{vers} with `#{call}`..."
  RepoRefs.ls(org, name, vers, subdir)
end

# doesn't keep subdir hierarchy, just names the containing dir dest
# nil or '' dest will create no container, just add files to cwd
def pull_as(org, name, vers, subdir, dest, keep_tree=false)
  call = "RepoRefs.pull_as(#{[org, name, vers, subdir, keep_tree].join(', ')})"
  puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
  RepoRefs.pull_as(org, name, vers, subdir, dest, keep_tree)
end
def pull(org, name, vers, subdir, dest='')
  call = "RepoRefs.pull(#{[org, name, vers, subdir].join(', ')})"
  puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
  RepoRefs.pull(org, name, vers, subdir, dest)
end

# ls(org, name, vers, subdir)
# pull_as(org, name, vers, subdir, 'oth/sub/')
# pull_as(org, name, vers, subdir, 'oth/sub/', true)
# pull(org, name, vers, subdir, 'oth/sub/')

# puts "Try skim..."
# # dest = '.' # creates no container, puts files in cwd
# dest = nil
# RepoRefs.skim(org, name, vers, subdir, dest)


# opts = {verbose: true}
# 
# FileUtils.mkdir('show', {verbose: true})
# FileUtils.cd('show', {verbose: true})
# puts "tree"; system("tree")
# FileUtils.cd('..', {verbose: true})
# 

show_svn_variants('show')

puts "done."
exit 0

# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end


