# ruby-tree-sitter-ffi

This gem provides bindings for the tree-sitter runtime library, `libtree-sitter`. You  need to have the `libtree-sitter` library installed in a normal place for your system -- `make` and `make install` in a local copy of the tree-sitter repo is what I did.

You must also have at least one language parser to do anything, so I've made a
separate repo, [ruby-tree-sitter-ffi-lang](https://github.com/calicoday/ruby-tree-sitter-ffi-lang), 
that makes a shared library of a bunch
of language parsers and a gem to make them available in ruby. There are lots of 
interesting possibilities for managing the parsers but this is good enough to be
getting on with.

This gem depends on the ruby `FFI` gem. `FFI` is compiled for your platform when it's
installed, then gems that use it can be installed without further compiling. Some advantages of using `FFI` rather than handcoding C extensions:
- a C compiler (and so root access on some systems) is only necessary for installing the `FFI` gem itself. 
- because we're instructing `FFI` to create the necessary objects and methods, rather than coding them directly, it is convenient to add other processing, such as generating tests or notes.
- `FFI` takes care of much of the type and memory handling necessary at the C-Ruby boundary.
- `FFI` supports a number of Ruby implementations beside (MRI) Ruby, including some non-C ones, like JRuby and TruffleRuby and the client Ruby code works on all without changes.
- for a Ruby implementation that is not supported, such as mruby, `FFI` calls provide a succinct description of what the bindings C extensions are expected to be.

The main (slight) disadvantage is the `FFI` gem gives access to a native library, specifically, not just loose compiled C object code, and you need the path to the installed lib, though the gem will look in conventional places for the platform.

## Install and run demos

- build and install [tree-sitter](https://github.com/tree-sitter/tree-sitter) `libtree-sitter` runtime library
- `$ gem install ffi`
- `$ rake build` (both builds and installs the ruby-tree-sitter-ffi gem)

This is enough to be able display the gem version with:
- `$ ruby -e"require 'tree_sitter_ffi'; puts TreeSitterFFI::VERSION"`

but to do pretty much anything else, you need language parsers:
- build and install [ruby-tree-sitter-ffi-lang](https://github.com/calicoday/ruby-tree-sitter-ffi-lang) `libtree-sitter-lang` library and `tree_sitter_ffi_lang` gem

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

There are a few sample ruby programs in `demo/`
- `example.rb`, ruby translation of the example.c in the tree-sitter docs
- `ts_example.rb`, same but using the lower-level ts_ form module methods
- `node_walk.rb`, walks a JSON syntax tree and prints it out various ways
- `tree_cursor_walk.rb`, same but using TreeCursor for traversing

There are a handful of basic spec files in `spec/` you can run from the project dir with
```
$ rspec
```
There are a bunch of scripts that generate and run other layers of tests. See [Project notes](#Project-notes)

Not recommended for production use yet but it should be playable on most common platforms. If you get stuck -- or you know how to get unstuck for a given environment -- please note it in the issues.


## To Do


- better docs, demos, version handling.
- more functional testing, less trashy test phrasing.
- flesh out ruby convenience layer.
- ponder cross-platform and how to determine whether there might be issues there.
- something to check memory use and review garbage-collected/freestyle mem boundary issues.
- Bundler, Rubocop
- make a better plan for hooking up the language parser/scanners.
- make notes on Ruby FFI knowledge gathered.


## Project notes

This project began as a rough experiment just to investigate tree-sitter for possible future use. The use-cases I had in mind were big projects I wasn't near starting anyway and checking out tree-sitter involved a bunch of tech I hadn't used (or used in recent decades), so I made only the faintest gesture at organization. Tragically, I then had too much success to be able to bring myself to drop the whole thing. Well, I'm fixing it now.

The general project structure is:
- `lib/`, the Ruby bindings code. Using the FFI gem means the project doesn't have C source portions in `cext/` or other directory.
- `src/`, project management scripts and support code
- `gen/`, where the script-generated test code goes, including
  - `rusty/`, the Ruby translations of the tree-sitter cli runtime Rust tests
  - `sigs/`, low-level specs checking the tree-sitter C functions get the right args and return types
- `dev-ref/`, necessary material pulled by script from the tree-sitter repo (# below)
- `log/`, script output logs
- `spec/`, ruby bindings tests beyond the `gen/` stuff
- `demo/`, simple ruby examples corresponding to the sample code in [Using Parsers](https://tree-sitter.github.io/tree-sitter/using-parsers) of the tree-sitter docs
- `xpct/`, copies of the best current tests results for easy diffing
- misc like Rakefile, Gemspec, Readme, etc


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

Probably. I've done this a couple of times but not really challenged it. It IS how [ruby-tree-sitter-ffi-lang](https://github.com/calicoday/ruby-tree-sitter-ffi-lang) does it.


### Gem implementation

Each C data structure is represented in Ruby by a subclass of `TreeSitterFFI::BossPointer` or `TreeSitterFFI::BossStruct` (inheriting `FFI::Pointer` and `FFI::Struct`, respectively). Methods are given to the Boss subclass that corresponds to the tree-sitter function name prefix, eg the method for `ts_node_child` is defined in `TreeSitterFFI::Node`.

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


### DevRunner utility

DevRunner commands a bunch of project scripts produce various kinds of support material. To run, from the project directory:
- `$ ruby src/dev_runner.rb cmd [vers]`

where 
- `vers` is the applicable tree-sitter verion, eg '0.20.7' (or whatever the current default hardcoded in `src/dev_runner.rb` is, if omitted)
- `cmd` is one of:
  - `pull`
    - runs `src/pull/pull_repo_refs.rb` which calls svn to pull the necessary tree-sitter repo reference files from github ([Repo refs pull system](#Repo-refs-pull-system))
  - `sigs_prep`
    - runs `src/sigs/gen_sigs_prep.rb` to generate sigs prep blank files to be copied, filled in and supplied to `gen_sigs` ([Sigs spec system](#Sigs-spec-system))
  - `gen_sigs`
    - runs `src/sigs/gen_sigs.rb` to generate sigs spec files, also sigs patch blank files to be copied and filled in for tricky functions ([Sigs spec system](#Sigs-spec-system))
  - `gen_rusty`
    - runs `src/rusty/gen_rusty.rb` to generate rusty tests files, also rusty patch blank files to be copied and filled in for tricky tests in the Rust test files ([Rusty tests system](#Rusty-tests-system)). 
  - `all_prep`
    - runs `pull` and `sigs_prep`
  - `all_gen`
    - runs `gen_sigs` and `gen_rusty`
  - `run_sigs`
    - calls rspec to run the generated spec and patch sigs files in `gen/[vers]/sigs/` and `src/[vers]/sigs/`, respectively
  - `run_sigs_blanks`
    - (for early dev) calls rspec to run the generated spec and patch blank sigs files in `gen/[vers]/sigs/`
  - `run_rusty`
    - runs the `gen/[vers]/rusty/run_rusty.rb` to run the generated and edited rusty tests
  - `run_rusty_stubs`
    - runs the `gen/[vers]/rusty/run_rusty_stubs.rb` to run the generated and edited rusty tests (for early dev)

In all cases, a log file named for `cmd` and `vers` is created in `log/`. Eg,
- `$ ruby src/dev_runner.rb gen_rusty 0.20.7`
=> `log/gen_rusty_0.20.7_log.txt`

The various utilities themselves were original developed quite separately and differ in style and robustness, though they are gradually getting cleaned up. The DevRunner papers it all over nicely.

Note:
- all generated files are put in the `gen/` subdirectory
- no generated file is to be hand-edited
- generated files meant to be augmented and supplied to subsequent scripts are given the suffix `_blank`. A copy named without `_blank` should be edited and located under `src/`

### Repo refs pull system

The script `src/pull/pull_repo_refs.rb` uses `svn` to download to `gen/pull/` select useful files from the main tree-sitter repo, for several of the most recent versions. It gathers (maintaining the tree-sitter relative paths):
- `lib/include/tree_sitter/`
  - `api.h`, `parser.h`
- `cli/src/tests/`
  - `node_test.rs`, `query_test.rs`, `tree_test.rs`
  
Run with:
- `$ ruby src/dev_runner.rb pull [vers]` ([DevRunner utility](#DevRunner-utility))

The script also uses UNIX `tree` to display pulled directories in the log file. If `tree` is not installed the log will show where `tree` couldn't be found.

The pull system has a test script which downloads to `gen/pull/`, run with:
- `$ ruby src/pull/test_pull_refs.rb 2>&1 | tee log/test_pull_refs_log.txt`


### Sigs specs system

Sigs specs are basic Ruby spec files that check the boundary between Ruby and C. They test only whether a Ruby method passes the expected number and type of arguments and receives the correct type of return value, matching the original C function. It does not matter what the C library does, just how the C functions and data structures are shaped. A small, mechanical bit we can take out of the larger testing equation.

Much of this can be generated automatically but some functions deal in data types that are created somehow other than a simple `new()` or depend on something else already having been set up, so we need to be able to supply test set up information for any more tricky function. This is put in 'sigs prep' files. The process is generate sigs prep, edit prep, generate sigs specs, edit to patch, run specs:

1. Generate sigs prep blanks:
- `$ ruby src/dev_runner.rb gen_sigs_prep [vers]` ([DevRunner utility](#DevRunner-utility))

2. Copy the prep blanks to `src/[vers]/sigs-prep/`, rename them without `_blank` and edit.

3. Generate sigs specs:
- `$ ruby src/dev_runner.rb gen_sigs [vers]` ([DevRunner utility](#DevRunner-utility))

4. Copy the patch blanks to `src/[vers]/sigs/`, rename them without `_blank` and edit.

Run the resulting spec files:
- `$ ruby src/dev_runner.rb run_sigs [vers]` ([DevRunner utility](#DevRunner-utility))

#### When the Tree-sitter api changes:

- Rename the `src/[vers]/sigs_prep/` sigs prep files to prepend `prev_` (in that directory or another)
- Regenerate the sigs prep blanks (step 1, above)
- Copy and rename the new sigs prep blanks (step 2, above) and edit to RECONCILE them with the `prev_` sigs preps
- Similarly, rename `src/[vers]/sigs/` patch files to prepend `prev_` (in that directory or another)
- Renegerate the sigs specs (step 3, above)
- Copy and rename the new patch blanks (step 4, above) and edit to RECONCILE them with the `prev_` patch files

Run the resulting spec files (mind which version):
- `$ ruby src/dev_runner.rb run_sigs [vers]` ([DevRunner utility](#DevRunner-utility))


#### Editing sigs prep files

Sigs prep files supply two methods, `spec(fn_name)` and `before`, to the spec generating script. The former returns a String or nested Array of (mostly) String for a given function test -- this is key: it's not raw code but a String of code, because it's not executed but used in composing what will be a runnable spec test. And the script doesn't currently parse and vet the Strings at all, just slaps them in the appropriate places, so they have to be spelled just right. Yeah, basically an old-timey macro scheme.

The return value is one of these forms:
  - `args_string` 
  - `[args_string, [outer_comment]?, inner_comment?, {nil_ok: false, not_impl: false}]`

where:
- `args_string` is a String to be pasted in as function arguments or nil. If `args_string` is nil, the composed test will be written to the patch_blank, rather than the spec file and a comment with the function name is left in the spec file to mark where the test would have been (so functions don't just disappear without a word)
- `outer_comment` (optional) is an Array holding a String [can it have more than one???] that will be placed just before the test.
- `inner_comment` (optional) is a String [or Strings???] to be placed at the start, inside the test.
- `opts` (optional) is a hash of futher qualifiers:
  - `:nil_ok` - if true, the test won't assert the return value is not nil
  - `:not_impl` - if true, the test will be go to the patch_blank, same as a nil `args_string` but we're declaring we expect it.
  
Newlines and tabs in Strings will just get pasted along with everything else. Mainly useful for breaking long argument lists. If the String is a comment, it needs a comment character after every newline, of course.

The `before()` function returns a String to be pasted into the `before` block of the spec. This is a single String of multiple newline-separated code expressions. The Ruby `%q` notation for preventing string interpolation is best here (and for any other at all complicated code string) because MACRO!

#### Editing patch blank files

The generated patch_blank files have test code similar to the spec files because patch test will need many of the same expressions but the file as generated is not expected to be executed successfully until edited. Ideally, the patch file provides a temporary working space for figuring out what ought to have been in the spec_prep, rather than additional tests in general. 



### Rusty tests system

The script `src/gen/rusty_gen.rb` reads the tree-sitter cli runtime test files `node_tests.rs`, `tree_tests.rs` and `query_test.rs`, runs a canoeful of gsubs on them and produces as much runnable, non-idiomatic ruby equivalents as it can. If the script hits Rustisms it doesn't know what to do with, it comments out that test function and adds a stub function to the patch blank file for filling in later.

For each Rust test file, there is a rusty_prep file providing any necessary processing specific to that file. Also, a `skip_fn(m)` method, which is called with each test function and returns nil or a String giving the reason the test should be commented out and a stub added to the patch blank. Any non-nil return causes the patch but the String can be anything, though if it `include?('internal')`, the test method is commented out but no stub is created (to discard utility rust functions in the test files that aren't themselves tests). The rusty_prep file is NOT generated, just made by hand with stuff salvaged from the previous rusty gen system.

The process is generate rusty tests, edit to patch, run tests:
1. Generate rusty tests:
- `$ ruby src/dev_runner.rb gen_rusty [vers]` ([DevRunner utility](#DevRunner-utility))

2. Copy the patch blanks to `src/[vers]/rusty/`, rename them without `_blank` and edit with replacement tests for those that were too problematic to generate properly

Run the resulting tests files:
- `$ ruby src/dev_runner.rb run_rusty [vers]` ([DevRunner utility](#DevRunner-utility))

During early development, you can run just the easy tests, ignoring to-be-patched functions, with:
- `$ ruby src/dev_runner.rb run_rusty_stubs [vers]` ([DevRunner utility](#DevRunner-utility))


#### When the Tree-sitter api changes:

- Rename `src/[vers]/rusty/` patch files to prepend `prev_` (in that directory or another)
- Renegerate the rusty tests (step 1, above)
- Copy and rename the new patch blanks (step 2, above) and edit to RECONCILE them with the `prev_` patch files

Run the resulting spec files (mind which version):
- `$ ruby src/dev_runner.rb run_rusty [vers]` ([DevRunner utility](#DevRunner-utility))

Or, just easy tests (mind which version):
- `$ ruby src/dev_runner.rb run_rusty_stubs [vers]` ([DevRunner utility](#DevRunner-utility))


