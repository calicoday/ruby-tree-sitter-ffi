# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/parser'
require 'tree_sitter_ffi/language'


module TreeSitterFFI

# 	def self.parser_json() TreeSitterFFI.parser_json end
	def self.parser_json() TreeSitterFFILang::JSON.parser end

# json ruby bash c embedded-template html java javascript make markdown rust
	def self.parser_ruby() TreeSitterFFILang::Ruby.parser end
	def self.parser_bash() TreeSitterFFILang::Bash.parser end
	def self.parser_c() TreeSitterFFILang::C.parser end
	def self.parser_embedded_template() TreeSitterFFILang::EmbeddedTemplate.parser end
	def self.parser_html() TreeSitterFFILang::HTML.parser end
	def self.parser_java() TreeSitterFFILang::Java.parser end
	def self.parser_make() TreeSitterFFILang::Make.parser end
	def self.parser_markdown() TreeSitterFFILang::Markdown.parser end
	def self.parser_python() TreeSitterFFILang::Python.parser end
	def self.parser_not_a_lang() TreeSitterFFILang::NotALang.parser end

	def self.parser_rust() TreeSitterFFILang::Rust.parser end
	def self.parser_javascript() TreeSitterFFILang::JavaScript.parser end
	
	def self.parser() TreeSitterFFI.ts_parser_new end
	def self.tree_cursor(node) TreeSitterFFI.ts_tree_cursor_new(node) end

end
