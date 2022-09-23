# coding: utf-8
# frozen_string_literal: false

require 'tree_sitter_ffi/boss'
require 'tree_sitter_ffi/raw/query_raw'

module TreeSitterFFI

### both Query and QueryCursor here for now!!! Also QueryCapture, QueryMatch

	class Query < BossPointer
	end

	class QueryCapture < BossStruct
	  ### by hand for now!!!
	  def inspect()
	    ### from four11
	    return 'nil obj' if self.null?
	    node = (self[:node] && !self[:node].is_null ?
	      self[:node].string.inspect : self[:node].inspect)
      "<#{self.class.name.split(':').last}" + 
        " node: #{node}>"
	  end
	end

	class QueryMatch < BossMixedStruct
		def inspect() 
		  four11(self, [:id, :pattern_index, :capture_count], 
		    {captures: captures}) 
		end
  end
  
	class QueryCursor < BossPointer
    ### Rusty!!!
		# TextProvider??? try String input first...
		def matches(query, node, input)
		  self.exec(query, node)
		  arr = []
      match = QueryMatch.new
		  while(next_match(match))
		    arr << match.make_copy #only single
		  end
		  arr
    end
	
    ### Rusty!!!
		# TextProvider??? try String input first...
		def was_matches(query, node, input)
# 		  puts "*** matches all "
		  self.exec(query, node)
		  arr = []
      match = QueryMatch.new
#       arr << match.make_copy while(next_match(match))
		  while(next_match(match))
#         puts "  @@@ next_match"
#         puts "      match: #{match.inspect}"
		    cp = match.make_copy()
# 		    puts "  ***    cp: #{cp.inspect}"
		    arr << cp
# 		    arr << match.make_copy()
        match = QueryMatch.new
      end
#       puts "arr: #{arr.inspect}"
#       puts "*** done matches"
		  arr
		end
		
		### lib.rs QueryCursor
#     /// Iterate over all of the matches in the order that they were found.
#     ///
#     /// Each match contains the index of the pattern that matched, and a list of captures.
#     /// Because multiple patterns can match the same set of nodes, one match may contain
#     /// captures that appear *before* some of the captures from a previous match.
#     pub fn matches<'a, 'tree: 'a, T: TextProvider<'a> + 'a>(
#         &'a mut self,
#         query: &'a Query,
#         node: Node<'tree>,
#         text_provider: T,
#     ) -> QueryMatches<'a, 'tree, T> {
#         let ptr = self.ptr.as_ptr();
#         unsafe { ffi::ts_query_cursor_exec(ptr, query.ptr.as_ptr(), node.0) };
#         QueryMatches {
#             ptr,
#             query,
#             text_provider,
#             buffer1: Default::default(),
#             buffer2: Default::default(),
#             _tree: PhantomData,
#         }
#     }
# 
  end
end

