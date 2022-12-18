require 'awesome_print'

def scan_cladef(s)
  s.scan(/^(\s*(pub )?(fn|impl) [^{;]*|\s*(pub )?(struct|enum|trait) [^}]*})/)
end
def write_cladef(out, s)
  File.write(out, scan_cladef(s).map{|e| e[0]}.join("\n") + "\n")
end

out_dir = 'output/'

bind_dir = '/Users/cal/dev/tang22/tree-sitter/tree-sitter-0.20.0/lib/binding_rust/'
bind_fname = 'bindings.rs'
idio_fname = 'lib.rs'

bind_s = File.read(bind_dir + bind_fname)
idio_s = File.read(bind_dir + idio_fname)


def scan_prefixes(s) s.scan(/(ts_[^_]*_)/).map{|e| e[0]}.uniq end
# note: this will capture end \n in impl lines but not fn!!! strip before hash!!!
# wait, up. doesn't seem to!!!
def scan_fn(s) s.scan(/((^impl[^{]*)|(^\s*(pub )?fn \w+))/).map{|e| e[0]} end

def write_bind_prefixes(out, s)
  File.write(out, scan_prefixes(s).join("\n") + "\n")
end
def write_fn(out, s)
  File.write(out, scan_fn(s).join("\n") + "\n")
end


# dev writers for each kind of extraction
write_cladef(out_dir + 'idio_cladef.txt', idio_s)
write_fn(out_dir + 'idio_fn.txt', idio_s)

write_cladef(out_dir + 'bind_cladef.txt', bind_s)
write_bind_prefixes(out_dir + 'bind_prefixes.txt', bind_s)
write_fn(out_dir + 'bind_fn.txt', bind_s)

# dev peek
def show_plan(plan)
  plan.each do |k, v|
    puts "#{k} =>\n  #{v.join("\n  ")}"
  end; nil
end



prefixes = scan_prefixes(bind_s)
prefix_re = Regexp.new("(#{prefixes.join('|')})")

bind_fn_list = scan_fn(bind_s).map{|e| e.split(/(ts_\w*)/)}.map{|e| e[1]}

bind_fn_plan = {}
bind_fn_list.each do |e| 
  _, pre, name = e.split(prefix_re)
  bind_fn_plan[pre] ||= []
  bind_fn_plan[pre] << name
end

# show_plan(bind_fn_plan)
puts "=== bind_fn_plan"
pp bind_fn_plan


idio_fn_list = scan_fn(idio_s).map(&:strip)
idio_fn_plan_raw = {}
key = 'misc'
idio_fn_list.each do |e|
  next key = e if e =~ /^impl/
  idio_fn_plan_raw[key] ||= []
  idio_fn_plan_raw[key] << e.gsub(/(pub\s+)?fn\s+/, '')
end

idio_fn_plan = {}
idio_fn_plan_raw.each do |k, v|
  # cut impl and rust generics stuff
  k = k.gsub(/<[^\n>]*>+/, '').gsub(/impl\s*/, '')
  if k =~ / for /
    subkey = k.gsub(/([^\s]*).*/, '\\1')
    k = k.gsub(/.* for ([^\n]+)$/, '\\1')
  else
    subkey = 'base'
    k = k.gsub(/([^\s]*).*/, '\\1')
  end
  idio_fn_plan[k] ||= {}
  idio_fn_plan[k]['base'] ||= [] # so base always lists first
  idio_fn_plan[k][subkey] ||= []
  idio_fn_plan[k][subkey] = v
end

puts
puts "=== idio_fn_plan"
pp idio_fn_plan

sort_bind_base = {}
bind_fn_plan.each do |k, v|
  k = k.gsub(/ts_(\w+)_$/, '\\1').capitalize
  sort_bind_base[k] ||= []
  sort_bind_base[k] = v.sort
end

puts
puts "=== sort_bind_base"
pp sort_bind_base

sort_idio_base = {}
sort_idio_base = idio_fn_plan.map do |k, v|
  [k, v['base'].sort]
end.to_h # <- to_h!!!

puts
puts "=== sort_idio_base"
pp sort_idio_base


def prep_comm(left, right)
  left = [left] unless left.is_a?(Array) && left[0].is_a?(Array)
  right = [right] unless right.is_a?(Array) && right[0].is_a?(Array)
  left_arr, left_key = left
  left_key = :left unless left_key
  right_arr, right_key = right
  right_key = :right unless right_key

  combo = {}
  left_arr.each do |k|
    combo[k] = [left_key]
  end
  right_arr.each do |k|
    combo[k] ? combo[k] << right_key : combo[k] = [right_key]
  end
  
  combo.keys.map do |k|
    v = combo[k]
    next [k, :common] if v.length == 2
    v.include?(left_key) ? [k, left_key] : [k, right_key]    
  end
end


combo = prep_comm([sort_bind_base.keys, :bind_cla_keys], 
  [sort_idio_base.keys, :idio_cla_keys])
# combo = prep_comm(sort_bind_base.keys, sort_idio_base.keys)
puts
puts "=== combo prep_comm"
pp combo


def compose_comm(col_list, left_key, opts={})
  right_key = (col_list.map{|e| e[1]}.uniq - [left_key, :common])[0]
  left_label = opts[:left_label] || left_key
  right_label = opts[:right_label] || right_key
  tab = ' ' * (opts[:tab] || 8)
  line_len = opts[:line_len] || 70
  rule = '-' * line_len
#   single_line = (left.length + 1 + 'common'.length + 1 + right.length) < opts[:line_len]
  single_line = false
  header = (single_line ? "#{left} common #{right}" :
    [left_label.to_s,
    tab + 'common',
    tab + tab + right_label.to_s,
    rule])
  
  guts = col_list.map do |k, col|
    case col
    when left_key then k
    when :common then tab + k
    when right_key then tab + tab + k
    end
  end
  [header, guts]
end


puts
puts "=== keys compose_comm"

header, guts = compose_comm(combo, :bind_cla_keys, {tab: 16})
header = header.join("\n") unless header.is_a?(String)
puts header + "\n" + guts.join("\n") + "\n"


combo_select = combo.select{|k,col| col == :common}
puts
puts "=== combo select"
pp combo_select





puts
puts "done."

