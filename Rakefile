# coding: utf-8
# frozen_string_literal: false

def stamp() puts "+=+=+ " + `date` end
task :stamp do
	stamp
end

desc "=> build_and_install"
task :build => :build_and_install
desc "=> build_and_install"
task :install => :build_and_install

desc "build and install tree_sitter_ffi gem."
task :build_and_install do
	stamp
	puts "build tree_sitter_ffi gem."
	`gem build tree_sitter_ffi.gemspec`
	puts "install tree_sitter_ffi gem."
	`gem install --no-document tree_sitter_ffi-0.0.4.gem` ### gem num!!!
	puts "done."
end

desc "gen rusty tests"
task :gen_rusty do
  #cmdline: ruby -e"require './src/gen/rusty_gen.rb'; gen"
  `ruby -e"require './src/gen/rusty_gen.rb'; gen"`
  puts "gen_rusty done."
end

desc "run rusty tests"
task :run_rusty do
  `ruby gen/rusty/run_rusty.rb > output/run_rusty_out.txt`
  puts "run_rusty done."
end

desc "mv run_rusty_out.txt to run_rusty_out_keep.txt"
task :keep_run_rusty do
  `mv output/run_rusty_out.txt output/run_rusty_out_keep.txt`
  puts "keep_run_rusty done."
end