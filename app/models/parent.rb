class Parent
  include Mongoid::Document
  field :fork_count, type: Integer, default: 0

  has_many :lists
end
