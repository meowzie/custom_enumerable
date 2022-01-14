# frozen_string_literal: true

module Enumerable
  def my_each
    yield(self)
    self
  end
end
