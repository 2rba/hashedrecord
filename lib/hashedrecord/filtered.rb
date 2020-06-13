# frozen_string_literal: true

class Hashedrecord
  class Filtered
    include Enumerable
    include ::HashedRecord::Chainable

    def initialize(parent, filter)
      @parent = parent
      @filter = filter
    end

    def call(child_filter = [])
      parent.call([filter] + child_filter)
    end

    private

    attr_reader :filter, :parent
  end
end
