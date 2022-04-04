# frozen_string_literal: true

require 'securerandom'

class Double
  attr_reader :expression

  def initialize(expression = nil, existing_expression: nil)
    @expression = expr_string(existing_expression, expression)
  end

  def to_s
    length = expression.length
    SecureRandom.hex(length)[1..length]
  end

  private def method_missing(method, *args, **kwargs)
    new_expression = build_expression(method, *args, **kwargs)
    self.class.new(new_expression, existing_expression: expression)
  end

  private def build_expression(method, *args, **kwargs)
    expr = method.to_s
    return expr unless args.any? || kwargs.any?

    args = args.map { |arg| modify_value(arg) }
    arguments = args + kwargs.map { |k, v| "#{k}: #{modify_value(v)}" }
    "#{expr}(#{arg_string(arguments)})"
  end

  private def arg_string(*args)
    return '' if args.empty?

    args = args.flatten
    args.compact.reject(&:empty?).join(', ')
  end

  private def expr_string(*exprs)
    return '' if exprs.empty?

    exprs = exprs.flatten
    exprs.compact.reject(&:empty?).join('.')
  end

  private def modify_value(value)
    case value
    when String
      "'#{value}'"
    when Symbol
      ":#{value}"
    else
      value.to_s
    end
  end
end
