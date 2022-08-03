require 'fileutils'
require 'erb'

require './src/gen/rusty_gen_util.rb'
require './src/gen/rusty_gen_node.rb'
require './src/gen/rusty_gen_tree.rb'
require './src/gen/rusty_gen_query.rb'

require 'awesome_print'

puts "src/gen/rusty_gen.rb"
puts "+=+=+ " + `date`
puts

# ruby -e"require './fresh/gen-step/rusty_gen_00.rb'; gen"

def gen()
	devdir = './src/gen'
	gendir = './gen'
	outdir = gendir + '/rusty'
	ts_tests_dir = './dev-ref/tree-sitter-0.19.5/cli/src/tests'
	g = RustyGen.new(ts_tests_dir, gendir, outdir, devdir)
	$log = File.open(outdir + '/rusty-log.rb', 'w')
	bosslist = ["node", "tree", "query"]
	g.gen_tests(bosslist)

	$log.close
	puts "done."
end

$womping = true

class RustyGen
	include GenUtils
	
  # ivars to pass to ERB
	attr_reader :srcfile, :boss, :testcalls, :testdefs
	
  def get_binding
    binding
  end
	
# 	def gen_tests(bosslist)
# 		gen_base(bosslist)
# 		self # reorg this!!!
# 	end
# 
# 
# 	# gen_tests(["node", "tree"])
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
				
				puts "#{m}: #{skip ? 'skip' : ''}"
				$log << "  - skipped #{skip}\n" if skip

				m
			end.compact # remove nils where we nexted
			
			outfile = outdir + "/rusty_#{boss.tag}_test.rb"
			
			tmplt = File.read(devdir + '/rusty_tests.rb.erb')
			# rusty_tests tmplt needs @boss (#tag), @testdefs [m, guts, skip]
			File.write(outfile, ERB.new(tmplt, trim_mode: "%<>").result(get_binding))
	
			# comment out the skips
			tests_string = tests.map{|m| 
				boss.skip_fn(m) ? m.split("\n").map{|e| e.gsub(/^/, '# ')}.join("\n") : m
			}.join("\n")
			
			@testcalls << {
				bossreq: outfile,
				tests: tests_string}
				
			$log << "\n"

		end

		tmplt = File.read(devdir + '/rusty_run.rb.erb')
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