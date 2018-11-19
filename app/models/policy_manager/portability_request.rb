require "aasm"

module PolicyManager
  class PortabilityRequest < ApplicationRecord
    include AASM

    belongs_to :owner, polymorphic: true

    mount_uploader :attachement, AttachementUploader

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
  
      event :run do
        transitions :from => :pending, :to => :running
      end
      
      event :done do
        transitions :from => :running, :to => :done
      end
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

      sleep(100)
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
