module PolicyManager
  class UsersTerm < ApplicationRecord
    belongs_to :owner, polymorphic: true
    belongs_to :term

  end
end
