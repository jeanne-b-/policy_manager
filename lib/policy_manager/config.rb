module PolicyManager
  class Config
    mattr_accessor :is_admin_method, :can_ask_anonymization, :anonymize_method, :portability_path, :anonymize_path, :user_resource, :registery, :skip_portability_request_approval, :other_services,
    :token, :finder, :from_email, :user_language

    def self.setup
      yield self
      self
      @@is_admin_method ||= -> (user) { user.is_admin? }
      @@can_ask_anonymization ||= -> (user) { true }
      @@anonymize_method ||= :anonymize!
      @@user_resource ||= User
      @@from_email ||= 'privacy@42.fr'
      @@user_language ||= -> (user) {:en}
      @@finder ||= :id
      @@portability_path ||= "/policies/portability_requests/api_create"
      @@anonymize_path ||= "/policies/anonymize_requests/api_create"
    end

    def self.is_admin?(user)
      @@is_admin_method.call(user) 
    end
  end
end
