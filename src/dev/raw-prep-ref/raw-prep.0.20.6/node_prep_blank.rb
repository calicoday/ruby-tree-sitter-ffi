module TreeSitterFFI
  class NodeSigs
    def api_h_version() '0.20.6' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @node_1 = @build.obj(TreeSitterFFI::Node, 1)
        @node_2 = @build.obj(TreeSitterFFI::Node, 2)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @uint32_t_2 = @build.obj(:uint32_t, 2)
        @string_1 = @build.obj(:string, 1)
        @field_id_1 = @build.obj(:field_id, 1)
        @point_1 = @build.obj(TreeSitterFFI::Point, 1)
        @point_2 = @build.obj(TreeSitterFFI::Point, 2)
        @input_edit_1 = @build.obj(TreeSitterFFI::InputEdit, 1)
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
        ts_node_type: nil,
        ts_node_symbol: nil,
        ts_node_start_byte: nil,
        ts_node_start_point: nil,
        ts_node_end_byte: nil,
        ts_node_end_point: nil,
        ts_node_string: nil,
        ts_node_is_null: nil,
        ts_node_is_named: nil,
        ts_node_is_missing: nil,
        ts_node_is_extra: nil,
        ts_node_has_changes: nil,
        ts_node_has_error: nil,
        ts_node_parent: nil,
        ts_node_child: nil,
        ts_node_field_name_for_child: nil,
        ts_node_child_count: nil,
        ts_node_named_child: nil,
        ts_node_named_child_count: nil,
        ts_node_child_by_field_name: nil,
        ts_node_child_by_field_id: nil,
        ts_node_next_sibling: nil,
        ts_node_prev_sibling: nil,
        ts_node_next_named_sibling: nil,
        ts_node_prev_named_sibling: nil,
        ts_node_first_child_for_byte: nil,
        ts_node_first_named_child_for_byte: nil,
        ts_node_descendant_for_byte_range: nil,
        ts_node_descendant_for_point_range: nil,
        ts_node_named_descendant_for_byte_range: nil,
        ts_node_named_descendant_for_point_range: nil,
        ts_node_edit: nil,
        ts_node_eq: nil,
      }
    end
  end
end
