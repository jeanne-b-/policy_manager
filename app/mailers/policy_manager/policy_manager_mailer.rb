module PolicyManager
  class PolicyManagerMailer < ApplicationMailer
    include Rails.application.routes.url_helpers

    def send_mail opts
      delivery_method_options ||= {}
      if Rails.env.production?
        delivery_method_options.merge({ version: 'v3.1', api_key: 'ff30bb3f9ba9ad8f099696fa66afa074', secret_key: 'cc3f8c292c848d55d6137375dfa43652' })
      end

      mail(opts)
    end

    def portability_completed(portability_request_id)
      @portability_request = PortabilityRequest.find(portability_request_id)
      @user = @portability_request.owner
      @link = root_url + @portability_request.attachement_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.policy_manager_mailer.portability_completed.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      send_mail(opts)
    end

    def portability_requested(portability_request_id)
      @portability_request = PortabilityRequest.find(portability_request_id)
      @user = @portability_request.owner
      @link = policy_manager.portability_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.policy_manager_mailer.portability_requested.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      send_mail(opts)
    end

    def portability_denied(portability_request_id)
      @portability_request = PortabilityRequest.find(portability_request_id)
      @user = @portability_request.owner
      @link = policy_manager.portability_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.policy_manager_mailer.portability_denied.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      send_mail(opts)
    end

    def anonymize_requested(anonymize_request_id)
      @anonymize_request = AnonymizeRequest.find(anonymize_request_id)
      @user = @anonymize_request.owner
      @link = policy_manager.anonymize_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.policy_manager_mailer.anonymize_requested.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      send_mail(opts)
    end

    def anonymize_denied(anonymize_request_id)
      @anonymize_request = AnonymizeRequest.find(anonymize_request_id)
      @user = @anonymize_request.owner
      @link = policy_manager.anonymize_requests_url
      opts = { from: Config.from_email, to: @user.email, subject: I18n.t("policy_manager.policy_manager_mailer.anonymize_denied.subject") }
      opts.merge!({
      })
      
      set_mail_lang

      send_mail(opts)
    end

    private

    def set_mail_lang
      I18n.locale = Config.user_language.call(@user) || :en
    end

  end
end
