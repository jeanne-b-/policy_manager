module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:show, :index], Term
      return if user.nil?

      return if PolicyManager::Config.is_admin?(user)
      can [:edit, :update, :new, :create], Term
    end
  end
end
