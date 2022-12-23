module TreeSitterFFI
  class TreeSigs
    def api_h_version() '0.20.0' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @tree_1 = @build.obj(TreeSitterFFI::Tree, 1)
        @tree_2 = @build.obj(TreeSitterFFI::Tree, 2)
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
