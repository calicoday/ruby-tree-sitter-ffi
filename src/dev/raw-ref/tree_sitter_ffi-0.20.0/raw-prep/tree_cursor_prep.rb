module TreeSitterFFI
  class TreeCursorSigs
    def api_h_version() '0.20.0' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @tree_cursor_1 = @build.obj(TreeSitterFFI::TreeCursor, 1)
        @node_1 = @build.obj(TreeSitterFFI::Node, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @point_1 = @build.obj(TreeSitterFFI::Point, 1)
      %
    end
  
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
  
    def sig_plan
      {
        ### TreeCursors,
        ts_tree_cursor_reset: ['@tree_cursor, @root_node',
          '# reset to the same root_node'
          ],
        ts_tree_cursor_current_node: '@tree_cursor',
        ts_tree_cursor_current_field_name: ['@tree_cursor',
          {nil_ok: true}
          ],
        ts_tree_cursor_current_field_id: '@tree_cursor',
        ts_tree_cursor_goto_parent: '@tree_cursor',
        ts_tree_cursor_goto_next_sibling: '@tree_cursor',
        ts_tree_cursor_goto_first_child: '@tree_cursor',
        ts_tree_cursor_goto_first_child_for_byte: '@tree_cursor, 5',
        ts_tree_cursor_goto_first_child_for_point: '@tree_cursor, TreeSitterFFI::Point.new',
        ts_tree_cursor_copy: '@tree_cursor'
      }
    end
  
    def sig_plan_blank
      {
        ts_tree_cursor_reset: nil,
        ts_tree_cursor_current_node: nil,
        ts_tree_cursor_current_field_name: nil,
        ts_tree_cursor_current_field_id: nil,
        ts_tree_cursor_goto_parent: nil,
        ts_tree_cursor_goto_next_sibling: nil,
        ts_tree_cursor_goto_first_child: nil,
        ts_tree_cursor_goto_first_child_for_byte: nil,
        ts_tree_cursor_goto_first_child_for_point: nil,
        ts_tree_cursor_copy: nil,
      }
    end
  end
end
