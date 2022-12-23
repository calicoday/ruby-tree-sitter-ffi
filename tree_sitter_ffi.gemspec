# coding: utf-8
# frozen_string_literal: true

require File.expand_path('lib/tree_sitter_ffi/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'tree_sitter_ffi'
  s.version = TreeSitterFFI::VERSION
  s.date = '2022-12-22'
  s.summary = 'Ruby ffi bindings for tree-sitter'
  s.authors = ['Calicoday']
  s.email = 'calicoday@gmail.com'
  s.licenses = ['MIT']
  s.homepage = 'https://www.github.com/calicoday/ruby-tree-sitter-ffi'

#   s.extensions = ['ext/simple_clipboard/extconf.rb']
  s.files = [
    'lib/boss_ffi.rb',
    'lib/boss_ffi/version.rb',
    'lib/boss_ffi/boss_ffi.rb',
    'lib/boss_ffi/unit_memory.rb',
    'lib/boss_ffi/boss.rb',
    'lib/boss_ffi/spec_obj_build.rb',

    'lib/tree_sitter_ffi/version.rb',
    'lib/tree_sitter_ffi.rb',

    'lib/tree_sitter_ffi/tree_sitter_ffi_0_20_0.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/tree_sitter_ffi_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/types_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/language_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/node_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/parser_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/query_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/query_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/tree_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_0/tree_raw.rb',
    
    'lib/tree_sitter_ffi/tree_sitter_ffi_0_20_6.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/tree_sitter_ffi_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/types_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/language_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/node_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/parser_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/query_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/query_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/tree_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_6/tree_raw.rb',
    
    'lib/tree_sitter_ffi/tree_sitter_ffi_0_20_7.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/tree_sitter_ffi_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/types_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/language_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/node_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/parser_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/query_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/query_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/tree_cursor_raw.rb',
    'lib/tree_sitter_ffi/raw_0_20_7/tree_raw.rb',
    
    'lib/tree_sitter_ffi/types_patch.rb',
    
#     'lib/tree_sitter_ffi/types.rb',
#     'lib/tree_sitter_ffi/node.rb',
#     'lib/tree_sitter_ffi/tree.rb',
#     'lib/tree_sitter_ffi/language.rb',
#     'lib/tree_sitter_ffi/query.rb',
#     'lib/tree_sitter_ffi/parser.rb',

    'lib/tree_sitter_ffi/bind/bind_rust.rb',
  ]
  s.require_paths = ['lib']

  s.add_runtime_dependency "ffi", "~> 1.9"

#   s.add_development_dependency "rake", '~> 12.3'
#   s.add_development_dependency "rake-compiler", '~> 1.0'
#   s.add_development_dependency "rspec", '~> 3.8'
end
