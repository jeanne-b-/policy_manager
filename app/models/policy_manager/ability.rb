module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:show, :index], Term
      can [:api_create], PortabilityRequest
      return if user.nil?
      can [:index, :create], PortabilityRequest
      can [:cancel], PortabilityRequest do |p|
        p.owner == user and (p.waiting_for_approval? or p.pending?)
      end

      return unless PolicyManager::Config.is_admin?(user)
      can [:edit, :update, :new, :create], Term
      can [:admin], PortabilityRequest
      can [:deny, :approve], PortabilityRequest do |p|
        p.waiting_for_approval?
      end
    end
  end
end
