
require 'fileutils'

class GenRunner
#   include GenUtils  
  
  attr_reader :womping, :dir, :write_f

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
	end
	
	# this shd be ensure_outpath_empty/ensure_outpath_keep
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
  
  def read(key, filename)
    d = dir[key]
    raise "GenRunner#read unknown dir key #{key.inspect}" unless d
    File.read(d + filename)
  end
  
  
  def write(key, filename, v, mode='w')
    d = dir[key]
    raise "GenRunner#write unknown dir key #{key.inspect}" unless d
    File.write(d + filename, mode)
  end
  
  # no mode???
  def erb_write(key, tmpltname, params, outfile, outkey=:out)
    d = dir[key]
    raise "GenRunner#erb_write unknown dir key #{key.inspect}" unless d   
    tmplt = File.read(d + tmpltname)
    out_d = dir[outkey]
    raise "GenRunner#erb_write unknown outdir key #{key.inspect}" unless out_d   
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

end