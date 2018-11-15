module PolicyManager
  class PortabilityRequest < ApplicationRecord
    belongs_to :user, class_name: Config.user_resource.to_s
  end
end
