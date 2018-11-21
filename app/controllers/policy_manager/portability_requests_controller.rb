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

    def api_create
      render json: 'unauthorized', status: :unauthorized and return if params[:token] != PolicyManager::Config.token
      finder = PolicyManager::Config.finder rescue :id
      if params[:user] and @user = PolicyManager::Config.user_resource.find_by([[finder, params[:user]]].to_h)
        portability_request = @user.portability_requests.create(requested_by: 'api')
        if portability_request.errors.any?
          render json: portability_request.errors.full_messages.join(', '), status: 422
        else
          portability_request.approve!
          render json: 'ok'
        end
      else
        render json: 'not found', status: 404 and return
      end
    end

    def create
      create! do |s, f|
        s.html { redirect_to collection_url }
        f.html { redirect_to collection_url }
      end
    end

    def permitted_params
      params.permit(portability_request: [:notify_other_services])
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
