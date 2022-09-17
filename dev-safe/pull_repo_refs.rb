require './repo_refs.rb'
require './show_runner.rb'

vers = ARGV[1] || '' # no arg gets nightly???

tags_list_ref = ['0.20.7', '0.20.6', '0.20.0'] 
tag = '0.20.6' # get from ARGV

outdir = './dev-ref-pull/'

subdirs = ['lib/include/tree_sitter/', 'cli/src/tests/']

class PullRepoRefs

  def do_the_thing
    show = ShowRunner.new
    
    ensure_outdir(outdir)
    Dir.cd(outdir)
    
    org = "https://github.com/tree-sitter/" 
    name = "tree-sitter/"
#     subdir = 'lib/include/tree_sitter/'

    vers_list = ['0.20.0']
#     vers_list = ['0.20.7', '0.20.6', '0.20.0']
    vers_list.each do |vers|
      show.section "Pull repo vers #{vers}..."
      subdir.each do |subdir|
        dest = "tree-sitter-#{vers}/"
        show.call(RepoRefs, :pull, org, name, vers, subdir, dest)
#         show.call(RepoRefs, :pull, org, name, vers, subdir)
      end
    end
    
    puts 
    puts "done."
  end
  
#   def self.ensure_outdir(outdir)
  def ensure_outdir(outdir)
    if Dir.exist?(outdir)
      unless Dir.empty?(outdir)
        puts "#{outdir} dir has stuff in it. exitting."
        exit 1
      end
    else
      Dir.mkdir(outdir)
    end
  end
  
ensure_outdir(outdir)

