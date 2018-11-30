module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:index], Term
      can [:show], Term do |t|
        t.published?
      end

      can [:api_create, :index], [PortabilityRequest, AnonymizeRequest]

      return if user.nil?

      can [:create], PortabilityRequest
      can [:cancel], PortabilityRequest do |pr|
        pr.owner == user and pr.may_cancel?
      end

      can [:sign], Term do |t|
        t.published? and t.kind.require_signing? and !t.signed_by?(user)
      end

      can [:create], AnonymizeRequest do |ar|
        PolicyManager::Config.can_ask_anonymization.call(user)
      end
      can [:cancel], AnonymizeRequest do |ar|
        ar.owner == user and ar.waiting_for_approval?
      end

      return unless PolicyManager::Config.is_admin?(user)

      can [:show, :index, :edit, :update, :new, :create], Term
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
