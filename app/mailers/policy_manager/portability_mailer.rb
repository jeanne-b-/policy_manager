module PolicyManager
  class PortabilityMailer < ApplicationMailer
    include Rails.application.routes.url_helpers

    def completed(portability_request_id)
      @portability_request = PortabilityRequest.find(portability_request_id)
      @user = @portability_request.owner
      @link = policy_manager.portability_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.mails.completed.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      mail(opts)
    end

    def anonymize_requested(anonymize_request_id)
      @anonymize_request = AnonymizeRequest.find(anonymize_request_id)
      @user = @anonymize_request.owner
      @link = policy_manager.anonymize_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.mails.anonymize_requested.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      mail(opts)
    end

    private

    def set_mail_lang
      I18n.locale = Config.user_language.call(@user) || :en
    end

  end
end
