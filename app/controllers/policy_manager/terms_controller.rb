module PolicyManager
  class TermsController < PolicyManager::ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    def permitted_params
      params.permit(term: [:title, :content, :state, :locale])
    end
  end
end
