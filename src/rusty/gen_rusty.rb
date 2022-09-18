require 'fileutils'
require 'erb'
require 'pathname'

require './src/rusty/gen_rusty_util.rb'
require './src/rusty/rusty_prep_node.rb'
require './src/rusty/rusty_prep_tree.rb'
require './src/rusty/rusty_prep_query.rb'

require 'awesome_print'

puts "src/rusty/gen_rusty.rb"
puts "+=+=+ " + `date`
puts

# argh, must run with this:
# ruby -e"require './src/rusty/gen_rusty.rb'; gen"

### from pull_repo_refs.rb
# vers_list = ['0.20.7', '0.20.6', '0.20.0'].map{|e| [e, "tree-sitter-#{e}"]}.to_h # <- to_h
# 
#   vers_list.each do |vers, dest|
#     show.section "Pull repo vers #{vers}..."
#     RepoRefs.pull_vers(repo_root, subdirs, vers, dest) do |subdir, dest, tidy|
# #         puts "*** call pull_vers #{[repo_root, subdirs, vers, dest].map(&inspect)}"
#       show.call(RepoRefs, :tidy, subdir, dest, tidy)
#     end
#   end

def gen()
	devdir = './src/rusty'
	gendir = './gen/rusty'
# 	ts_tests_dir = './dev-ref-keep/tree-sitter-0.19.5/cli/src/tests' # srcdir!!!
#   vers_list = ['0.19.5'].map{|e| 
#     [e, "/tree-sitter-#{e}"]}.to_h
  vers_list = ['0.20.7', '0.20.6', '0.20.0'].map{|e| 
    [e, "/tree-sitter-#{e}"]}.to_h # <- to_h!!!
  vers_list.each do |vers, dest|
    ts_tests_dir = "./dev-ref/pull/tree-sitter-#{vers}/cli/src/tests" # srcdir!!!
    outdir = gendir + dest
    g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
    $log = File.open(outdir + '/rusty-gen-log.rb', 'w')
    bosslist = ["node", "tree", "query"]
    g.gen_tests(bosslist)
   
  end
# 	g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
# 	$log = File.open(outdir + '/rusty-gen-log.rb', 'w')
# 	bosslist = ["node", "tree", "query"]
# 	g.gen_tests(bosslist)

	$log.close
	puts "done."
end

def pre_vers_gen()
	devdir = './src/rusty'
	gendir = './gen/rusty'
	ts_tests_dir = './dev-ref-keep/tree-sitter-0.19.5/cli/src/tests' # srcdir!!!
  vers_list = ['0.19.5'].map{|e| 
    [e, "/tree-sitter-#{e}"]}.to_h
#   vers_list = ['0.20.7', '0.20.6', '0.20.0'].map{|e| 
#     [e, gendir + "tree-sitter-#{e}"]}.to_h
  vers_list.each do |vers, dest|
#     outdir = gendir + dest
    outdir = gendir + dest
    g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
    $log = File.open(outdir + '/rusty-gen-log.rb', 'w')
    bosslist = ["node", "tree", "query"]
    g.gen_tests(bosslist)
   
  end
# 	g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
# 	$log = File.open(outdir + '/rusty-gen-log.rb', 'w')
# 	bosslist = ["node", "tree", "query"]
# 	g.gen_tests(bosslist)

	$log.close
	puts "done."
end

def was_gen()
	devdir = './src/rusty'
	gendir = './gen'
	outdir = gendir + '/rusty'
# 	ts_tests_dir = './dev-ref/pull/tree-sitter-0.19.5/cli/src/tests'
	ts_tests_dir = './dev-ref-keep/tree-sitter-0.19.5/cli/src/tests'
	g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
	$log = File.open(outdir + '/rusty-gen-log.rb', 'w')
	bosslist = ["node", "tree", "query"]
	g.gen_tests(bosslist)

	$log.close
	puts "done."
end

$womping = true

class RustyGen
	include GenUtils
	
  # ivars to pass to ERB
	attr_reader :srcfile, :boss, :testcalls, :testdefs, :stubs, :patchreqs
	
  def get_binding
    binding
  end
	
	def gen_tests(bosslist)
		@testcalls = []

		bosslist.each do |e|
			@boss = case e
			when 'node' then RustyNode.new(e)
			when 'tree' then RustyTree.new(e)
			when 'query' then RustyQuery.new(e)
			else
			end
			
			puts "boss: #{boss.tag}"
			$log << "#{boss.tag}...\n"
			
      @srcfile = srcdir + "/#{boss.tag}_test.rs"
			s = File.read(srcfile)
				
			@testdefs = []
			tests = s.split(/^fn/).map do |fn|
				# strip whitespace and end } and junk
				fn = fn.strip.gsub(/}[^{}]*\z/, '')
				_, m, rem = fn.split(/\A([^\(]*\([^\)]*\))[^{]*{\s*/)
				next unless m

				$log << "#{m}\n"
				
				skip = boss.skip_fn(m)
				rem = boss.preprocess(rem, m)
				testdefs << [m, guts(rem, m), skip]
				
				puts "#{m}: #{skip ? "skip (#{skip})" : ''}"
				$log << "  - skipped #{skip}\n" if skip

				m
			end.compact # remove nils where we nexted
			
			outfile = outdir + "/rusty_#{boss.tag}_test.rb"
			
			tmplt = File.read(devdir + '/rusty_tests.rb.erb')
			# rusty_tests tmplt needs @boss (#tag), @testdefs [m, guts, skip]
			File.write(outfile, ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
	
			# comment out the skips
      good_tests = testdefs.reject{|m, guts, skip| skip &&
        skip.include?('internal')}.compact.map{|m, guts, skip| m}
      tests_string = good_tests.join("\n")

      # nope, gen rusty_patch_include.rb with require skip stubs files
# 			@stubs = testdefs.select{|m, guts, skip| skip}.compact
# 			@stubs = testdefs.select{|m, guts, skip| skip && !skip.include?('internal')}.compact
			@stubs = testdefs.select{|m, guts, skip| skip && 
			  skip.is_a?(String) && !skip.include?('internal')}.compact
			@stubs = nil if stubs.empty?
			if stubs
			  puts "if stubs" #: #{stubs.inspect}"
			  @patchreqs ||= []
			  # form requires for patch blanks and cut '_blank' before gen run_rusty
			  @patchreqs << outdir + "/rusty_#{boss.tag}_patch_blank.rb"
        patchfile = outdir + "/rusty_#{boss.tag}_patch_blank.rb"
        tmplt = File.read(devdir + '/rusty_patch.rb.erb')
        # rusty_tests tmplt needs @boss (#tag), @testdefs [m, guts, skip]
        File.write(patchfile, ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
      end
	
			@testcalls << {
				bossreq: outfile,
				tests: tests_string}
				
			$log << "\n"

		end

		tmplt = File.read(devdir + '/rusty_run.rb.erb')
		# rusty_run tmplt needs @testcalls {:bossreq, :tests}, @patchreqs

		# for early testing...
		File.write(outdir+"/run_rusty_stubs.rb", 
			ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
			
		# for real, when patch blanks have been filled
		@patchreqs = patchreqs.map{|e| e.gsub('_blank', '')}
		
		# rusty_run tmplt needs @testcalls {:bossreq, :tests}
		File.write(outdir+"/run_rusty.rb", 
			ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
			
			
	end

	def guts(s, vars="")
		tmp = respell_bindings(respell_lang(s, vars))
		# guard string, %q%%!!! FIXME!!
		tmp.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
	end

end