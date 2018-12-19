module PolicyManager
  class PolicyManagerAdminMailer < ApplicationMailer
    include Rails.application.routes.url_helpers
    layout 'policy_manager_admin_mailer'

    def anonymize_requested(anonymize_request_id)
      @anonymize_request = AnonymizeRequest.find(anonymize_request_id)
      @user = @anonymize_request.owner
      @link = policy_manager.admin_anonymize_requests_url
      opts = { from: Config.from_email, to: Config.dpo_email, subject: I18n.t("policy_manager.policy_manager_admin_mailer.anonymize_requested.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      mail(opts)
    end

    private

    def set_mail_lang
      I18n.locale = :en
    end

  end
end
