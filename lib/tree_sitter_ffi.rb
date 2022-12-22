# coding: utf-8
# frozen_string_literal: false

puts "+++ #{File.expand_path(File.dirname(__FILE__))}" # TMP!!! so we can see gem vs lib/

require 'tree_sitter_ffi/version'

require 'ffi'

module TreeSitterFFI
#   extend FFI::Library
  
  # meaningless unless TREE_SITTER_RUNTIME_VERSION is supplied!!! FIXME!!!
  def self.api_h_version() "#{ENV['TREE_SITTER_RUNTIME_VERSION']||'unknown'}" end
  
  # must be used by this header (and only this header) before loading the classes
  # bc they add methods as they are read -- refac this to encapsulate!!! FIXME!!!
  def self.add_runtime(lib)
    # check if runtime already added??? FIXME!!!
    # ignore lib and pivot if versioning
    vers = ENV['TREE_SITTER_RUNTIME_VERSION']
    if vers
      lib = "/usr/local/lib/tree-sitter/libtree-sitter.#{vers}.dylib"
    end
    raise "Can't find runtime lib '#{lib}'" unless File.exist?(lib)
    extend FFI::Library
    ffi_lib lib
  end
  
  def self.add_lang(lang, lib)
    # what about diff vers, unloading...???
    return if respond_to?(lang)
    # ignore lib and pivot if versioning
    if ENV['TREE_SITTER_RUNTIME_VERSION']
      lib = find_lang_lib(lang)
    end  
    raise "Can't find lang lib '#{lib}'" unless File.exist?(lib)
    ffi_lib lib
    attach_function lang, [], :pointer
  end
  
  # adapted from BindRust was_get_language() ### TMP!!!
  def self.find_lang_lib(lang)
	  vers_roster = {
      tree_sitter_bash: '0.19.0',
      tree_sitter_c_sharp: '0.20.0',
      tree_sitter_c: '0.20.2',
      tree_sitter_cpp: '0.20.0',
      tree_sitter_embedded_template: '0.20.0',
      tree_sitter_html: '0.19.0',
      tree_sitter_javascript: '0.20.0',
      tree_sitter_json: '0.19.0',
      tree_sitter_make: 'untagged',
      tree_sitter_markdown: '0.7.1',
      tree_sitter_python: '0.20.0',
      tree_sitter_ruby: '0.19.0',
      tree_sitter_rust: '0.20.3',	  
    }
#     puts "=== lang: #{lang.inspect}+++"
    lib_vers = vers_roster[lang]
    repo_name = lang.to_s.gsub(/_/, '-')
    lib = "/usr/local/lib/#{repo_name}/lib#{repo_name}.#{lib_vers}.dylib"
    raise "Can't find lang lib '#{lib}'" unless File.exist?(lib)
    lib
  end
end


# get path to version_roster.json (must be versioned json, any name)
roster = ENV['TREE_SITTER_VERSION_ROSTER']

raise "Missing ENV var TREE_SITTER_RUNTIME_LIB" unless ENV['TREE_SITTER_RUNTIME_LIB'] || ENV['TREE_SITTER_RUNTIME_VERSION']
vers = ENV['TREE_SITTER_RUNTIME_VERSION']
vers = '0.20.7' unless vers
TreeSitterFFI.add_runtime(ENV['TREE_SITTER_RUNTIME_LIB'])

require "tree_sitter_ffi/tree_sitter_ffi_#{vers.tr('.', '_')}"

# puts 'after require raw'

require 'tree_sitter_ffi/types_patch.rb'

# puts 'after require types_patch'

require 'tree_sitter_ffi/bind/bind_rust'