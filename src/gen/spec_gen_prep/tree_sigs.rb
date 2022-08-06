# generated by src/gen/gen_sigs_blank.rb, to be COPIED and filled in.

class TreeSigs
  def before
    %q%
    @pars = TreeSitterFFI.parser
		json = TreeSitterFFI.parser_json
		@pars.set_language(json).should == true
		@input = "[1, null]"
		@tree = @pars.parse_string(nil, @input, @input.length)
		@root_node = @tree.root_node
# 		@array_node = @root_node.named_child(0)
		@tree_cursor = TreeSitterFFI.ts_tree_cursor_new(@root_node) #crashes!!! FIXME!!!
    %
  end
  
  def sig(fn_name)
    case fn_name
    when :ts_tree_copy then '@tree'
		when :ts_tree_root_node then '@tree'
		when :ts_tree_language then '@tree'
		when :ts_tree_edit then ['@tree, TreeSitterFFI::InputEdit.new',
		  ['# need to try this with more useful InputEdit values']
		  ]
		when :ts_tree_get_changed_ranges then [nil,
		  '# compare @tree to itself'
		  ]
		when :ts_tree_print_dot_graph then [nil,
		  ['# come back to FILE pointer']
		  ]
		  
		### TreeCursors
		
		when :ts_tree_cursor_reset then ['@tree_cursor, @root_node',
		  '# reset to the same root_node'
		  ]
		when :ts_tree_cursor_current_node then '@tree_cursor'
		when :ts_tree_cursor_current_field_name then ['@tree_cursor',
		  {nil_ok: true}
		  ]
		when :ts_tree_cursor_current_field_id then '@tree_cursor'
		when :ts_tree_cursor_goto_parent then '@tree_cursor'
		when :ts_tree_cursor_goto_next_sibling then '@tree_cursor'
		when :ts_tree_cursor_goto_first_child then '@tree_cursor'
		when :ts_tree_cursor_goto_first_child_for_byte then '@tree_cursor, 5'
		when :ts_tree_cursor_goto_first_child_for_point then '@tree_cursor, TreeSitterFFI::Point.new'
		when :ts_tree_cursor_copy then '@tree_cursor'
    else
      nil
    end
  end
end
