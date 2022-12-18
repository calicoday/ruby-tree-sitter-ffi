require 'fileutils'
require 'pathname'

class Filer
  attr_reader :dir, :write_dir, :write_f, :write_filepath

  def initialize(*args)
    @dir = {}
    @write_dir = {}
    @write_f = {}
    @write_filepath = {}
    prepare_dirs(*args) unless args.empty?
  end
  
  def pretty(arr, depth=0, &b)
    return unless arr
    arr.each do |e|
      next unless e # hop over nils???
      case e
      when Array
        pretty(e, depth + 1, &b)
      when Hash
        e = e[:after]
        pretty(e, depth + 1, &b)
        yield('  '*depth + "\n")
      else
        yield('  '*depth + e.to_s + "\n")
      end
    end
  end
  
  def path(key, writable=false)
    return write_dir[key] if writable
    dir[key] || write_dir[key]
  end
	def prepare_dirs(dirs, write_dirs={})
	  write_dirs.each{|k,v| add_dir(k, v, true)}
	  dirs.each{|k, v| add_dir(k, v)}
	end
	def add_dir(key, path, writable=false)
	  path = Pathname.new(path)
	  prev = write_dir[key] || dir[key]
	  raise "Filer#add_dir already have #{key.inspect} (#{prev})" if prev
	  return dir[key] = path unless writable
	  write_dir[key] = ensure_outpath(path)
	  raise "Filer#add_dir #{path} has stuff in it. exiting." unless write_dir[key]
	end
	
  def ensure_outpath(outpath)
    if Dir.exist?(outpath)
      unless Dir.empty?(outpath)
        return nil # exit above
      end
    else
      FileUtils.mkdir_p(outpath)
      ### conv for bbedit hier search, .gitignored
      File.write(Pathname.new(outpath) + 'agen_search_anchor.txt', 
        "# conv for bbedit hier search")
    end
    outpath
  end
	  
  
  def read(key, filename)
    d = dir[key] || write_dir[key]
    raise "Filer#read unknown dir key #{key.inspect}" unless d
    File.read(d + filename)
  end
  
  def write(key, filename, v, mode='w')
    d = write_dir[key]
    raise "Filer#write unknown dir key #{key.inspect}" unless d
    File.write(d + filename, v, {mode: mode})
  end
  
  # no mode???
  def erb_write(key, tmpltname, params, outfile, outkey=:out)
    tmplt = read(key, tmpltname)
    write(outkey, outfile, ERB.new(tmplt, trim_mode: "%<>").result(params))
	end

	
  def write_open(key, filekey, filename, mode='w')
    d = write_dir[key]
    raise "Filer#write_open unknown dir key #{key.inspect}" unless d   
    f = write_f[filekey]
    f.close if f
    f = File.open(d + filename, mode)
    raise "Filer#write_open couldn't File.open(#{d+filename}, #{mode})" unless f
    write_filepath[filekey] = [d, filename]
    write_f[filekey] = f
  end
  def write_filedir(key) 
    raise "Filer no #{key.inspect} file open" unless write_f && write_f[key]
    write_filepath[key][0]
  end
  def write_filename(key) 
    raise "Filer no #{key.inspect} file open" unless write_f && write_f[key]
    write_filepath[key][1]
  end
  
  def write_some(key, v)
    raise "Filer no #{key.inspect} file open" unless write_f && write_f[key]
    write_f[key].write(v)
  end

  def write_close(key) 
    return unless write_f && write_f[key]
    write_f.delete(key).close
  end
  def write_close_all(key)
    write_f.each_key{|e| write_f.delete(e).close} if write_f
  end

end