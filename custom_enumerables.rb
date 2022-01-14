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
    truthies = []
    my_each { |item| truthies.push(item) if condition.call(item) }
    truthies
  end
end
