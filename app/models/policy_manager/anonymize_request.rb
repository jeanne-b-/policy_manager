require "aasm"

module PolicyManager
  class AnonymizeRequest < ApplicationRecord
    include AASM

    belongs_to :owner, polymorphic: true
    after_create :notify_created

    validate :only_one_pending_request, on: :create

    def only_one_pending_request
      self.errors.add(:owner_id, :not_unique) if owner.anonymize_requests.where(state: [:waiting_for_approval, :pending, :running]).count > 0
    end

    aasm column: :state do
      state :waiting_for_approval, :initial => true
      state :pending
      state :running
      state :done
      state :denied
      state :canceled
  
      event :approve, after_commit: :create_on_other_services do
         transitions :from => :waiting_for_approval, :to => :pending
      end

      event :cancel do
        transitions from: :waiting_for_approval, :to => :canceled
      end

      event :deny, after_commit: :notify_denied do
        transitions :from => :waiting_for_approval, :to => :denied
      end
  
      event :run, after_commit: :anonymize do
        transitions :from => :pending, :to => :running
      end
      
      event :done do
        transitions :from => :running, :to => :done
      end
    end

    def notify_created
      return unless self.requested_by.nil?
      send_mail('anonymize_requested')
      send_admin_mail('anonymize_requested')
    end

    def notify_denied
      send_mail('anonymize_denied')
    end

    def create_on_other_services
      self.run! unless self.running?
      identifier = owner.send(PolicyManager::Config.finder)

      Config.other_services.each do |name, _|
        call_service(name, identifier)
      end
    end

    def call_service(service, identifier)
      perform_async({service: service, user: identifier})
    end

    def async_call_service(opts)
      service_name = opts['service']
      identifier = opts['user']
      service = Config.other_services[service_name.to_sym]
      body = AnonymizeRequest.encrypted_params(identifier, Config.other_services[service_name.to_sym][:token])
      if service.respond_to?('[]', :host) # services must have a host in configuration file
        response = HTTParty.post(service[:host] + Config.anonymize_path, body: body, timeout: 1.minute).response
      else
        return false
      end

      case response.code.to_i
        when 200..299
        return response
      when 404
        raise "service_name '#{service_name}' was unable to find given user"
      when 401
        raise "service_name '#{service_name}' returned unauthorized"
      when 422
        raise "service_name '#{service_name}' cannot process params, and returned #{response.body}"
      when 500..599
        raise "endpoint '#{service_name}' have an internal server error, and returned #{response.body}"
      else
        raise "endpoint '#{service_name}' returned unhandled status code (#{response.code}) with body #{response.body}, aborting."
      end
    end
 
    def self.encrypted_params(user_identifier, token = PolicyManager::Config.token)
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), token, user_identifier)
      {user: user_identifier, hash: hash}
    end

    def encrypted_params_for_service(service_name)
      user_identifier = owner.send(PolicyManager::Config.finder)
      AnonymizeRequest.encrypted_params(user_identifier, Config.other_services[service_name.to_sym][:token])
    end

    def my_encrypted_params
      user_identifier = owner.send(PolicyManager::Config.finder)
      AnonymizeRequest.encrypted_params(user_identifier)
    end

    def anonymize
      if defined?(Sidekiq)
        perform_async
      else
        async_anonymize
      end
    end

    def async_anonymize
      self.owner.send(PolicyManager::Config.anonymize_method)
      self.done!
    end

  end
end
