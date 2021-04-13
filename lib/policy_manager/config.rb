module PolicyManager
  class Config
    # the method used in the controllers to get the logged user
    mattr_accessor :current_user_method
    @@current_user_method = :current_user

    # You can disable sidekiq but tasks in the future won't be executed
    mattr_accessor :enable_sidekiq
    @@enable_sidekiq = true

    # the sidekiq queue used by the worker
    mattr_accessor :sidekiq_queue

    # who can sign terms and ask for portability
    mattr_accessor :user_resource

    # sets the locale in the controller and used to fetch the correct term translation 
    mattr_accessor :user_language
    @@user_language = ->(_user) { :en }

    # used to find the correct user when a portability / anonymize request is asked via API
    mattr_accessor :finder
    @@finder = :id

    # use your application stylesheet by default
    mattr_accessor :stylesheet
    @@stylesheet = 'application'

    # the method to check if a user can administrate
    mattr_accessor :is_admin_method
    @@is_admin_method = ->(user) { user.is_admin? }

    # each email will be sent from this email address
    mattr_accessor :from_email
    @@from_email = 'privacy@42.fr'

    # correction requests will be sent to this email
    mattr_accessor :dpo_email
    @@dpo_email = 'dpo@42.fr'

    # emails can be sent from mailjet or standard config
    mattr_accessor :mailjet
    @@mailjet = false

    # default config for api key and secret for mailjet
    mattr_accessor :mailjet_api_key
    mattr_accessor :mailjet_api_secret

    @@mailjet_api_key = ''
    @@mailjet_api_secret = ''

    # used to address the user in emails
    mattr_accessor :user_name_method
    @@user_name_method = :login

    # the method used to check if a user can ask for anonymization
    mattr_accessor :can_ask_anonymization
    @@can_ask_anonymization = ->(_user) { false }

    # the method used to check if a user can ask for portability
    mattr_accessor :can_ask_portability
    @@can_ask_portability = ->(_user) { false }

    # the method called on user to anonymize
    mattr_accessor :anonymize_method
    @@anonymize_method = :anonymize!

    # a proc called on portability request approval
    mattr_accessor :on_portability_approval

    # the registery represent which data will be be exported for a given user
    mattr_accessor :registery

    # if set to true, user can ask their data without an admin approving their request
    mattr_accessor :skip_portability_request_approval

    # These other services will be called if a anonymize request is sent
    # or if a user asks for it when requesting portability
    mattr_accessor :other_services
    @@other_services = {}

    # the token used to encrypt user data, give this so other services can call your api
    mattr_accessor :token

    # the default path to call on other services for portability
    mattr_accessor :portability_path
    @@portability_path = '/legal/portability_requests/api_create'

    # the default path to call on other services for anonymize
    mattr_accessor :anonymize_path
    @@anonymize_path = '/legal/anonymize_requests/api_create'

    def self.setup
      yield self
      self
      @@user_resource ||= User
      @@current_user_method = [@@current_user_method] unless @@current_user_method.is_a?(Array)
      if @@other_services.is_a?(Hash)
        @@other_services = @@other_services.deep_symbolize_keys
      else
        @@other_services = {}
      end
      if @@on_portability_approval and !(@@on_portability_approval.is_a?(Proc) and @@on_portability_approval.arity == 1)
        raise Exception.new('PolicyManager::Config.on_portability_approval should be a proc taking 1 parameter.')
      end
    end

    def self.api_activated?
      !@@token.blank?
    end

    def self.is_admin?(user)
      @@is_admin_method.call(user) 
    end
  end
end
