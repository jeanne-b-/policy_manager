module PolicyManager
  class TermsController < PolicyManager::ApplicationController
    layout 'policy_manager'
    inherit_resources
    authorize_resource

    def collection
      if can? :create, Term
        @terms = Term.all
      else
        @terms = Term.published
      end
    end

    def sign
      users_term = @current_user.users_terms.where(term_id: resource.id).first_or_create
      users_term.update(signed_at: Time.zone.now)
      redirect_to :back, fallback: root_url
    end

    def publish
      resource.publish!
      redirect_to collection_url
    end

    def archive
      resource.archive!
      redirect_to collection_url
    end


    def permitted_params
      params.permit(term: [:target, :kind, terms_translations_attributes: [:id, :_destroy, :title, :locale, :content]])
    end
  end
end
