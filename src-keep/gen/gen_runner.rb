
# class RustyRunner < GenRunner
#   def srcfile(tag) "/#{tag}_test.rs" end
#   def outfile(tag) "/rusty_#{tag}_test.rb" end
# end

require 'fileutils'

class GenRunner
#   include GenUtils  
  
  attr_reader :womping, :dir, :write_f
# 	attr_reader :srcdir, :gendir, :outdir, :devdir

  # cd method_missing???
  def srcdir() dir[:src] end
  def gendir() dir[:gen] end
  def outdir() dir[:out] end
  def devdir() dir[:dev] end
  
  def initialize
    @womping = false
    @dir = {}
    @write_f = {}
  end
  
# 	devdir = './src/gen'
# 	gendir = './gen'
# 	outdir = gendir + '/rusty'
# 	ts_tests_dir = './dev-ref/tree-sitter-0.19.5/cli/src/tests'
  # legacy match GenUtils
	def legacy_prepare_dirs(srcdir, gendir, outdir, devdir, womping=false)
	  @womping = womping
	  # drops any existing!!! prob only called once
	  @dir = {}
	  dir[:src] = srcdir
	  dir[:gen] = gendir
	  dir[:out] = outdir
	  dir[:dev] = devdir
	  build_dirs
# 		@devdir = devdir
# 		@gendir = gendir
# 		@srcdir = srcdir
# 		@outdir = outdir
# 		Dir.mkdir(gendir) unless Dir.exists?(gendir)
# 		if Dir.exists?(outdir) && !womping
# 			raise "#{outdir}-keep dir exists. exitting." if Dir.exists?(outdir + "-keep")
# 			::FileUtils.mv(outdir, outdir + "-keep")
# 		elsif Dir.exists?(outdir + "-keep") && !womping
# 			$warn_exists = "Warning: #{outdir}-keep dir already existed but #{outdir} did not."
# 		end
# 		Dir.mkdir(outdir) unless Dir.exists?(outdir)
# 
# 		raise "no #{outdir} dir. exitting." unless Dir.exists?(outdir)
# 		File.write(outdir+"/cp_or_mv_before_edit.txt", 
# 		  "Script will womp generated files. Copy or move elsewhere before edit.")
	end
	
	def build_dirs
		Dir.mkdir(gendir) unless Dir.exists?(gendir)
		if Dir.exists?(outdir) && !womping
			raise "#{outdir}-keep dir exists. exitting." if Dir.exists?(outdir + "-keep")
			::FileUtils.mv(outdir, outdir + "-keep")
		elsif Dir.exists?(outdir + "-keep") && !womping
			$warn_exists = "Warning: #{outdir}-keep dir already existed but #{outdir} did not."
		end
		Dir.mkdir(outdir) unless Dir.exists?(outdir)

		raise "no #{outdir} dir. exitting." unless Dir.exists?(outdir)
	end
  
#   def src_read(filename) File.read(runner.srcdir + filename) end
  def read(key, filename)
    d = dir[key]
    raise "GenRunner#read unknown dir key #{key.inspect}" unless d
    File.read(d + filename)
  end
  
  # collect the only File calls
#   def read_path(path) File.read(path) end
#   def write_path(path, mode='w') File.write(path, mode) end
    
  
  def write(key, filename, v, mode='w')
    d = dir[key]
    raise "GenRunner#write unknown dir key #{key.inspect}" unless d
#     write_path(d + filename, mode)
    File.write(d + filename, mode)
  end
  
  # no mode???
  def erb_write(key, tmpltname, params, outfile, outkey=:out)
    d = dir[key]
    raise "GenRunner#erb_write unknown dir key #{key.inspect}" unless d   
    tmplt = File.read(d + tmpltname)
    out_d = dir[outkey]
    raise "GenRunner#erb_write unknown outdir key #{key.inspect}" unless out_d   
#     write_path(out_d + outfile, ERB.new(tmplt, trim_mode: "%<>").result(params))
    File.write(out_d + outfile, ERB.new(tmplt, trim_mode: "%<>").result(params))
	end
	
  def write_open(key, filekey, filename, mode='w')
    d = dir[key]
    raise "GenRunner#write_open unknown dir key #{key.inspect}" unless d   
    f = write_f[filekey]
    f.close if f
    f = File.open(d + filename, mode)
    raise "GenRunner#write_open couldn't File.open(#{d+filename}, #{mode})" unless f
    write_f[filekey] = f
  end
  
  def write_some(key, v)
    raise "GenRunner no #{key.inspect} file open" unless @write_f && @write_f[key]
    write_f[key].write(v)
  end
#   f_key = (key.to_s + '_f').to_sym

  def write_close(key) 
    return unless @write_f && @write_f[key]
    write_f.delete(key).close
  end
  def write_close_all(key)
    write_f.each_key{|e| write_f.delete(e).close} if @write_f
  end
    
  
#   def srcpath(filename) srcdir + filename end
#   def outpath(filename) outdir + filename end
#   def tmpltpath(filename) devdir + filename end
  
#   def was_erb_write(tmpltname, params, outfile)
# 			tmplt = File.read(tmpltpath(tmpltname))
# 			# rusty_tests tmplt needs @boss (#tag), @testdefs [m, guts, skip]
# 			File.write(outpath(outfile), ERB.new(tmplt, trim_mode: "%<>").result(params))
# 	end
  

end