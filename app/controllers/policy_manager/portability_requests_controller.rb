module PolicyManager
  class PortabilityRequestsController < PolicyManager::ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    custom_actions resource: [:cancel, :deny, :approve], collection: :admin

    def collection
      if params[:action] == "admin"
        @portability_requests = PolicyManager::PortabilityRequest.waiting_for_approval
      else
        @portability_requests = PolicyManager::PortabilityRequest.where(owner: @current_user).order(created_at: :desc)
      end
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
      @current_user if params[:action] == 'create'
    end

    def approve
      resource.approve!
      redirect_to collection_url
    end

    def cancel
      resource.cancel!
      redirect_to collection_url
    end

    def deny
      resource.deny!
      redirect_to collection_url
    end
  end
end
