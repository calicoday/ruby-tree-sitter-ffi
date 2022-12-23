require 'boss_ffi'

module TreeSitterFFI
  typedef :pointer, :void_p
  typedef :pointer, :char_p
  typedef :pointer, :uint32_t_p
  typedef :pointer, :size_t_p
  typedef :pointer, :waitwhatFILE_p
  typedef :pointer, :int_p
  
  typedef :uint16_t, :symbol
  typedef :uint16_t, :field_id

  class Language < BossFFI::BossPointer; end

  class Parser < BossFFI::BossPointer; end

  class Tree < BossFFI::BossPointer; end

  class Query < BossFFI::BossPointer; end

  class QueryCursor < BossFFI::BossPointer; end

  EnumInputEncoding = enum(:utf8, :utf16)

  EnumSymbolType = enum(:regular, :anonymous, :auxiliary)

  class Point < BossFFI::BossStruct
    layout(
      :row, :uint32_t,
      :column, :uint32_t,
    )

	  def copy_values(from) 
		  util_copy_values(from, [:row, :column])
    end
  end

  class Range < BossFFI::BossStruct
    layout(
      :start_point, Point,
      :end_point, Point,
      :start_byte, :uint32_t,
      :end_byte, :uint32_t,
    )

	  def copy_values(from) 
		  util_copy_values(from, [:start_point, :end_point, :start_byte, :end_byte])
    end
  end

#   class Input < BossFFI::BossStruct
  class Input < BossFFI::BossMixedStruct
    layout(
      :payload, :void_p,
      :read, callback([:void_p, :uint32_t, Point.by_value, :uint32_t_p], :pointer),
      :encoding, EnumInputEncoding,
    )
  end

  EnumLogType = enum(:parse, :lex)

#   class Logger < BossFFI::BossStruct
  class Logger < BossFFI::BossMixedStruct
    layout(
      :payload, :void_p,
      :log, callback([:void_p, EnumLogType, :string], :void),
    )
  end

  class InputEdit < BossFFI::BossStruct
    layout(
      :start_byte, :uint32_t,
      :old_end_byte, :uint32_t,
      :new_end_byte, :uint32_t,
      :start_point, Point,
      :old_end_point, Point,
      :new_end_point, Point,
    )

	  def copy_values(from) 
		  util_copy_values(from, [:start_byte, :old_end_byte, :new_end_byte,
		    :start_point, :old_end_point, :new_end_point])
    end
  end

  ### we don't want to copy Tree value, do we???!!!
  class Node < BossFFI::BossStruct
    layout(
      :context, [:uint32_t, 4],
      :id, :void_p,
      :tree, Tree,
    )

		def copy_values(from)
      util_copy_inline_array(:four_ints, from, 4)
# 		  util_copy_values(from, [:id, :tree]) # treat as data???
	    self[:id] = from[:id]
	    self[:tree] = from[:tree]    
		end

		def context=(v)
		  raise "context= expected Array of 4 Integers" unless v.is_a?(Array) && 
		    v.length == 4
		  v.each_with_index{|e, i| self[:context][i] = e}
		end

	  def context()
	    4.times.map{|i| self[:context][i]}
	  end

		# alias??? use ruby form not ts_???
		# consider the NullNode/NotANode/whatever!!!
		def ==(v)
			v = TreeSitterFFI::Node.new unless v
			TreeSitterFFI.ts_node_eq(self, v)
		end
				
		### alias for rubier -- AFTER overrides!!!
		alias_method :to_sexp, :string
  end

  class TreeCursor < BossFFI::BossStruct
    layout(
      :tree, :void_p,
      :id, :void_p,
      :context, [:uint32_t, 2],
    )
  end

  class QueryCapture < BossFFI::BossStruct
    layout(
      :node, Node,
      :index, :uint32_t,
    )
  end

  EnumQuantifier = enum(:zero, 0, :zero_or_more, :one, :one_or_more)

### changed from gend raw bc we need UnitMemory
#   class QueryMatch < BossFFI::BossStruct
  class QueryMatch < BossFFI::BossMixedStruct
    layout(
      :id, :uint32_t,
      :pattern_index, :uint16_t,
      :capture_count, :uint16_t,
      :captures, QueryCapture.ptr,
#       :captures, QueryCapture,
    )

    # for UnitMemory
    def keep_keys() [:captures] end
		
    def copy_values(from)
      unit_keeps = util_copy_values([:id, :pattern_index, :capture_count],
        {captures: from[:capture_count]}, from)
    end
    
    # shd this be tidy??? rusty???
    ###???def captures() self[:captures] || [] end
    def captures() 
      self[:capture_count] < 1 ||self[:captures].null? ? 
        [] : 
        self[:captures].burst(self[:capture_count]) 
    end
  end

  EnumQueryPredicateStepType = enum(:done, :capture, :string)

  class QueryPredicateStep < BossFFI::BossStruct
    layout(
      :type, EnumQueryPredicateStepType,
      :value_id, :uint32_t,
    )
  end

  EnumQueryError = enum(:none, 0, :syntax, :node_type, :field, :capture, :structure, :language)

end
