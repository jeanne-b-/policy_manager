module PolicyManager
  class TermsController < ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    def permitted_params
      params.permit(term: [:title, :description, :state, :locale])
    end
  end
end
