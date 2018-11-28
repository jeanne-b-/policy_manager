module PolicyManager::Concerns::PoliciesResource
  extend ActiveSupport::Concern
  included do
    has_many :terms, through: :user_terms, class_name: "PolicyManager::Term"
    has_many :users_terms, class_name: "PolicyManager::UsersTerm", as: :owner
    has_many :portability_requests, class_name: "PolicyManager::PortabilityRequest", as: :owner

    def signed_all_mandatory_terms?
      PolicyManager::Term.mandatory_for_user(self).where.not(id: self.users_terms.pluck(:term_id)).empty?
    end
  end
end
