# ruby-tree-sitter-ffi

This is one of those accidental projects. I didn't mean to build it,  I just
wanted to have try at several of the various technical aspects it would
involve. I kept getting stuck but never quite decisively enough for me to
give up. So here we are.

This gem provides bindings for the tree-sitter runtime library, `libtree-sitter`.
You must also have at least one language parser to do anything, so I've made a
separate repo, [ruby-tree-sitter-ffi-lang](https://github.com/calicoday/ruby-tree-sitter-ffi-lang), 
that makes a shared library of a bunch
of language parsers and a gem to make them available in ruby. There are lots of 
interesting possibilities for managing the parsers but this is good enough to be
getting on with.

This gem depends on the ruby FFI gem. FFI is compiled for your platform when it's
installed, then gems that use it can be installed without further compiling. You also 
need to have the `libtree-sitter` library installed in a normal place for your system -- `make` and `make install` in a local copy of the tree-sitter repo is what I did.


## Install and run demos

I'll fix the project to use Bundler ASAP but for now,

- `$ gem install ffi`
- build and install [tree-sitter](https://github.com/tree-sitter/tree-sitter) runtime library
- build and install [ruby-tree-sitter-ffi-lang](https://github.com/calicoday/ruby-tree-sitter-ffi-lang) gem
- `$ rake build` (both builds and installs the ruby-tree-sitter-ffi gem)

To run, in irb or pry:
```ruby
require 'tree_sitter_ffi'
require 'tree_sitter_ffi_lang'
input = '[1, null]'
parser = TreeSitterFFI.parser
parser.set_language(TreeSitterFFI.parser_json)
parser.parse(input).root_node.string
# => (document (array (number) (null)))
```

There are a few sample ruby programs in `./demo`
- `example.rb`, ruby translation of the example.c in the tree-sitter docs
- `ts_example.rb`, same but using the lower-level ts_ form module methods
- `node_walk.rb`, walks a JSON syntax tree and prints it out various ways
- `tree_cursor_walk.rb`, same but using TreeCursor for traversing

There are a handful of basic _spec files in `./spec/` you can run from the project dir with
```
$ rspec
```

In `./gen/rusty/` there are a couple of test files, `rusty_node_test.rb` and `rusty_tree_test.rb`, translated from the tree-sitter cli tests by the script `./src/rusty_gen.rb`. You can run them from the project dir with
```
$ ruby src/run_rusty.rb
```


## To Do

- work the Query, QueryCursor code.
- flesh out ruby convenience layer.
- ponder cross-platform and how to determine whether there might be issues there.
- more functional testing, less trashy test phrasing.
- something to check memory use and review garbage-collected/freestyle mem boundary issues.
- if the generated specs are really only checking arg/return type, maybe don't use seemingly meaningful values?
- doc comments/api documentation, arch notes.
- Bundler, Rubocop
- address the various versioning issues
- make a better plan for hooking up the language parser/scanners.
- more demos.
- better process for updating when the api.h changes.
- make notes on Ruby FFI knowledge gathered.


## Misc project notes

### Wrap language parser in some other built dynamic library

The tree-sitter language parsers each connect to the `libtree-sitter` runtime harness by a single function named `tree_sitter_language`, eg `tree_sitter_json()` for JSON. To use a language parser in some already built dynamic library, `libsomething-has-other-lang`, with function `tree_sitter_other_lang`, add code:

```ruby
require 'ffi'

module TreeSitterFFILang
	module OtherLang
		ffi_lib 'libsomething-has-other-lang' # if installed or 'full-path-to-lib'
		attach_function :tree_sitter_other_lang, [], :pointer
	end
	def self.parser() self.tree_sitter_other_lang end
end
```

and for convenience, you might also:
```ruby
module TreeSitterFFI
	def self.parser_other_lang() TreeSitterFFILang::OtherLang.parser end
end

lang_parser = TreeSitterFFI.parser_other_lang()
# => #<FFI::Pointer address=0x000000010e55a1f0>
```

Probably. I've done this a couple of times but not really challenged it. It IS how `tree_sitter_ffi_lang` does it.


### Process for generating rusty _tests files

The script `./src/rusty_gen.rb` reads the tree-sitter runtime test files `node_tests.rs` and `tree_tests.rs`, runs a canoeful of gsubs on them and produces as much runnable, non-idiomatic ruby equivalents as it can in `./gen/rusty/rusty_node_tests.rb` and `./gen/rusty_tree_tests.rb`. Also a `./gen/rusty/run_rusty.rb` script for running them. My convention is no files under the `./gen` destination directory should have hand editing and runner is designed for commenting/uncommenting the individual tests in development, so you need to copy `./gen/rusty/run_rusty.rb` to `./src/run_rusty.rb`. Then run from the project directory
```
$ ruby src/run_rusty.rb
```


### Process for generating sigs _spec files

When wrap_attached function sigs have been changed (eg tree-sitter api.h gets updated),
the _specs need to be updated to match. This takes regenerating, then adding the
differences to the EDITED copies of the _specs and tweaking them, without losing
the rest of the hand work.

The script src/spec_gen.rb will move an existing gen/sigs directory to gen/sigs-keep,
so if there is already a gen/sigs-keep it must be deleted or moved. Any gen/sigs_diff.rb 
file will be overwritten, so move it if you care (probably not useful, though). Run
```
$ ruby src/spec_gen.rb
```

A fresh gen/sigs dir and _spec files are created and the diff since the prev is 
written to gen/sigs_diff.rb. Any NEW _spec file needs to be copied to spec/sigs. 
Compare the new gen/sigs to spec/sigs and fold in to spec/sigs files any ranges that differed between the corresponding gen/sigs-keep and gen/sigs file. THEN edit to 
make the tests sensible.

