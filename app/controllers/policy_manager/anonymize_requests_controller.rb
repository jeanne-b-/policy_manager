module PolicyManager
  class AnonymizeRequestsController < PolicyManager::ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    custom_actions resource: [:cancel, :deny, :approve], collection: :admin

    def collection
      if params[:action] == "admin"
        @anonymize_requests = PolicyManager::AnonymizeRequest.waiting_for_approval
      else
        @anonymize_requests = PolicyManager::AnonymizeRequest.where(owner: @current_user).order(created_at: :desc)
      end
    end

    def api_create
      render json: 'unauthorized', status: :unauthorized and return if !params[:hash] or !params[:user]
      finder = PolicyManager::Config.finder rescue :id
      if @user = PolicyManager::Config.user_resource.find_by([[finder, params[:user]]].to_h)
        render json: 'unauthorized', status: :unauthorized and return unless PolicyManager::AnonymizeRequest.encrypted_params(@user.send(finder))[:hash] == params[:hash]
        anonymize_request = @user.anonymize_requests.create(requested_by: 'api')
        if anonymize_request.errors.any?
          render json: anonymize_request.errors.full_messages.join(', '), status: 422
        else
          anonymize_request.approve!
          render json: 'ok'
        end
      else
        render json: 'not found', status: 404 and return
      end
    end

    def create
      if params[:anonymize_request].blank? or params[:anonymize_request][:password].blank? or !current_user.valid_password?(params[:anonymize_request][:password])
        redirect_to anonymize_requests_path, flash: {error: "Wrong password."} and return
      end

      create! do |s, f|
        s.html { redirect_to anonymize_requests_path }
        f.html { redirect_to anonymize_requests_path, flash: {error: resource.errors.messages.values.join(', ')} }
      end
    end

    def permitted_params
      params.permit(anonymize_request: [:notify_other_services])
    end

    def begin_of_association_chain
      @current_user if params[:action] == 'create'
    end

    def approve
      resource.approve!
      redirect_to anonymize_requests_path
    end

    def cancel
      resource.cancel!
      redirect_to anonymize_requests_path
    end

    def deny
      resource.deny!
      redirect_to anonymize_requests_path
    end
  end
end
