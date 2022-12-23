module TreeSitterFFI
  class LanguageSigs
    def api_h_version() '0.20.0' end
    def types_that_happen_ref
      %q%
        @build = TreeSitterFFI::SpecObjBuild.new
        @language_1 = @build.obj(TreeSitterFFI::Language, 1)
        @symbol_1 = @build.obj(:symbol, 1)
        @string_1 = @build.obj(:string, 1)
        @uint32_t_1 = @build.obj(:uint32_t, 1)
        @bool_1 = @build.obj(:bool, 1)
        @field_id_1 = @build.obj(:field_id, 1)
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
        ts_language_symbol_count: nil,
        ts_language_symbol_name: nil,
        ts_language_symbol_for_name: nil,
        ts_language_field_count: nil,
        ts_language_field_name_for_id: nil,
        ts_language_field_id_for_name: nil,
        ts_language_symbol_type: nil,
        ts_language_version: nil,
      }
    end
  end
end
