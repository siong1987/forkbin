class History
  include Mongoid::Document
  include Mongoid::Timestamps

  NEW = 0
  REORDER = 1
  ADD = 2
  DELETE = 3

  field :action, type: Integer, default: 0

  belongs_to :list
  embeds_many :items

  validates_presence_of :list

  class << self
    def add(list, type, items)
      history = History.new(list_id: list.id, action: type)
      items = items.map do |i|
        Item.new(k: i[:name], v: i[:checked])
      end
      history.items = items
      history.save
    end
  end
end
