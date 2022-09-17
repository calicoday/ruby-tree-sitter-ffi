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
  def tag(vers) (vers ? "v#{vers}" : vers) end
  
  def url(org, name, subdir, tag) 
    shunt = tag ? "tags/#{tag}/" : "trunk/"
    # use Pathname to handle nec/unnec '/' seps
    Pathname.new(org) + name + shunt + subdir 
  end
  
  def pull(org, name, vers, subdir, dest=nil) # vers!!!
    subdir = '' unless subdir
    dest = '' unless dest
    system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest}") 
  end
  
  def ls(org, name, vers, subdir='') 
    system("svn ls #{url(org, name, subdir, tag(vers))}")
  end

  # checkout top level files only, eg for vers check (can't checkout just single file)
  def skim(org, name, vers, subdir, dest=nil) 
    system("svn checkout #{url(org, name, subdir, tag(vers))} #{dest} --depth files") 
  end

  
end

# class RepoRefsPullSvn
class RepoRefsKlass
  attr_reader :org, :name, :tag
  
  def initialize(org, name, vers)
    @org = org
    @name = name
    # for tree-sitter, number tags now start with 'v' (other repos may differ)
    @tag = (vers ? "v#{vers}" : vers)
  end
  # override tag()/tag=() or accept block for other patterns???
    
  def self.pull(org, name, vers, subdir, dest=nil) # vers!!!
    self.new(org, name, vers).pull_to(subdir, dest)
  end
  def self.ls(org, name, vers, subdir='') 
    self.new(org, name, vers).ls(subdir) 
  end
  
  # untested!!! FIXME!!!
#   def self.pull_all(*args)
#     reqd = [:org, :name, :vers, :subdirs]
#     args = [reqd.zip(args)] unless args[0].is_a?(Array)
#     args.each do |repo_rec|
#       runner = self.new(repo_rec[:org], repo_rec[:name], repo_rec[:vers])
#       repo_rec[:subdirs].each do |subdir|
#         runner.pull_to(repo_rec[:dest], subdir)
#       end
#     end
#   end

  # dest = '.' # this puts the CONTENTS of the checkout dir in the cwd
  # dest = '' # this creates dir and contents from src in proj dir
  # dest = 'oth/sub/' # rel to proj dir, svn will create it if nec, incl subdirs
  def pull_to(subdir, dest='') 
    subdir = '' unless nil
    system("svn checkout #{url(subdir)} #{dest}") 
  end
#   def pull(subdir='') pull_to(subdir) end
  



  
#   .delete_prefix('https:/')
  def url(subdir='') 
    frag = tag ? "tags/#{tag}/" : "trunk/"
    # use Pathname to handle nec/unnec '/' seps
#     puts "org: #{org.inspect}, name: #{name.inspect}, frag: #{frag.inspect}, subdir: #{subdir.inspect}"
    pp [:org, :name, :frag, :subdir].zip([org, name, frag, subdir]).to_h
    Pathname.new(org) + name + frag + subdir 
  end
    
  def ls(subdir='') system("svn ls #{url(subdir)}") end

  # dest = '.' # this puts the CONTENTS of the checkout dir in the cwd
  # dest = '' # this creates dir and contents from src in proj dir
  # dest = 'oth/sub/' # rel to proj dir, svn will create it if nec, incl subdirs
  def pull_to(dest, subdir='') 
    system("svn checkout #{url(subdir)} #{dest}") 
  end
  def pull(subdir='') pull_to('', subdir) end
  
  # checkout top level files only, eg for vers check (can't checkout just single file)
  def skim(dest, subdir='') 
    system("svn checkout #{url(subdir)} #{dest} --depth files") 
  end

end

class NotRepoRefRunner
  attr_reader :org, :name, :vers, :subdir, :dest
  
  def initialize
    @vers = '0.18.3' # testvers
    # vers = '0.20.0'
    # vers = '0.20.6'
    # vers = '0.20.7'
    # vers = nil # nightly

    @org = "https://github.com/tree-sitter/" 
    @name = "tree-sitter/"
    @subdir = 'lib/include/tree_sitter/'
  end

  def ls(vers)
    call = "RepoRefs.ls(#{[org, name, vers, subdir].join(', ')})"
    puts "ls vers #{vers} with `#{call}`..."
    RepoRefs.pull(org, name, vers, subdir)
  end

  def pull(vers)
    call = "RepoRefs.pull(#{[org, name, vers, subdir].join(', ')})"
    puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
    RepoRefs.pull(org, name, vers, subdir)
  end
end

# runner = RepoRefRunner.new
# runner.ls(vers)


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


def ls(org, name, vers, subdir)
  call = "RepoRefs.ls(#{[org, name, vers, subdir].join(', ')})"
  puts "ls vers #{vers} with `#{call}`..."
  RepoRefs.ls(org, name, vers, subdir)
end

def pull(org, name, vers, subdir, dest='')
  call = "RepoRefs.pull(#{[org, name, vers, subdir].join(', ')})"
  puts "Checkout vers #{vers ? vers : ':nightly'} with `#{call}`..."
  RepoRefs.pull(org, name, vers, subdir)
end

# ls(org, name, vers, subdir)
pull(org, name, vers, subdir, 'oth/sub/')

puts "done."
exit 0

# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end


### scrap


# repo_home = "https://github.com/tree-sitter/tree-sitter/" 
repo_org = "https://github.com/tree-sitter/" 
repo_name = "tree-sitter/"

# repo_nightly = repo_org + "trunk/" + repo_name
# repo_tag = repo_org + "tags/" + "v#{tag}/" + repo_name

tag = nil


# repo = (tag ? repo_tag : repo_nightly)

# target = outdir + "tree-sitter-#{tag ? tag : 'nightly'}"

# rel proj dir:
ref_dirs = ['lib/include/']

# subdir = 'lib/include'
# subdir = '/trunk/src'
# subdir = ''

###puts "Pulling #{tag ? tag : ':nightly'} from #{repo}..."

# ref_dirs.each{|subdir|}
###FileUtils.mkdir_p(target) # also mk intermediate subdirs

###`cd #{target}; svn ls #{repo}#{subdir}`
# `cd #{target}; svn checkout #{repo}#{subdir}`
# system("cd #{target}")
# system("svn ls #{repo}#{subdir}")


# path = "https://github.com/tree-sitter/tree-sitter-c"
path = "https://github.com/tree-sitter/tree-sitter-c/trunk/tree-sitter-c"

# puts "Nope, just ls #{path}..."

# system("svn ls #{repo}#{subdir}")

# (org, name, tag=nil)
# frag = (tag ? "tags/v#{tag}/" : "trunk/")
# url = org + name + frag + subdir

# v = "https://github.com/tree-sitter/tree-sitter-c"
v = "https://github.com/tree-sitter/tree-sitter"
# path = "#{v}/trunk/src/"
# path = "#{v}/trunk/lib"
path = "#{v}/tags/v0.20.0/lib"

# master = nightly, tree = trunk
# puts "Nope, just `ls #{path}`..."
# system("svn ls #{path}")
# system("svn ls #{v}/trunk/src")

tag = '0.20.6' #'0.20.0'
one = "#{v}/tags/v#{tag}/" + "cli/Cargo.toml" ### NOPE!!! only dirs!!!
onedir = "#{v}/tags/v#{tag}/" + "cli/"
# system("svn checkout #{one} --depth empty")

# target = '.' # this puts the CONTENTS of the checkout dir in the cwd
# target = '' # this creates dir and contents from src in proj dir
target = 'oth/sub/' # rel to proj dir, svn will create it if nec, incl subdirs


call = "svn checkout #{onedir} --depth files #{target}" # top level files only
puts "Checkout only files in dir #{onedir} with `#{call}`..."
ret = system(call)

puts "sys return: #{ret}"

### eg false return:
# cal@steel dev-safe % ruby dev_pull_repo_refs.rb   
# Checkout only files in dir https://github.com/tree-sitter/tree-sitter/tags/v0.20.6/cli/ with `svn checkout https://github.com/tree-sitter/tree-sitter/tags/v0.20.6/cli/ --depth files`...
# svn: E155000: '/Users/cal/dev/tang22/ta-tree-sitter-ffi/ruby-tree-sitter-ffi/dev-safe/cli' is already a working copy for a different URL
# sys return: false
# done.

# system("ls")
# `ls`

puts "done."



# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end

