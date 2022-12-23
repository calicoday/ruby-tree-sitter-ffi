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
  
  # extra :pointer types, so we never have autopointer or struct.ptr in layout
  typedef :pointer, :Tree_p
  typedef :pointer, :QueryCapture_p

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
  end

  class Range < BossFFI::BossStruct
    layout(
      :start_point, Point,
      :end_point, Point,
      :start_byte, :uint32_t,
      :end_byte, :uint32_t,
    )
  end

  class Input < BossFFI::BossStruct
    layout(
      :payload, :void_p,
      :read, callback([:void_p, :uint32_t, Point.by_value, :uint32_t_p], :pointer),
      :encoding, EnumInputEncoding,
    )
  end

  EnumLogType = enum(:parse, :lex)

  class Logger < BossFFI::BossStruct
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
  end

  class Node < BossFFI::BossStruct
    layout(
      :context, [:uint32_t, 4],
      :id, :void_p,
      :tree, :Tree_p,
#       :tree, :pointer,
#       :tree, Tree,
    )
  end

  class TreeCursor < BossFFI::BossStruct
    layout(
      :tree, :void_p, #:Tree_p??? api.h says void * but shd prob be Tree *!!!
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

#   class QueryMatch < BossFFI::BossStruct
  class QueryMatch < BossFFI::BossMixedStruct
    layout(
      :id, :uint32_t,
      :pattern_index, :uint16_t,
      :capture_count, :uint16_t,
      :captures, :QueryCapture_p,
#       :captures, :pointer,
#       :captures, QueryCapture,
    )
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
