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
    truthies = if instance_of?(Array)
                 my_select { |item| condition.call(item) }
               else
                 my_select { |_key, value| condition.call(value) }
               end
    truthies.length == length
  end
end
