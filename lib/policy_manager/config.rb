module PolicyManager
  class Config
    mattr_accessor :is_admin_method, :user_resource, :registery, :skip_portability_request_approval, :other_services

    def self.setup
      yield self
      self
      @@is_admin_method ||= -> (user) { user.is_admin? }
      @@user_resource ||= User
    end

    def self.is_admin?(user)
      @@is_admin_method.call(user) 
    end
  end
end
