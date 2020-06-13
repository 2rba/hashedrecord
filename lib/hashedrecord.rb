# frozen_string_literal: true

class HashedRecord
  module Chainable
    def where(params)
      Hashedrecord::Filtered.new(self, [params, :&])
    end

    def not(params)
      Hashedrecord::Filtered.new(self, [params, :-])
    end

    def each(&block)
      if block_given?
        call.each(&block)
      else
        to_enum(:each)
      end
    end
  end

  include Enumerable
  include Chainable

  def initialize(collection)
    @collection = collection
    @collection_ids = collection.size > 0 ? Array(0...collection.size) : []
    @index = {}
  end

  def call(chain=[])
    chain.inject(collection_ids) do |result, (params, method)|
      subsets = params.map do |key, value|
        unless index.key? key
          index[key] = collection_ids.group_by do |collection_id|
            collection[collection_id].send(key)
          end
        end
          index[key].slice(*value).values.flatten(1)
      end
      subsets.inject(result) do |result, subset|
        result.send(method, subset)
      end
    end.map { |object_id| collection[object_id] }
  end

  private

  attr_reader :collection_ids, :collection, :index
end

require 'hashedrecord/filtered'
