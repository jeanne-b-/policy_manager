module PolicyManager
  class Ability
    include ::CanCan::Ability

    def initialize(user)
      can [:index], Term
      can [:show], Term do |t|
        t.published?
      end
      can [:api_create], [PortabilityRequest, AnonymizeRequest]

      return if user.nil?

      can [:index, :create], PortabilityRequest
      can [:cancel], PortabilityRequest do |p|
        p.owner == user and p.may_cancel?
      end
      can [:sign], Term do |t|
        t.published? and t.kind.require_signing? and !t.signed_by?(user)
      end

      can [:index], AnonymizeRequest
      can [:create], AnonymizeRequest do |ar|
        PolicyManager::Config.can_ask_anonymization.call(user)
      end
      can [:cancel], PortabilityRequest do |ar|
        ar.owner == user and ar.waiting_for_approval?
      end

      return unless PolicyManager::Config.is_admin?(user)

      can [:show, :index, :edit, :update, :new, :create, :publish, :archive], Term
      can [:admin], PortabilityRequest
      can [:approve], PortabilityRequest do |p|
        p.may_approve?
      end
      can [:deny], PortabilityRequest do |p|
        p.may_deny?
      end

      can [:admin], AnonymizeRequest
      can [:approve], AnonymizeRequest do |ar|
        ar.may_approve?
      end
      can [:deny], AnonymizeRequest do |ar|
        ar.may_deny?
      end
    end
  end
end
