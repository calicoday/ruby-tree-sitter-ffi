require 'fileutils'
require 'erb'

# require './src/rusty/gen_rusty_util.rb'
# # require './src/rusty/rusty_prep_util.rb'
# require './src/rusty/rusty_prep_node.rb'
# require './src/rusty/rusty_prep_tree.rb'
# require './src/rusty/rusty_prep_query.rb'

require './src/rusty/tmp_gen_rusty_util.rb'
# shd be shunted!!! FIXME!!!

# require './src/tree-sitter-0.20.6/rusty-prep/boss_rusty_prep.rb'
# require './src/tree-sitter-0.20.6/rusty-prep/node_rusty_prep.rb'
# require './src/tree-sitter-0.20.6/rusty-prep/tree_rusty_prep.rb'
# require './src/tree-sitter-0.20.6/rusty-prep/query_rusty_prep.rb'

require 'awesome_print'

puts "src/rusty/gen_rusty.rb"
puts "+=+=+ " + `date`
puts

# RustyGen is class not module to keep ivars for ERB!!!

class RustyGen
	include GenUtils ###TMP!!! mv these methods!!!

  def self.gen_rusty(filer, bosslist)
    
    (['boss'] + bosslist).each do |e|
      path = Pathname.new('./') + filer.path(:reqs) + "#{e}_rusty_prep.rb"
      puts "=== path: #{path.inspect}"
      puts "  to_s: #{path.to_s.inspect}"
      path = filer.path(:reqs) + "#{e}_rusty_prep.rb"
      require './' + path.to_s
#       require Pathname.new('./') + filer.path(:reqs) + "#{e}_rusty_prep.rb"
    end
    self.new.gen_tests(filer, bosslist)
  end
  
  # ivars to pass to ERB
	attr_reader :srcfile, :boss, :testcalls, :testdefs, :stubs, :patchreqs
	
  def get_binding
    binding
  end

	def guts(s, vars="")
		tmp = respell_bindings(respell_lang(s, vars))
		# guard string, %q%%!!! FIXME!!
		tmp.split("\n").map{|e| e.gsub(/\/\/(.*)$/, '#\1')}.join("\n")
	end
	
	def gen_tests(filer, bosslist)
		@testcalls = []

#       klass = bosstag.capitalize + 'Sigs'
#       prep = Object::const_get(klass).new
    klass = 'Rusty' + 'Boss'
    bossprep = Object::const_get(klass) #.new('boss')
    
		bosslist.each do |e|
		  @boss = Object::const_get("Rusty#{e.capitalize}").new(e)
# 			@boss = case e
# 			when 'node' then RustyNode.new(e)
# 			when 'tree' then RustyTree.new(e)
# 			when 'query' then RustyQuery.new(e)
# 			else
# 			end
			
			puts "boss: #{boss.tag}"
			$log << "#{boss.tag}...\n"
			
			s = filer.read(:input, "#{boss.tag}_test.rs")
				
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
			
			filer.erb_write(:tmplt, 'rusty_tests.rb.erb', get_binding, 
			  "rusty_#{boss.tag}_test.rb")
	
			# comment out the skips
      good_tests = testdefs.reject{|m, guts, skip| skip &&
        skip.include?('internal')}.compact.map{|m, guts, skip| m}
      tests_string = good_tests.join("\n")


      # nope, gen rusty_patch_include.rb with require skip stubs files
			@stubs = testdefs.select{|m, guts, skip| skip && 
			  skip.is_a?(String) && !skip.include?('internal')}.compact
			@stubs = nil if stubs.empty?
			if stubs
			  puts "if stubs" #: #{stubs.inspect}"
			  @patchreqs ||= []
			  # form requires for patch blanks and cut '_blank' before gen run_rusty
			  			  
			  @patchreqs << filer.path(:out) + "rusty_#{boss.tag}_patch_blank.rb"
        filer.erb_write(:tmplt, 'rusty_patch.rb.erb', get_binding, 
          "rusty_#{boss.tag}_patch_blank.rb")
      end

			@testcalls << {
				bossreq: filer.path(:out) + "rusty_#{boss.tag}_test.rb",
				tests: tests_string}
				
			$log << "\n"

		end


		# for early testing...
    filer.erb_write(:tmplt, 'rusty_run.rb.erb', get_binding, "run_rusty_stubs.rb")

		# for real, when patch blanks have been filled
		@patchreqs = patchreqs.map{|e| e.to_s.gsub('_blank', '')}

		# rusty_run tmplt needs @testcalls {:bossreq, :tests}
    filer.erb_write(:tmplt, 'rusty_run.rb.erb', get_binding, "run_rusty.rb")			  
	end

end