require "aasm"

module PolicyManager
  class PortabilityRequest < ApplicationRecord
    include AASM

    belongs_to :owner, polymorphic: true

    mount_uploader :attachement, AttachementUploader

    after_create :change_state_if_needed

    aasm column: :state do
      state :waiting_for_approval, :initial => true
      state :pending
      state :running
      state :done
      state :denied
      state :canceled
  
      event :approve, after: :generate_json do
         transitions :from => :waiting_for_approval, :to => :pending
      end

      event :cancel do
        transitions from: [:waiting_for_approval, :pending], :to => :canceled
      end

      event :deny do
        transitions :from => :waiting_for_approval, :to => :denied
      end
  
      event :run, after: :create_on_other_services do
        transitions :from => :pending, :to => :running
      end
      
      event :done, after: :notify_user do
        transitions :from => :running, :to => :done
      end
    end

    def change_state_if_needed
      self.approve! if Config.skip_portability_request_approval
    end

    def create_on_other_services
      return unless notify_other_services?
      Config.other_services.each do |name, _|
        call_service(name)
      end
    end

    def call_service(service)
      perform_async(service)
    end

    def async_call_service(service)
      response = Config.other_services[service.to_sym].call(owner).response
      case response.code.to_i
        when 200..299
        return response
      when 404
        raise NotFoundException, "service '#{service}' was unable to find given user"
      when 401
        raise UnauthorizedException, "service '#{service}' returned unauthorized"
      when 422
        raise UnprocessableException, "service '#{service}' cannot process params, and returned #{response.body}"
      when 500..599
        raise InternalErrorException, "endpoint '#{service}' have an internal server error, and returned #{response.body}"
      else
        raise UnknownErrorException, "endpoint '#{service}' returned unhandled status code (#{response.code}) with body #{response.body}, aborting."
      end
    end

    def notify_user
      PortabilityMailer.completed(self.id).deliver_now
    end

    def generate_json
      perform_async
    end

    def async_generate_json
      self.run! unless self.running?
      file_path = File.join(Rails.root, 'tmp', 'generate_data_dump')
      FileUtils.mkdir_p(file_path) unless File.exists?(file_path)
      file_name = File.join(file_path, "#{self.id.to_s}.json")
      file = File.new(file_name, 'w')

      user_data = Registery.new.data_dump_for(owner).to_json

      begin
        file.flush
        file.write(user_data)
        self.update(attachement: file)
      ensure
        File.delete(file)
      end
      self.done!
    end

  end
end
