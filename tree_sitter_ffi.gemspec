# coding: utf-8
# frozen_string_literal: true

require File.expand_path('lib/tree_sitter_ffi/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'tree_sitter_ffi'
  s.version = TreeSitterFFI::VERSION
  s.date = '2021-05-26'
  s.summary = 'Ruby ffi bindings for tree-sitter'
  s.authors = ['Calicoday']
  s.email = 'calicoday@gmail.com'
  s.licenses = ['MIT']
  s.homepage = 'https://www.github.com/calicoday/ruby-tree-sitter-ffi'

#   s.extensions = ['ext/simple_clipboard/extconf.rb']
  s.files = [
    'lib/tree_sitter_ffi.rb',
    'lib/tree_sitter_ffi/unit_memory.rb',
    'lib/tree_sitter_ffi/boss.rb',
    'lib/tree_sitter_ffi/types.rb',
    'lib/tree_sitter_ffi/node.rb',
    'lib/tree_sitter_ffi/tree.rb',
    'lib/tree_sitter_ffi/language.rb',
    'lib/tree_sitter_ffi/query.rb',
    'lib/tree_sitter_ffi/parser.rb',
    'lib/tree_sitter_ffi/tree_sitter_ffi.rb',
    'lib/tree_sitter_ffi/version.rb'
  ]
  s.require_paths = ['lib']

  s.add_runtime_dependency "ffi", "~> 1.9"

#   s.add_development_dependency "rake", '~> 12.3'
#   s.add_development_dependency "rake-compiler", '~> 1.0'
#   s.add_development_dependency "rspec", '~> 3.8'
end
