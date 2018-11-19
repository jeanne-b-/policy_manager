module PolicyManager::Concerns::PoliciesResource
  extend ActiveSupport::Concern
  included do
    has_many :terms, through: :user_terms, class_name: "PolicyManager::Term"
    has_many :portability_requests, class_name: "PolicyManager::PortabilityRequest", as: :owner
  end
end
