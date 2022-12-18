require './src/util/optimist'

class Sunny

  def ready(cmd_list=nil, cmd_blk=nil, &b)
    self.class.ready(cmd_list, cmd_blk, &b)
  end

  def add_to_loadpath(dir)
    $LOAD_PATH.unshift(Pathname.pwd + dir)
  end

  def self.go(file)
    return unless File.identical?(file, $0)
    self.new
  end
    
  # using Optimist orig flow style, ie instance_eval in far context.
  # Create Optimist::Parser, rather than call Optimist.options,
  # then parse in Optimist::with_standard_exception_handling blk.
  # Must use opter.die instead of Optimist::die bc not Optimist.options.
  def self.ready(cmd_list=nil, cmd_blk=nil, &b)
    # catch cmd_opts passed w no cmd_list
    if cmd_list && !cmd_list.is_a?(Array)
      raise "ready expected array cmd_list, proc cmd_opts or no args."
    end

    g_opter = Optimist::Parser.new(&b)
    g_opter.stop_on(cmd_list) if cmd_list
    
    # parse g_opts
    g_opts = Optimist::with_standard_exception_handling(g_opter){g_opter.parse(ARGV)}

    return [g_opts] unless cmd_list
    
    # parse c_opts
    cmd = ARGV.shift
    g_opter.die("missing subcommand") unless cmd
    g_opter.die("unknown subcommand #{cmd.inspect}") unless cmd_list.include?(cmd)
    
    c_opter = Optimist::Parser.new
    cmd_blk.call(c_opter, cmd) if cmd_blk
    c_opts = Optimist::with_standard_exception_handling(c_opter){
      c_opter.parse(ARGV)}

    # look up cmd name plan, eg for localization
    [g_opts, cmd, c_opts]
  end

end

