module PolicyManager
  class PortabilityRequestsController < ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    def index
      load '../policy_manager/lib/policy_manager/registery.rb'
      render json: Registery.new.data_dump_for(User.current_user)
    end

    def permitted_params
      params.permit(portability_request: [:user_id])
    end
  end
end
