class List
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String, default: ""
  field :is_public, type: Boolean, default: false

  validates_presence_of :name
  validates_length_of :name, maximum: 300

  belongs_to :parent
  belongs_to :user
  has_many :histories

  validates_presence_of :parent

  def items
    if self.histories.last
      self.histories.last.items
    else
      []
    end
  end

  def update_items(items)
    if self.histories.length == 0
      self.histories.add(self, History::NEW, items)
    else
      last_history = self.histories.last
      if last_history.items.length == items.length
        # reorder items
        self.histories.add(self, History::REORDER, items)
      elsif last_history.items.length < items.length
        # add item
        self.histories.add(self, History::ADD, items)
      elsif last_history.items.length > items.length
        # delete item
        self.histories.add(self, History::DELETE, items)
      end
    end
  end
end
