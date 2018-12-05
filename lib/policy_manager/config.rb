module PolicyManager
  class Config
    # the method used in the controllers to get the logged user
    mattr_accessor :current_user_method
    @@current_user_method = :current_user

    # who can sign terms and ask for portability
    mattr_accessor :user_resource

    # sets the locale in the controller and used to fetch the correct term translation 
    mattr_accessor :user_language
    @@user_language ||= -> (user) { :en }

    # used to find the correct user when a portability / anonymize request is asked via API
    mattr_accessor :finder
    @@finder ||= :id

    # use your application stylesheet by default
    mattr_accessor :stylesheet
    @@stylesheet = 'application'

    # the method to check if a user can administrate
    mattr_accessor :is_admin_method
    @@is_admin_method = -> (user) { user.is_admin? }

    # each email will be sent from this email address
    mattr_accessor :from_email
    @@from_email = 'privacy@42.fr'

    # the method used to check if a user can ask for anonymization
    mattr_accessor :can_ask_anonymization
    @@can_ask_anonymization = -> (user) { false }

    # the method called on user to anonymize
    mattr_accessor :anonymize_method
    @@anonymize_method = :anonymize!

    # the registery represent which data will be be exported for a given user
    mattr_accessor :registery

    # if set to true, user can ask their data without an admin approving their request
    mattr_accessor :skip_portability_request_approval

    # These other services will be called if a anonymize request is sent
    # or if a user asks for it when requesting portability
    mattr_accessor :other_services

    # the token used to encrypt user data, give this so other services can call your api
    mattr_accessor :token

    # the default path to call on other services for portability
    mattr_accessor :portability_path
    @@portability_path = "/legal/portability_requests/api_create"

    # the default path to call on other services for anonymize
    mattr_accessor :anonymize_path
    @@anonymize_path = "/legal/anonymize_requests/api_create"


    def self.setup
      yield self
      self
      @@user_resource ||= User
      @@current_user_method = [@@current_user_method] unless @@current_user_method.is_a?(Array)
      @@other_services = @@other_services.deep_symbolize_keys unless !@@other_services.is_a?(Hash)
    end

    def self.api_activated?
      !@@token.blank?
    end

    def self.is_admin?(user)
      @@is_admin_method.call(user) 
    end
  end
end
