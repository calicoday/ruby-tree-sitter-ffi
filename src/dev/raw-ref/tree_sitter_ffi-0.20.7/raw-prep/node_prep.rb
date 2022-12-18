module TreeSitterFFI
  class NodeSigs
    def api_h_version() '0.20.7' end
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
        @pars = TreeSitterFFI.parser
        json = TreeSitterFFI.parser_json
        @pars.set_language(json).should == true
        @input = "[1, null]"
        @tree = @pars.parse_string(nil, @input, @input.length)
        @root_node = @tree.root_node
        @array_node = @root_node.named_child(0)
        @number_node = @array_node.named_child(0)
      %
    end
  
    def sig_plan
      {
        ts_node_type: '@number_node',
        ts_node_symbol: '@number_node',
        ts_node_start_byte: '@number_node',
        ts_node_start_point: '@number_node',
        ts_node_end_byte: '@number_node',
        ts_node_end_point: '@number_node',
        ts_node_string: ['@number_node',
          '# :strptr is [String, FFI::Pointer]'
          ],
        ts_node_is_null: '@number_node',
        ts_node_is_named: '@number_node',
        ts_node_is_missing: '@number_node',
        ts_node_is_extra: '@number_node',
        ts_node_has_changes: '@number_node',
        ts_node_has_error: '@number_node',
        ts_node_parent: '@number_node',
        ts_node_child: ['@array_node, 3',
          ['# not sure yet whether we can use just any node args, '+
            'so try @array_node here for now']
          ],
        ts_node_field_name_for_child: ['@array_node, 3',
          ['# not sure yet whether we can use just any node args, so try @array_node here for now'],
          {nil_ok: true}
          ],
        ts_node_child_count: '@array_node',
        ts_node_named_child: '@array_node, 0',
        ts_node_named_child_count: '@array_node',
        ts_node_child_by_field_name: ['@number_node, "blurg", 2',
          ['# come back to these two Field map ones:'],
          {nil_ok: true}
          ],
        ts_node_child_by_field_id: ['@number_node, 2',
          {nil_ok: true}
          ],
        ts_node_next_sibling: '@number_node',
        ts_node_prev_sibling: '@number_node',
        ts_node_next_named_sibling: '@number_node',
        ts_node_prev_named_sibling: ['@number_node',
          {nil_ok: true}
          ],
        ts_node_first_child_for_byte: ['@array_node, 5',
          ['# again array_node, nec???'],
          %q%# array_node offset 5 should be at 'u', ie "[1, n^ull]"%
          ],
        ts_node_first_named_child_for_byte: ['@array_node, 1',
          %q%# array_node offset 1 should be at '1', ie "[^1, null]"%
          ],
        ts_node_descendant_for_byte_range: ['@array_node, 2, 3',
          %q%# array_node offset 2 should be at ',', ie "[1^, null]"%
          ],
        ts_node_descendant_for_point_range: '@array_node,
          TreeSitterFFI::Point.new, TreeSitterFFI::Point.new',
        ts_node_named_descendant_for_byte_range: ['@number_node, 5, 7',
          %q%# array_node offset 5 should be at 'u', ie "[1, n^ull]"%
          ],
        ts_node_named_descendant_for_point_range: '@number_node,
          TreeSitterFFI::Point.new, TreeSitterFFI::Point.new',
        ts_node_edit: '@number_node, TreeSitterFFI::InputEdit.new',
        ts_node_eq: '@number_node, TreeSitterFFI::Node.new'
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
