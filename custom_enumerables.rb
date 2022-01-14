# frozen_string_literal: true

# The same built-in Enumerable module with added methods
module Enumerable
  def my_each
    times = length
    index = 0
    times.times do
      yield(self[index])
      index += 1
    end
    self
  end
end
