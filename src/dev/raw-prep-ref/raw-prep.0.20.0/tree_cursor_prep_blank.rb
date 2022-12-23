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
      %
    end
  
    def sig_plan
      {
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
