module PolicyManager
  class CorrectionRequestsController < PolicyManager::ApplicationController
    layout 'policy_manager'
    authorize_resource

    def index
    end

  end
end
