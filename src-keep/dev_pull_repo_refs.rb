# copy useful tree-sitter repo files for a given version.

# run from proj dir:
# $ ruby dev_pull_repo_refs.rb tag

require 'fileutils'

vers = ARGV[1] || '' # no arg gets nightly???

tags_list_ref = ['0.20.7', '0.20.6', '0.20.0'] 
tag = '0.20.6' # get from ARGV



outdir = './dev-ref-pull/'
if Dir.exists?(outdir)
	unless Dir.empty?(outdir)
		puts "#{outdir} dir has stuff in it. exitting."
		exit 1
	end
else
	Dir.mkdir(outdir)
end

# repo_home = "https://github.com/tree-sitter/tree-sitter/" 
repo_org = "https://github.com/tree-sitter/" 
repo_name = "tree-sitter/"
repo_nightly = repo_org + "trunk/" + repo_name
repo_tag = repo_org + "tags/" + "v#{tag}/" + repo_name

tag = nil


repo = (tag ? repo_tag : repo_nightly)

target = outdir + "tree-sitter-#{tag ? tag : 'nightly'}"

# rel proj dir:
ref_dirs = ['lib/include/']

subdir = 'lib/include'

puts "Pulling #{tag ? tag : ':nightly'} from #{repo}..."

# ref_dirs.each{|subdir|}
FileUtils.mkdir_p(target) # also mk intermediate subdirs
###`cd #{target}; svn ls #{repo}#{subdir}`
# `cd #{target}; svn checkout #{repo}#{subdir}`
# system("cd #{target}")
# system("svn ls #{repo}#{subdir}")

path = "https://github.com/tree-sitter/tree-sitter-c"
puts "Nope, just ls #{path}..."

system("svn ls #{path}")

# system("ls")
# `ls`

puts "done."



# check each lang dir for scanner.c/scanner.cc
# puts "List scanner for each lang..."
# langs.keys.map do |lang|
#   Dir.children(target + "/src").select{|e| e =~ 'scanner'}.each{|e| puts "#{lang}: #{e}"}
# end

