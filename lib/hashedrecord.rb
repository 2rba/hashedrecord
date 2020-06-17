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

  def initialize(collection, access_method: nil)
    @collection = collection
    @collection_ids = !collection.empty? ? Array(0...collection.size) : []
    @index = {}
    @access_method = access_method
  end

  def call(chain = [])
    chain.inject(collection_ids) do |result, (params, method)|
      subsets = params.map do |key, value|
        unless index.key? key
          index[key] = collection_ids.group_by do |collection_id|
            get_value(collection[collection_id], key)
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

  attr_reader :collection_ids, :collection, :index, :access_method

  def get_value(record, key)
    if @access_method.nil?
      @access_method = if record.respond_to?(key)
                         ->(record, key) { record.send(key) }
                       elsif record.respond_to?(:[]) && record.respond_to?(:key)
                         if record.key? key
                           ->(record, key) { record.send(:[], key) }
                         elsif record.key? key.to_s
                           ->(record, key) { record.send(:[], key.to_s) }
                         end
         end
      raise 'Cannot determinate access method' if @access_method.nil?
    end
    access_method.call(record, key)
  end
end

require 'hashedrecord/filtered'
