module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:show, :index], Term
      can [:api_create], [PortabilityRequest, AnonymizeRequest]

      return if user.nil?

      can [:index, :create], PortabilityRequest
      can [:cancel], PortabilityRequest do |p|
        p.owner == user and (p.waiting_for_approval? or p.pending?)
      end
      can [:sign], Term do |t|
        !t.signed_by?(user)
      end

      can [:index], AnonymizeRequest
      can [:create], AnonymizeRequest do |ar|
        PolicyManager::Config.can_ask_anonymization.call(user)
      end
      can [:cancel], PortabilityRequest do |ar|
        ar.owner == user and ar.waiting_for_approval?
      end

      return unless PolicyManager::Config.is_admin?(user)

      can [:edit, :update, :new, :create, :publish, :archive], Term
      can [:admin], PortabilityRequest
      can [:deny, :approve], PortabilityRequest do |p|
        p.waiting_for_approval?
      end

      can [:admin], AnonymizeRequest
      can [:deny, :approve], AnonymizeRequest do |ar|
        ar.waiting_for_approval?
      end
    end
  end
end
