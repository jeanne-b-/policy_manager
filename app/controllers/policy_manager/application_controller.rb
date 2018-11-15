module PolicyManager
  class ApplicationController < ActionController::Base
    layout 'policy_manager'
    before_filter :merge_abilities

    private

    def merge_abilities
      current_ability.merge(PolicyManager::Ability.new(current_user))
    end
  end
end
