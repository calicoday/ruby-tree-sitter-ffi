module TreeSitterFFI
  class TreeSigs
    def api_h_version() '0.20.6' end
    def types_that_happen_ref
      %q%
        @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
        @tree_2 = @build.obj(TreeSitterFFI::Tree, 2)
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
    # 		@array_node = @root_node.named_child(0)
      %
    end
  
    def sig_plan
      {
        ts_tree_copy: '@tree',
        ts_tree_root_node: '@tree',
        ts_tree_language: '@tree',
        ts_tree_edit: ['@tree, TreeSitterFFI::InputEdit.new',
          ['# need to try this with more useful InputEdit values']
          ],
        ts_tree_get_changed_ranges: [nil,
          '# compare @tree to itself'
          ],
        ts_tree_print_dot_graph: [nil,
          ['# come back to FILE pointer']
          ]
      
      }
    end
    
    def sig_plan_blank
      {
        ts_tree_copy: nil,
        ts_tree_root_node: nil,
        ts_tree_language: nil,
        ts_tree_edit: nil,
        ts_tree_get_changed_ranges: nil,
        ts_tree_print_dot_graph: nil,
      }
    end

  end
end
