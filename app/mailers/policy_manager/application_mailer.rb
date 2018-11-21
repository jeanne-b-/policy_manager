module PolicyManager
  class ApplicationMailer < ActionMailer::Base
    default from: Config.from_email
    layout 'policy_manager_mailer'

  end
end
