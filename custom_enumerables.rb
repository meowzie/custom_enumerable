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
end
