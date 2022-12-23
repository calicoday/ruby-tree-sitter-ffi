# ruby-tree-sitter-ffi

This gem provides Ruby bindings for the tree-sitter runtime library, `libtree-sitter`. You  need to have the runtime library and a language parser for each language you want to use, in shared/dynamic library form, and know the full paths to them on your system (absolute path or relative to the directory you run from). I'll use the current paths on my Mac in the examples below. You may find my [tree-sitter-repos](https://github.com/calicoday/tree-sitter-repos) project convenient for cloning and building the necessary Tree-sitter libraries.

This gem depends on the ruby `FFI` gem. `FFI` is compiled for your platform when it's
installed, then gems that use it can be installed without further compiling. Some advantages of using `FFI` rather than handcoding C extensions:
- a C compiler (and so root access on some systems) is only necessary for installing the `FFI` gem itself. 
- because we're instructing `FFI` to create the necessary objects and methods, rather than coding them directly, it is convenient to add other processing, such as generating tests or notes.
- `FFI` takes care of much of the type and memory handling necessary at the Ruby-C boundary.
- `FFI` supports a number of Ruby implementations beside (MRI) CRuby, including some non-C ones, like JRuby and TruffleRuby and the client Ruby code works on all without changes.
- for a Ruby implementation that is not supported, such as mruby, `FFI` calls provide a succinct description of what the bindings C extensions are expected to be.

The main (slight) disadvantage is the `FFI` gem gives access to a native library, specifically, not just loose compiled C object code, and you need the path to the installed lib.

## Install and run demos

Install the `FFI` gem, if necessary:
```
gem install ffi
```
(or possibly `sudo gem install ffi`, if the destination directories are access-protected, for instance).

Build and install `tree_sitter_ffi`:
```
gem build tree_sitter_ffi.gemspec
```
(or run with an added ruby -I include option to the lib/ directory).

For the moment, the path to the Tree-sitter runtime library (including extension) must be passed at startup via the environment variable TREE_SITTER_RUNTIME_LIB. This is enough to be able display the `tree_sitter_ffi` gem version:
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' ruby -e"require 'tree_sitter_ffi'; puts TreeSitterFFI::VERSION"`
=> 0.0.5
```


To do pretty much anything else, you need to load the desired language libraries before use by calling `TreeSitterFFI.add_lang` with a path to the library (including extension). Subsequent calls for the same language do nothing. There is no way to unload a language, currently.

To run in pry (or irb), invoke with:
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' pry
```
Then:
```ruby
[1] pry(main)> require 'tree_sitter_ffi'
+++ /Users/cal/dev/tang22/ta-tree-sitter-ffi/ruby-tree-sitter-ffi/lib
=> true
[2] pry(main)> input = '[1, null]'
=> "[1, null]"
[3] pry(main)> parser = TreeSitterFFI.parser
=> #<TreeSitterFFI::Parser address=0x0000000158887400>
[4] pry(main)> TreeSitterFFI.add_lang(:tree_sitter_json,
  '/usr/local/lib/tree-sitter-json/libtree-sitter-json.0.19.0.dylib')    
=> #<FFI::Function address=0x0000000102d76a38>
[5] pry(main)> parser.set_language(TreeSitterFFI.tree_sitter_json)
=> true
[6] pry(main)> parser.parse(input).root_node.string
=> "(document (array (number) (null)))"
```

There are a few sample ruby programs in `demo/` (you must edit the library paths to match your environment):
- `example.rb`, ruby translation of the example.c in the tree-sitter docs
- `ts_example.rb`, same but using the lower-level ts_ form module methods
- `node_walk.rb`, walks a JSON syntax tree and prints it out various ways
- `tree_cursor_walk.rb`, same but using TreeCursor for traversing

Run `example.rb` with:
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' ruby demo/example.rb
```

There are a handful of basic spec files in `spec/` you can run (after editing the language library paths in `spec/spec_util.rb`) from the project directory with:
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' rspec
```

which runs all `*_spec.rb` files, including `*_patch_spec.rb` files which are marked to fail until edited appropriately. To run only the `*_spec.rb` files expected to pass, use:
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' rspec spec/*_spec.rb spec/raw-spec.0.20.7 spec/rusty.0.20.7
```


There are a bunch of scripts that generate and run other layers of tests. See [Project notes](#Project-notes)


## State of play

Not recommended for production use yet but it should be playable on most common platforms. If you get stuck -- or you know how to get unstuck for a given environment -- please note it in the issues.

This most recent update involved a huge overhaul of the project structure to handle addressing different versions of the Tree-sitter runtime. The runtime API doesn't change all that often but I wanted to get a process in place for readily updating bindings when necessary. The present scheme works, though using it is more awkward than it will be. In particular, the runtime library to be loaded must be passed in an ENV variable because the current class design needs it for set up not just when it's used but when the class files are first read. I'll fix that.

You should probably not expect the Ruby bindings for any version but 0.20.7 to work properly for you (bits and bobs in this repo for other versions are necessary for developing the version handling). Also, Tree-sitter 0.20.7 sets a minimum language version of 13 and some of the languages out there are at 12, so they won't be compatible (you might raise an issue in that language's repo). 


## To do


- api-cheatsheet
- better version handling.
- better docs, demos, especially easy, intro-to-tree-sitter stuff people can play with.
- more functional testing, less trashy test phrasing.
- flesh out ruby convenience layer.
- ponder cross-platform and how to determine whether there might be issues there.
- better checks of memory use and garbage-collected/freestyle mem boundary issues.
- Bundler, Rubocop


## Project Notes

The general project structure is:
- `lib/`, the Ruby bindings code. Using the FFI gem means the project doesn't have C source portions in `cext/` or other directory.
- `src/`, project management scripts and support code
- `gen/`, where the script-generated test code goes, eg
  - `rusty.0.20.7/`, the Ruby translations of the tree-sitter cli runtime Rust tests
- `log/`, script output logs
- `spec/`, ruby bindings tests
- `demo/`, simple ruby examples corresponding to the sample code in [Using Parsers](https://tree-sitter.github.io/tree-sitter/using-parsers) of the tree-sitter docs



### Gem implementation

Each C data structure is represented in Ruby by a subclass of `TreeSitterFFI::BossPointer`, `TreeSitterFFI::BossStruct` or `TreeSitterFFI::BossMixedStruct` (inheriting `FFI::Pointer`, `FFI::Struct` and `FFI::ManagedStruct`, respectively). Methods are given to the Boss subclass that corresponds to the prefix of the tree-sitter function name, eg the method for `ts_node_child` is defined in `TreeSitterFFI::Node`.

A method corresponding each C function is created in two forms, exactly like the C function and permuted for object-oriented. Thus, for example, to get the third child of a node in C:
- `TSNode child_node = ts_node_child(parent_node, 3);`

is in Ruby:
- `child_node = TreeSitterFFI::Node.ts_node_child(node, 3)`
- `child_node = node.child(3)`

The Ruby api is implemented in layers:
- 'raw', absolutely minimal changes to the C api to be valid in Ruby
- 'tidy', any raw methods that pass pointers are wrapped to hide the mess
- 'idio', idiomatic ruby, TBD
- 'bind_rust', matching the rust binding methods used by the tree-sitter cli tests

The raw-level Ruby classes and basic specs are now generated directly from the Tree-sitter C header file, `api.h` (separate project; repo not up yet). 


### DevRunner utility

DevRunner commands a bunch of project scripts produce various kinds of support material.
```ruby
Runner of tree-sitter-ffi scripts
Usage:
  dev_runner.rb [options] [<command> [suboptions]]
 
Options:
  -v, --version          
  -h, --help             
  -t, --tag=<s>          Tree-sitter version tag (/\d+\.\d+\.\d+/ no 'v' or
                         other)
  -r, --repo=<s>         Tree-sitter repo (for rust tests source)
  -g, --gem              Use source from gems
  -l, --lib, --no-lib    Use source from local lib/ not gems (default: true)

Commands:
  demo                 run demo/example.rb
  gen_rusty            generate gen/ rusty tests
  cp_rusty             copy rusty_*_test.rb and *_patch_blank.rb to spec/rusty
  rspec_raw            run rspec on gen/raw-spec.vers/ *_raw_spec.rb
  rspec_raw_patch      run rspec on spec/raw-patch.vers/ *_raw_patch_spec.rb
  test_rusty           run spec/rusty tests
  test_rusty_patch     run spec/rusty patch tests
  run_rusty_stubs      run gen/rusty test stubs
  run_rusty_tiny       run gen/rusty tiny test
```

Commands `gen_rusty`, `test_rusty` and `rspec_raw` create a log file in `log/`, named for the command and api version, eg `log/gen_rusty.0.20.7_log.txt`.

At the moment, DevRunner --tag option gets resolved to hardcoded paths on my machine to the appropriate runtime. Yeah, that's not great.

### Rusty tests system

The script `src/gen/rusty_gen.rb` reads the tree-sitter cli runtime test files `node_tests.rs`, `tree_tests.rs` and `query_test.rs`, runs a canoeful of gsubs on them and produces as much runnable, non-idiomatic ruby equivalents as it can. If the script hits Rustisms it doesn't know what to do with, it comments out that test function and adds a stub function to the patch blank file for filling in later.

For each Rust test file, there is a rusty_prep file providing any necessary processing specific to that file. Also, a `skip_fn(m)` method, which is called with each test function and returns nil or a String giving the reason the test should be commented out and a stub added to the patch blank. Any non-nil return causes the patch but the String can be anything, though if it `include?('internal')`, the test method is commented out but no stub is created (to discard utility rust functions in the test files that aren't themselves tests). The rusty_prep file is NOT generated, just made by hand with stuff salvaged from the previous rusty gen system.

The DevRunner command `cp_rusty` copies the generated rusty tests to `spec/rusty` and the patch stubs to `spec/rusty-patch-fresh`, renaming each file to remove '_blank'. The `spec/rusty-patch-fresh` should be renamed `spec/rusty-patch` and the files edited as appropriate.


## Skeleton runthrough

### User form (0.20.7 classes only)

#### Demos

For each of `example.rb`, `ts_example.rb`, `node_walk.rb`, `tree_cursor_walk.rb`

lib: 
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' ruby -I lib/ demo/example.rb
```

[hide `lib/` as `lib-hide/` to ensure gem]
gem: 
```
TREE_SITTER_RUNTIME_LIB='/usr/local/lib/tree-sitter/libtree-sitter.0.20.7.dylib' ruby demo/example.rb
```

=> expect: demo output


### dev form (with --tag option to hardcoded paths)

#### Raw series

lib: 
```
ruby src/dev_runner.rb -t '0.20.7' -l rspec_raw
```

[hide `lib/` as `lib-hide/` to ensure gem]
gem: 
```
ruby src/dev_runner.rb -t '0.20.7' -g rspec_raw
```

=> expect: all ok

[rename `spec/raw-patch-fresh.0.20.7` as `raw-patch.0.20.7`]
lib: 
```
ruby src/dev_runner.rb -t '0.20.7' -l rspec_raw_patch
```

[rename `spec/raw-patch-fresh.0.20.7` as `raw-patch.0.20.7`]
[hide `lib/` as `lib-hide/` to ensure gem]
gem: 
```
ruby src/dev_runner.rb -t '0.20.7' -g rspec_raw_patch
```
=> expect: all fail :FIXME 


#### Rusty series

[`log/` must exist]
[hide `gen/rusty.0.20.7` as `gen/rusty.0.20.7-hide`]
lib: 
```
ruby src/dev_runner.rb -t '0.20.7' -l -r '../../ta-tree-sitter-repos/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' gen_rusty
```
[`log/` must exist]
[hide `gen/rusty.0.20.7` as `gen/rusty.0.20.7-hide`]
[hide `lib/` as `lib-hide/` to ensure gem]
gem: 
```
ruby src/dev_runner.rb -t '0.20.7' -g -r '../../ta-tree-sitter-repos/tree-sitter-repos/repos/tree-sitter.0.20.7/tree-sitter' gen_rusty [hide gen/rusty.0.20.7 as gen/rusty.0.20.7-hide]
```

=> expect: create `gen/rusty.0.20.7/` `run_rusty.rb`, `rusty_*_test.rb`, `rusty_*_patch_blank.rb`


lib: 
```
ruby src/dev_runner.rb -t '0.20.7' -l cp_rusty
```

gem: 
```
ruby src/dev_runner.rb -t '0.20.7' -g cp_rusty
```

=> expect: create `spec/rusty.0.20.7`/ `run_rusty.rb`, `rusty_*_test.rb`
  create `spec/rusty-patch-fresh.0.20.7/` `rusty_*_patch.rb`
  
[rename `spec/rusty-patch-fresh.0.20.7` to `rusty-patch.0.20.7`]
lib: 
```
ruby src/dev_runner.rb -t '0.20.7' -l test_rusty
```

[rename `spec/rusty-patch-fresh.0.20.7` to `rusty-patch.0.20.7`]
[hide `lib/` as `lib-hide/` to ensure gem]
gem: 
```
ruby src/dev_runner.rb -t '0.20.7' -g test_rusty
```
  
=> expect: all ok

[not_impl: `test_rusty_patch`, missing `run_rusty_patch.rb` or other]
