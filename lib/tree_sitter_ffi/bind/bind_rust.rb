module BindRust
#   include BindRustyHelpers

	### patch get_language to add_lang!!! put this somewhere better!!! FIXME!!!
	# alias_method :aka, :nee
### TMP!!! mk version_roster.json!!! FIXME!!!
	def get_language(lang)
	  lang = "tree_sitter_#{lang}" unless lang.to_s =~ /^tree_sitter_/
	  lang = lang.to_sym # be sure
	  lib = TreeSitterFFI.find_lang_lib(lang)
    puts "=== lang: #{lang.inspect}+++"
	  TreeSitterFFI.add_lang(lang, lib)
    lang_obj = TreeSitterFFI.send(lang)
#     puts "  lib_vers: #{lib_vers}+++"
#     puts "  lib: #{lib.inspect}+++"
    ###TreeSitterFFI.add_lang("tree_sitter_#{lang}".to_sym, lib)
    ###lang_obj = TreeSitterFFI.send("tree_sitter_#{lang}")
  end
  
	def was_get_language(lang)
	  vers_roster = {
      bash: '0.19.0',
      c_sharp: '0.20.0',
      c: '0.20.2',
      cpp: '0.20.0',
      embedded_template: '0.20.0',
      html: '0.19.0',
      javascript: '0.20.0',
      json: '0.19.0',
      make: 'untagged..',
      markdown: '0.7.1',
      python: '0.20.0',
      ruby: '0.19.0',
      rust: '0.20.3',	  
    }
    puts "=== lang: #{lang.inspect}+++"
    lib_vers = vers_roster[lang.to_sym]
    lib = "/usr/local/lib/tree-sitter-#{lang}/libtree-sitter-#{lang}.#{lib_vers}.dylib"
    puts "  lib_vers: #{lib_vers}+++"
    puts "  lib: #{lib.inspect}+++"
    TreeSitterFFI.add_lang("tree_sitter_#{lang}".to_sym, lib)
    lang_obj = TreeSitterFFI.send("tree_sitter_#{lang}")
  end
  
	class TreeSitterFFI::InputEdit
	  # why class method???
    def self.from_hash(h)
  # 		puts "TreeSitterFFI::InputEdit.from_hash..."
  # 		ap h
      self.new.tap do |o|
        o[:start_byte] = h[:start_byte]
        o[:old_end_byte] = h[:old_end_byte]
        o[:new_end_byte] = h[:new_end_byte]
        o[:start_point] = h[:start_position] # tree_test says start_position but shdv chgd
        o[:old_end_point] = h[:old_end_position]
        o[:new_end_point] = h[:new_end_position]
  #       o[:start_point] = h[:start_point] # tree_test says start_position but shdv chgd
  #       o[:old_end_point] = h[:old_end_point]
  #       o[:new_end_point] = h[:new_end_point]
      end
    end
	end

	class TreeSitterFFI::Node
		def type_id() symbol() end
		def walk() TreeSitterFFI.ts_tree_cursor_new(self) end
		def child_by_field_name(name)
		  TreeSitterFFI.ts_node_child_by_field_name(self, name, name.length)
		end
		def byte_range()
		  (TreeSitterFFI.ts_node_start_byte(self)..TreeSitterFFI.ts_node_end_byte(self))
		end
    alias_method :to_sexp, :string
	end
	
	class TreeSitterFFI::Parser
	  # shd alias!!! FIXME!!! What is the rust bindings something arg???
	  def parse(input, something=nil)
      parse_string(nil, input, input.length)
    end
	end

	class TreeSitterFFI::Tree
		def walk() TreeSitterFFI.ts_tree_cursor_new(self.root_node) end
	end
	
	class TreeSitterFFI::TreeCursor
		def node() TreeSitterFFI.ts_tree_cursor_current_node(self) end
		def field_name() TreeSitterFFI.ts_tree_cursor_current_field_name(self) end
	end
	
	class TreeSitterFFI::QueryCursor
		def set_byte_range(range)
			raise "QueryCursor#set_byte_range expected Range (#{range.inspect})" unless 
				range.is_a?(::Range)
			first = range.begin
			last = range.max.to_i
			TreeSitterFFI.ts_query_cursor_set_byte_range(self, first, last)
			self
		end

    #### monkeypatching TreeSitterFFI classes while I restabilize the tests before
    # remaking the gem...

    # from wb/engine_rb.rb ParseRunner -- for ref!!!

      # will be QueryCursor#captures(match) => index or nil
    #   def cursor_captures()
      def cursor_captures(cursor)
        arr = []
        match = TreeSitterFFI::QueryMatch.new
        ###TMP!!! amend TreeSitterFFI!!!
    #     while(idx=cursor.next_capture(match))
        while(idx=next_capture(match, cursor))
          arr << match.captures[idx] #make_copy issue!!!
          # wait up, doesn't [] already create copy??? try it...
        end
        arr    
      end
      # ruby wrap for next_match, next_capture shd return obj/index or nil instead of bool!!!
    #   def next_match(match) #conv override
    #     ret = ts_query_cursor_next_match(self, match)
      def will_next_match(match, cursor) #conv override
        ret = ts_query_cursor_next_match(cursor, match)
        # ret is true or false, return match or nil
        ret ? match : nil
      end
    #   def next_capture() #conv override
    #     len_p = FFI::MemoryPointer.new(:uint32, 1)
    #     ret = ts_parser_included_ranges(self, len_p)
      def next_capture(match, cursor) #conv override
        len_p = FFI::MemoryPointer.new(:uint32, 1)
        ret = TreeSitterFFI.ts_query_cursor_next_capture(cursor, match, len_p) # weird monkey!!!
#         ret = cursor.ts_query_cursor_next_capture(cursor, match, len_p) # weird monkey!!!
    #     ret = ts_query_cursor_next_capture(cursor, match, len_p)
        # ret is true or false, return index or nil
        len = len_p.get(:uint32, 0)
        ret ? len : nil
      end
    ####
		
		# QueryCursor already has #matches but it shdnt, shd be here in BindRusty
		# OR we shd backport some of the essential helpers to C!!!
    def captures(query, node, input)
		  self.exec(query, node)
		  arr = []
      match = TreeSitterFFI::QueryMatch.new
		  while(idx=next_capture(match, self)) # not cursor.next_capture bc return int!!! FIXME!!!
		    arr << match.captures[idx] #make_copy issue!!!
          # wait up, doesn't [] already create copy??? try it...
		  end
		  arr
    end
    # in gem:
# 		def matches(query, node, input)
# 		  self.exec(query, node)
# 		  arr = []
#       match = QueryMatch.new
# 		  while(next_match(match))
# 		    arr << match.make_copy #only single
# 		  end
# 		  arr
#     end
		
	end


# /**
#  * Create a new query from a string containing one or more S-expression
#  * patterns. The query is associated with a particular language, and can
#  * only be run on syntax nodes parsed with that language.
#  *
#  * If all of the given patterns are valid, this returns a `TSQuery`.
#  * If a pattern is invalid, this returns `NULL`, and provides two pieces
#  * of information about the problem:
#  * 1. The byte offset of the error is written to the `error_offset` parameter.
#  * 2. The type of error is written to the `error_type` parameter.
#  */
# TSQuery *ts_query_new(
#   const TSLanguage *language,
#   const char *source,
#   uint32_t source_len,
#   uint32_t *error_offset,
#   TSQueryError *error_type
# );

	class TreeSitterFFI::Query
		def is_ok() true end
	  ### chimp now in gem
# 		def self.make(lang, str)
# 		  puts "=== Query.make run_rusty_helper.rb"
# 			offset_p = FFI::MemoryPointer.new(:pointer, 1) # :uint32_p is Pointer
# 			errtype_p = FFI::MemoryPointer.new(:pointer, 1) # TSQueryError is enum
# 			ret = TreeSitterFFI.ts_query_new(lang, str, str.length, offset_p, errtype_p)
# 			return ret unless ret.nil?
# 			# raise/return error stuff
# 			offset = offset_p.get(:uint32, 0)
# 			# start with this
# 			raise "TreeSitterFFI::Query.make failed, offset: #{offset}"
# # 			errtype = errtype_p.get(QueryError.ptr, 0)
# 		end
	end
# ###QueryError {
# 	class TreeSitterFFI::QueryError
# 		def self.make(h)
# 			
# 		end
# 	end

# /// An error that occurred when trying to create a `Query`.
# #[derive(Debug, PartialEq, Eq)]
# pub struct QueryError {
#     pub row: usize,
#     pub column: usize,
#     pub offset: usize,
#     pub message: String,
#     pub kind: QueryErrorKind,
# }
# 
# #[derive(Debug, PartialEq, Eq)]
# pub enum QueryErrorKind {
#     Syntax,
#     NodeType,
#     Field,
#     Capture,
#     Predicate,
#     Structure,
# }
end