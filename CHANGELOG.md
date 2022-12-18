# Changelog

## [0.0.5] - Unreleased

### Added

- CHANGELOG.md

### Changed

- Raw-level tree-sitter-ffi binding classes and specs are now generated directly from the api.h C header (separate project; repo not up yet).
- Moved `boss.rb`, `unit_memory.rb` and related to a separate module, `BossFFI`.
- Language parser libraries are now added directly and `tree-sitter-ffi-lang` is no longer necessary.
- Ruby raw bindings are now versioned to match the versioned runtime library (as produced by separate project `tree-sitter-repos` because the main Tree-sitter doesn't yet have a clear api versioning scheme).
- Demo scripts have been updated to remove `tree-sitter-ffi-lang` and add the necessary `add_lang()` call.
- Rewrote `dev_runner.rb` to use `Optimist` command-line argument parsing and to address versioned bindings. Removed all pull, raw generating and diff functions.
- Updated `spec_helper.rb` to remove `tree-sitter-ffi-lang`. Added a `SpecObjBuild` class for use by the generated raw specs.
- Upcase README.md to match LICENSE and CHANGELOG.md

### Removed

- Rakefile, in favour of updated `dev_runner.rb`.

