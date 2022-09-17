# add method_missing passthrough to FileUtils, etc???

class ShowRunner
  attr_reader :chatty, :lines

  def self.ensure_outdir(outdir)
    if Dir.exist?(outdir)
      unless Dir.empty?(outdir)
        puts "#{outdir} dir has stuff in it. exitting."
        exit 1
      end
    else
      Dir.mkdir(outdir)
    end
  end
  
  def initialize(chatty=nil)
    # :tee ???
    @chatty = chatty # filename or :stdout or falsey for quiet
    # logging to a file doesn't work yet, not capturing stdout/stderr!!!
    # for now, copy and paste to results.txt from terminal!!!
    @chatty = :stdout
    @lines = []
  end
  
  def note(msg)
    return unless chatty
    chatty == :stdout ? puts(msg) : lines << msg
  end
  
  def write
    return unless chatty && chatty != :stdout
    File.write(chatty, lines.join("\n"))
  end

  def call(obj, m, *args) 
    note("> #{obj}.#{m.to_s}(#{args ? args.map(&:inspect).join(', ') : ''})")
    obj.send(m, *args) 
  end
  def call_sys(*args) call(Object, :system, *args) end

  def section(msg) note("\n=== #{msg}") end

end

