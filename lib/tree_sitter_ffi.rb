# coding: utf-8
# frozen_string_literal: false

puts "+++ #{File.expand_path(File.dirname(__FILE__))}" # TMP!!! so we can see gem vs lib/

# require 'tree_sitter_ffi/version'
# require 'tree_sitter_ffi/unit_memory'
# require 'tree_sitter_ffi/boss'
# require 'tree_sitter_ffi/types'
# require 'tree_sitter_ffi/node'
# require 'tree_sitter_ffi/tree'
# require 'tree_sitter_ffi/language'
# require 'tree_sitter_ffi/query'
# require 'tree_sitter_ffi/parser'


# require 'tree_sitter_ffi/tree_sitter_ffi' # when we have tidy+
# case ENV['TREE_SITTER_RUNTIME']
# when '0.20.6'
#   require 'tree_sitter_ffi/tree_sitter_ffi_0_20_6' 
# else
#   require 'tree_sitter_ffi/tree_sitter_ffi_0_20_7' 
# end
vers = ENV['TREE_SITTER_RUNTIME']
vers = '0.20.7' unless vers


puts 'before extend FFI::Library'

require 'ffi'
# require 'boss_ffi'

### VERSION!!! 

module TreeSitterFFI
  extend FFI::Library
  vers_from_env = ENV['TREE_SITTER_RUNTIME']
  vers_from_env = '0.20.7' unless vers_from_env
  puts "vers_from_env: #{vers_from_env}"
#   ffi_lib 'tree-sitter/libtree-sitter.0.20.6'
  ffi_lib "/usr/local/lib/tree-sitter/libtree-sitter.#{vers_from_env}.dylib"
  def self.api_h_version() "#{ENV['TREE_SITTER_RUNTIME']}" end
  def self.add_lang(lang, lib)
#     raise "already have :#{lang}" if respond_to?(:lang)
#     if respond_to?(lang)
#       puts "%%% already have :#{lang}"
#       return
#     end
    # what about diff vers, unloading...???
    return if respond_to?(lang)
    ffi_lib lib
    attach_function lang, [], :pointer
  end
end

# puts 'after extend FFI::Library'

# do the ffi_lib here??? 
# get path to version_roster.json (must be versioned json, any name)
roster = ENV['TREE_SITTER_VERSION_ROSTER']


require "tree_sitter_ffi/tree_sitter_ffi_#{vers.tr('.', '_')}"

# puts 'after require raw'

require 'tree_sitter_ffi/types_patch.rb'

# puts 'after require types_patch'

require 'tree_sitter_ffi/bind/bind_rust'