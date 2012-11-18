class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  field :k
  field :v

  validates_presence_of :k
  validates_presence_of :v
  embedded_in :list
end
