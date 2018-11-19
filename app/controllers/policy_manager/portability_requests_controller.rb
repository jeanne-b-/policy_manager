module PolicyManager
  class PortabilityRequestsController < ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    def collection
      @portability_requests = PortabilityRequest.where(owner: User.current_user)
    end

    def create
      create! do |s, f|
        s.html { redirect_to collection_url }
        f.html { redirect_to collection_url }
      end
    end

    def permitted_params
      params.permit(portability_request: [:owner_id, :owner_type])
    end

    def begin_of_association_chain
      User.current_user
    end
  end
end
