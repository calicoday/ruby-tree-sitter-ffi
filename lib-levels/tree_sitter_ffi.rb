# coding: utf-8
# frozen_string_literal: false

puts "+++ #{File.expand_path(File.dirname(__FILE__))}" # TMP!!! so we can see gem vs lib/

require 'tree_sitter_ffi/version'

require 'tree_sitter_ffi/unit_memory'
require 'tree_sitter_ffi/boss'

require 'tree_sitter_ffi/raw'

require 'tree_sitter_ffi/types'
require 'tree_sitter_ffi/node'
require 'tree_sitter_ffi/tree'
require 'tree_sitter_ffi/language'
require 'tree_sitter_ffi/query'
require 'tree_sitter_ffi/parser'
require 'tree_sitter_ffi/tree_sitter_ffi'
