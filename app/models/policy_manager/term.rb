module PolicyManager
  class Term < ApplicationRecord
    validates_presence_of :title
    validates_presence_of :description
    validates_presence_of :state
  end
end
