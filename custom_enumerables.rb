# frozen_string_literal: true

require 'pry-byebug'

# The same built-in Enumerable module with added methods
module Enumerable
  def my_each
    times = length
    index = 0
    times.times do
      instance_of?(Array) ? yield(self[index]) : yield(keys[index], values[index])
      index += 1
    end
    self
  end

  def my_each_with_index
    times = length
    index = 0
    times.times do
      instance_of?(Array) ? yield(self[index], index) : yield(keys[index], values[index])
      index += 1
    end
    self
  end

  def my_select(&condition)
    if instance_of?(Array)
      truthies = []
      my_each { |item| truthies.push(item) if condition.call(item) }
    else
      truthies = {}
      my_each { |key, value| truthies[key] = value if condition.call(key, value) }
    end
    truthies
  end

  def my_all?(&condition)
    truthies = instance_of?(Array) ? my_select { |item| condition.call(item) } : my_select { |key, value| condition.call(key, value) }
    truthies.length == length
  end

  def my_any?(&condition)
    truthies = instance_of?(Array) ? my_select { |item| condition.call(item) } : my_select { |key, value| condition.call(key, value) }
    truthies.length.positive?
  end

  def my_none?(&condition)
    truthies = instance_of?(Array) ? my_select { |item| condition.call(item) } : my_select { |key, value| condition.call(key, value) }
    truthies.length.zero?
  end

  def my_count(*args, &condition)
    if block_given?
      instance_of?(Array) ? my_select { |item| condition.call(item) }.length : my_select { |key, value| condition.call(key, value) }.length
    elsif args.length == 1
      instance_of?(Array) ? my_select { |item| item == args[0] }.length : my_select { |_key, value| value == args[0] }.length
    else
      length
    end
  end

  def my_map(&block)
    if instance_of?(Array)
      result = []
      my_each { |item| result.push(block.call(item)) }
    else
      result = {}
      my_each { |key, value| result[key] = block.call(key, value) }
    end
    result
  end

  # does not work on hashes
  def my_inject(*args, &block)
    if args.length == 2
      initial_operand = [args[0]]
      operator = args[1]
    elsif args.length == 1
      case block_given?
      when false
        initial_operand = []
        operator = args[0]
      when true
        initial_operand = [args[0]]
      end
    elsif args.empty?
      initial_operand = []
    end
    result = initial_operand.empty? ? first : initial_operand.my_inject(operator)
    if block_given?
      to_a.my_each { |item| result == item ? next : result = block.call(result, item) }
    else
      to_a.my_each { |item| result == item ? next : result = result.method(operator).call(item) }
    end
    result
  end
end

puts((1..5).my_inject(10) { |acc, num| acc * num })
