module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:index], Term
      can [:show], Term do |t|
        t.published?
      end

      can [:index], [PortabilityRequest, AnonymizeRequest, CorrectionRequest]
      can [:api_create], [PortabilityRequest, AnonymizeRequest] if PolicyManager::Config.api_activated?

      return if user.nil?

      can [:sign], Term do |t|
        t.published? and t.kind.require_signing? and !t.signed_by?(user)
      end

      if PolicyManager::Config.can_ask_portability.call(user)
        can :new, PortabilityRequest
        can :create, PortabilityRequest do |pr|
          pr.owner == user
        end
        can :cancel, PortabilityRequest do |pr|
          pr.owner == user and pr.may_cancel?
        end
      end

      if PolicyManager::Config.can_ask_anonymization.call(user)
        can :new, AnonymizeRequest
        can :create, AnonymizeRequest do |ar|
          ar.owner == user
        end
        can :cancel, AnonymizeRequest do |ar|
          ar.owner == user and ar.waiting_for_approval?
        end
      end

      return unless PolicyManager::Config.is_admin?(user)

      can [:show, :edit, :update, :new, :create], Term
      can [:publish], Term do |t|
        t.may_publish?
      end
      can [:archive], Term do |t|
        t.may_archive?
      end

      can [:admin], [PortabilityRequest, AnonymizeRequest]
      can [:approve], [PortabilityRequest, AnonymizeRequest] do |object|
        object.may_approve?
      end
      can [:deny], [PortabilityRequest, AnonymizeRequest] do |object|
        object.may_deny?
      end
    end
  end
end
