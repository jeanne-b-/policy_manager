module PolicyManager
  class PortabilityMailer < ApplicationMailer

    def completed(portability_request_id)
      @portability_request = PortabilityRequest.find(portability_request_id)
      @user = @portability_request.owner
      @link = @portability_request.attachement_url
      
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.mails.completed.subject") }
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
